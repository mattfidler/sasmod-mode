;;; autorevertro.el --- revert buffers when files on disk change

;;
;; Modified from autorevert to retain the read-only attribute of the buffer.
;;

;; Copyright (C) 1997, 1998, 1999, 2001 Free Software Foundation, Inc.
;;
;; Made this a read-only auto-revertro mode.
;;

;; Author: Anders Lindgren <andersl@andersl.com>
;; Keywords: convenience
;; Created: 1997-06-01
;; Date: 1999-11-30

;; This file is part of GNU Emacs.

;; GNU Emacs is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:

;; Introduction:
;;
;; Whenever a file that Emacs is editing has been changed by another
;; program the user normally has to execute the command `revert-buffer'
;; to load the new content of the file into Emacs.
;;
;; This package contains two minor modes: Global Auto-Revertro Mode and
;; Auto-Revertro Mode.  Both modes automatically revert buffers
;; whenever the corresponding files have been changed on disk.
;;
;; Auto-Revertro Mode can be activated for individual buffers.
;; Global Auto-Revertro Mode applies to all file buffers.
;;
;; Both modes operate by checking the time stamp of all files at
;; intervals of `auto-revertro-interval'.  The default is every five
;; seconds.  The check is aborted whenever the user actually uses
;; Emacs.  You should never even notice that this package is active
;; (except that your buffers will be reverted, of course).

;; Usage:
;;
;; Go to the appropriate buffer and press:
;;   M-x auto-revertro-mode RET
;;
;; To activate Global Auto-Revertro Mode, press:
;;   M-x global-auto-revertro-mode RET
;;
;; To activate Global Auto-Revertro Mode every time Emacs is started
;; customise the option `global-auto-revertro-mode' or the following
;; line could be added to your ~/.emacs:
;;   (global-auto-revertro-mode 1)
;;
;; The function `turn-on-auto-revertro-mode' could be added to any major
;; mode hook to activate Auto-Revertro Mode for all buffers in that
;; mode.  For example, the following line will activate Auto-Revertro
;; Mode in all C mode buffers:
;;
;; (add-hook 'c-mode-hook 'turn-on-auto-revertro-mode)

;;; Code:

;; Dependencies:

