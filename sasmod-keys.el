(require 'easymenu)
(defvar sasmod-mode-map
  (let ((sasmod-mode-map (make-keymap)))
    (define-key sasmod-mode-map "\M-q" 'sasmod-rebox-part)
    (define-key sasmod-mode-map "\M-\t" 'sasmod-complete-tag)
;;    (define-key sasmod-mode-map "\M-c" 'sasmod-complete-tag)
    (define-key sasmod-mode-map "\M-\C-q" 'sasmod-rebox-full)
    (define-key sasmod-mode-map "\C-c\M-q" 'sasmod-comment-region-part)
    (define-key sasmod-mode-map "\C-c\M-\C-q" 'sasmod-comment-region-full)
    (define-key sasmod-mode-map "\C-c\C-q" 'sasmod-uncomment)
    (define-key sasmod-mode-map "\C-q" 'sasmod-comment)
    (define-key sasmod-mode-map "\C-c\C-c" 'sasmod-compile)
    (define-key sasmod-mode-map "\C-c\C-o" 'sasmod-log-file)
    (define-key sasmod-mode-map "\C-c\C-l" 'sasmod-lst-file)
;;    (define-key sasmod-mode-map "\C-t\C-c" 'tempo-template-sasmod-cntit)
    (define-key sasmod-mode-map "\C-c\C-f" 'sasmod-toggle-dd) 
    (define-key sasmod-mode-map "\C-c\C-r" 'sasmod-graphic-template)
    (define-key sasmod-mode-map "\C-c\C-w" 'rebox-toggle-wrap)
    (define-key sasmod-mode-map "\C-e" 'sasmod-end-of-line)
    (define-key sasmod-mode-map "\C-i" 'sasmod-tab)
    (define-key sasmod-mode-map "\C-m" 'sasmod-mode-return)
    sasmod-mode-map)
  "Keymap for SAS(MLF) major mode")

(defvar sasmod-mode-map-cua
  (let ((sasmod-mode-map (make-keymap)))
    (define-key sasmod-mode-map "\M-q" 'sasmod-rebox-part)
    (define-key sasmod-mode-map "\M-\t" 'sasmod-complete-tag)
    (define-key sasmod-mode-map "\M-c" 'sasmod-complete-tag)
    (define-key sasmod-mode-map "\M-\C-q" 'sasmod-rebox-full)
    (define-key sasmod-mode-map "\C-t\M-q" 'sasmod-comment-region-part)
    (define-key sasmod-mode-map "\C-t\M-\C-q" 'sasmod-comment-region-full)
    (define-key sasmod-mode-map "\C-t\C-q" 'sasmod-uncomment)
    (define-key sasmod-mode-map "\C-t\C-w" 'rebox-toggle-wrap)
    (define-key sasmod-mode-map "\C-q" 'sasmod-comment)
    (define-key sasmod-mode-map "\C-a\C-c" 'sasmod-compile)
    (define-key sasmod-mode-map "\C-a\C-a" 'sasmod-log-file)
    (define-key sasmod-mode-map "\C-a\C-l" 'sasmod-lst-file)
    (define-key sasmod-mode-map "\C-t\C-c" 'tempo-template-sasmod-cntit)
    (define-key sasmod-mode-map "\C-t\C-d" 'sasmod-toggle-dd)
    (define-key sasmod-mode-map "\C-t\C-r" 'sasmod-graphic-template)
    (define-key sasmod-mode-map "\C-e" 'sasmod-end-of-line)
    (define-key sasmod-mode-map "\C-i" 'sasmod-tab)
    (define-key sasmod-mode-map "\C-m" 'sasmod-mode-return)
    sasmod-mode-map)
  "Keymap for SAS(MLF) major mode")

(defvar saslog-mode-map
  (let ((saslog-mode-map (make-keymap)))
    (define-key saslog-mode-map "\C-c\C-c" 'saslog-sas-file)
    (define-key saslog-mode-map "\C-l" 'saslog-lst-file)
    (define-key saslog-mode-map "\C-e" 'saslog-error)
    (define-key saslog-mode-map "\M-e" 'saslog-error-p)
    (define-key saslog-mode-map "\C-w" 'saslog-warning)
    (define-key saslog-mode-map "\M-w" 'saslog-warning-p)
    (define-key saslog-mode-map "\C-c\C-o" 'saslog-work)
    (define-key saslog-mode-map "\C-c\M-o" 'saslog-work-p)
    saslog-mode-map)
  "Keymap for SAS Log(MLF) major mode")

(defvar saslog-mode-map-cua
  (let ((saslog-mode-map (make-keymap)))
    (define-key saslog-mode-map "\C-a" 'saslog-sas-file)
    (define-key saslog-mode-map "\C-l" 'saslog-lst-file)
    (define-key saslog-mode-map "\C-e" 'saslog-error)
    (define-key saslog-mode-map "\M-e" 'saslog-error-p)
    (define-key saslog-mode-map "\C-w" 'saslog-warning)
    (define-key saslog-mode-map "\M-w" 'saslog-warning-p)
    (define-key saslog-mode-map "\C-b" 'saslog-work)
    (define-key saslog-mode-map "\M-b" 'saslog-work-p)
    saslog-mode-map)
  "Keymap for SAS Log(MLF) major mode")

(defvar saslst-mode-map
  (let ((saslst-mode-map (make-keymap)))
    (define-key saslst-mode-map "\C-c" 'saslst-sas-file)
    (define-key saslst-mode-map "\C-l" 'saslst-log-file)
    saslst-mode-map)
  "Keymap for SAS Lst(MLF) major mode")

(defvar saslst-mode-map-cua
  (let ((saslst-mode-map (make-keymap)))
    (define-key saslst-mode-map "\C-a" 'saslst-sas-file)
    (define-key saslst-mode-map "\C-l" 'saslst-log-file)
    saslst-mode-map)
  "Keymap for SAS Lst(MLF) major mode")

(defun sasmod-customize-sasmod ()
  "Customize Nonmem"
  (interactive)
  (customize-group "sasmod-mode")
  )

(defun sasmod-menu-setup ()
  (setq sasmod-mode-menu
	'("SASMOD"
	  ("Commenting"
	   ["Rebox" sasmod-rebox-part t]
	   ["Rebox -- Full size" sasmod-rebox-full t]
	   ["Toggle Wrapping" rebox-toggle-wrap t]
	   "--"
	   ["Comment Region" sasmod-comment-region t]
	   ["Uncomment Region" sasmod-uncomment t]
	   )
	  ("Files"
	   ["Log File" sasmod-log-file t]
	   ["Lst File" sasmod-lst-file t]
	   )
	  ("Templates"
	   ["Graphic Template" sasmod-graphic-template t]
	   )
	  "--"
	  ["Indent Region" indent-region t]
	  "--"
	  ["Compile" sasmod-compile t]
	  ["Customize SASmod-mode" sasmod-customize-sasmod t]
	   )
	  )
  (easy-menu-define sasmod-mode-menu sasmod-mode-map "SASMOD mode menu"
		    sasmod-mode-menu
		    )
  (easy-menu-add sasmod-mode-menu sasmod-mode-map)

  )

(provide 'sasmod-keys)