(require 'timer)
(eval-when-compile (require 'cl))


;; Custom Group:
;;
;; The two modes will be placed next to Auto Save Mode under the
;; Files group under Emacs.

(defgroup auto-revertro nil
  "Revert individual buffers when files on disk change.

Auto-Revertro Mode can be activated for individual buffer.
Global Auto-Revertro Mode applies to all buffers."
  :group 'files)


;; Variables:

;; Autoload for the benefit of `make-mode-line-mouse-sensitive'.
;;;###autoload
(defvar auto-revertro-mode nil
  "*Non-nil when Auto-Revertro Mode is active.

Never set this variable directly, use the command `auto-revertro-mode'
instead.")

;;;###autoload
(defcustom global-auto-revertro-mode nil
  "When on, buffers are automatically reverted when files on disk change.

Set this variable using \\[customize] only.  Otherwise, use the
command `global-auto-revertro-mode'."
  :group 'auto-revertro
  :initialize 'custom-initialize-default
  :set '(lambda (symbol value)
	  (global-auto-revertro-mode (or value 0)))
  :type 'boolean
  :require 'autorevertro)

(defcustom auto-revertro-interval 5
  "Time, in seconds, between Auto-Revertro Mode file checks."
  :group 'auto-revertro
  :type 'integer)

(defcustom auto-revertro-stop-on-user-input t
  "When non-nil Auto-Revertro Mode stops checking files on user input."
  :group 'auto-revertro
  :type 'boolean)

(defcustom auto-revertro-verbose t
  "When nil, Auto-Revertro Mode will not generate any messages.

Currently, messages are generated when the mode is activated or
deactivated, and whenever a file is reverted."
  :group 'auto-revertro
  :type 'boolean)

(defcustom auto-revertro-mode-text " ARevO"
  "String to display in the mode line when Auto-Revertro Mode is active.

\(When the string is not empty, make sure that it has a leading space.)"
  :tag "Auto Revert Mode Text"		; To separate it from `global-...'
  :group 'auto-revertro
  :type 'string)

(defcustom auto-revertro-mode-hook nil
  "Functions to run when Auto-Revertro Mode is activated."
  :tag "Auto Revert Mode Hook"		; To separate it from `global-...'
  :group 'auto-revertro
  :type 'hook)

(defcustom global-auto-revertro-mode-text ""
  "String to display when Global Auto-Revertro Mode is active.

The default is nothing since when this mode is active this text doesn't
vary over time, or between buffers.  Hence mode line text
would only waste precious space."
  :group 'auto-revertro
  :type 'string)

(defcustom global-auto-revertro-mode-hook nil
  "Hook called when Global Auto-Revertro Mode is activated."
  :group 'auto-revertro
  :type 'hook)

(defcustom global-auto-revertro-non-file-buffers nil
  "*When nil only file buffers are reverted by Global Auto-Revertro Mode.

When non-nil, both file buffers and buffers with a custom
`revert-buffer-function' are reverted by Global Auto-Revertro Mode."
  :group 'auto-revertro
  :type 'boolean)

(defcustom global-auto-revertro-ignore-modes '(Info-mode)
  "List of major modes Global Auto-Revertro Mode should not check."
  :group 'auto-revertro
  :type '(repeat sexp))

(defcustom auto-revertro-load-hook nil
  "Functions to run when Auto-Revertro Mode is first loaded."
  :tag "Load Hook"
  :group 'auto-revertro
  :type 'hook)

(defvar global-auto-revertro-ignore-buffer nil
  "*When non-nil, Global Auto-Revertro Mode will not revert this buffer.

This variable becomes buffer local when set in any fashion.")
(make-variable-buffer-local 'global-auto-revertro-ignore-buffer)


;; Internal variables:

(defvar auto-revertro-buffer-list '()
  "List of buffers in Auto-Revertro Mode.

Note that only Auto-Revertro Mode, never Global Auto-Revertro Mode, adds
buffers to this list.

The timer function `auto-revertro-buffers' is responsible for purging
the list of old buffers.")

(defvar auto-revertro-timer nil
  "Timer used by Auto-Revertro Mode.")

(defvar auto-revertro-remaining-buffers '()
  "Buffers not checked when user input stopped execution.")


;; Functions:

;;;###autoload
(defun auto-revertro-mode (&optional arg)
  "Toggle reverting buffer when file on disk changes.

With arg, turn Auto Revert mode on if and only if arg is positive.
This is a minor mode that affects only the current buffer.
Use `global-auto-revertro-mode' to automatically revert all buffers."
  (interactive "P")
  (make-local-variable 'auto-revertro-mode)
  (put 'auto-revertro-mode 'permanent-local t)
  (setq auto-revertro-mode
	(if (null arg)
	    (not auto-revertro-mode)
	  (> (prefix-numeric-value arg) 0)))
  (if (and auto-revertro-verbose
	   (interactive-p))
      (message "Auto-Revertro Mode is now %s."
	       (if auto-revertro-mode "on" "off")))
  (if auto-revertro-mode
      (if (not (memq (current-buffer) auto-revertro-buffer-list))
	  (push (current-buffer) auto-revertro-buffer-list))
    (setq auto-revertro-buffer-list
	  (delq (current-buffer) auto-revertro-buffer-list)))
  (auto-revertro-set-timer)
  (when auto-revertro-mode
    (auto-revertro-buffers)
    (run-hooks 'auto-revertro-mode-hook))
  auto-revertro-mode)


;;;###autoload
(defun turn-on-auto-revertro-mode ()
  "Turn on Auto-Revertro Mode.

This function is designed to be added to hooks, for example:
  (add-hook 'c-mode-hook 'turn-on-auto-revertro-mode)"
  (auto-revertro-mode 1))


;;;###autoload
(defun global-auto-revertro-mode (&optional arg)
  "Revert any buffer when file on disk change.

With arg, turn Auto Revert mode on globally if and only if arg is positive.
This is a minor mode that affects all buffers.
Use `auto-revertro-mode' to revert a particular buffer."
  (interactive "P")
  (setq global-auto-revertro-mode
	(if (null arg)
	    (not global-auto-revertro-mode)
	  (> (prefix-numeric-value arg) 0)))
  (if (and auto-revertro-verbose
	   (interactive-p))
      (message "Global Auto-Revertro Mode is now %s."
	       (if global-auto-revertro-mode "on" "off")))
  (auto-revertro-set-timer)
  (when global-auto-revertro-mode
    (auto-revertro-buffers)      
    (run-hooks 'global-auto-revertro-mode-hook)))


(defun auto-revertro-set-timer ()
  "Restart or cancel the timer."
  (if (timerp auto-revertro-timer)
      (cancel-timer auto-revertro-timer))
  (if (or global-auto-revertro-mode auto-revertro-buffer-list)
      (setq auto-revertro-timer (run-with-timer auto-revertro-interval
					      auto-revertro-interval
					      'auto-revertro-buffers))
    (setq auto-revertro-timer nil)))


(defun auto-revertro-buffers ()
  "Revert buffers as specified by Auto-Revertro and Global Auto-Revertro Mode.

Should `global-auto-revertro-mode' be active all file buffers are checked.

Should `auto-revertro-mode' be active in some buffers, those buffers
are checked.

Non-file buffers that have a custom `revert-buffer-function' are
reverted either when Auto-Revertro Mode is active in that buffer, or
when the variable `global-auto-revertro-non-file-buffers' is non-nil
and Global Auto-Revertro Mode is active.

This function stops whenever there is user input.  The buffers not
checked are stored in the variable `auto-revertro-remaining-buffers'.

To avoid starvation, the buffers in `auto-revertro-remaining-buffers'
are checked first the next time this function is called.

This function is also responsible for removing buffers no longer in
Auto-Revertro mode from `auto-revertro-buffer-list', and for canceling
the timer when no buffers need to be checked."
  (let ((bufs (if global-auto-revertro-mode
		  (buffer-list)
		auto-revertro-buffer-list))
	(remaining '())
	(new '()))
    ;; Partition `bufs' into two halves depending on whether or not
    ;; the buffers are in `auto-revertro-remaining-buffers'.  The two
    ;; halves are then re-joined with the "remaining" buffers at the
    ;; head of the list.
    (dolist (buf auto-revertro-remaining-buffers)
      (if (memq buf bufs)
	  (push buf remaining)))
    (dolist (buf bufs)
      (if (not (memq buf remaining))
	  (push buf new)))
    (setq bufs (nreverse (nconc new remaining)))
    (while (and bufs
		(not (and auto-revertro-stop-on-user-input
			  (input-pending-p))))
      (let ((buf (car bufs)))
	(if (buffer-name buf)		; Buffer still alive?
	    (save-excursion
	      (set-buffer buf)
	      ;; Test if someone has turned off Auto-Revertro Mode in a
	      ;; non-standard way, for example by changing major mode.
	      (if (and (not auto-revertro-mode)
		       (memq buf auto-revertro-buffer-list))
		  (setq auto-revertro-buffer-list
			(delq buf auto-revertro-buffer-list)))
	      (when (and
		     (or auto-revertro-mode
			 (and
			  global-auto-revertro-mode
			  (not global-auto-revertro-ignore-buffer)
			  (not (memq major-mode
				     global-auto-revertro-ignore-modes))))
		     (not (buffer-modified-p))
		     (if (buffer-file-name)
			 (and (file-readable-p (buffer-file-name))
			      (not (verify-visited-file-modtime buf)))
		       (and revert-buffer-function
			    (or (and global-auto-revertro-mode
				     global-auto-revertro-non-file-buffers)
				auto-revertro-mode))))
		(if auto-revertro-verbose
		    (message "Reverting buffer `%s'." buf))
		(revert-buffer t t t)
		;;
		;; Make read only (MLF)
		;;
		(setq buffer-read-only t)
		))
	  ;; Remove dead buffer from `auto-revertro-buffer-list'.
	  (setq auto-revertro-buffer-list
		(delq buf auto-revertro-buffer-list))))
      (setq bufs (cdr bufs)))
    (setq auto-revertro-remaining-buffers bufs)
    ;; Check if we should cancel the timer.
    (when (and (not global-auto-revertro-mode)
	       (null auto-revertro-buffer-list))
      (cancel-timer auto-revertro-timer)
      (setq auto-revertro-timer nil))))


;; The end:

(unless (assq 'auto-revertro-mode minor-mode-alist)
  (push '(auto-revertro-mode auto-revertro-mode-text)
	minor-mode-alist))
(unless (assq 'global-auto-revertro-mode minor-mode-alist)
  (push '(global-auto-revertro-mode global-auto-revertro-mode-text)
	minor-mode-alist))

(provide 'autorevertro)

(run-hooks 'auto-revertro-load-hook)

;; This makes it possible to set Global Auto-Revertro Mode from
;; Customize.
(if global-auto-revertro-mode
    (global-auto-revertro-mode 1))

;;; autorevertro.el ends here
