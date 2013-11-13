(eval-and-compile
  (condition-case ()
      (require 'custom)
    (error nil))
  (if (and (featurep 'custom)
	   (fboundp 'custom-declare-variable)
	   (fboundp 'custom-initialize-set)
	   (fboundp 'custom-handle-keyword))
      nil ;; We've got what we needed
    ;; We have the old custom-library, hack around it!
    (setq lc-custom-p nil)
    (defmacro defgroup (&rest args)
      nil)
    (defmacro defface (var values doc &rest args)
      (` (make-face (, var))))
    (defmacro defcustom (var value doc &rest args) 
      (` (defvar (, var) (, value) (, doc))))))

(defgroup sasmod-mode nil
  "SASmod mode;  Major mode for SAS."
  )

;(defcustom sasmod-magic-p nil
;  "* This defines if p starts compelting the lightning procedures."
;  :type 'boolean
;  :group 'sasmod-mode
;  )
(defcustom sasmod-sas-version 0
  "* This defines the sas version used."
  :type 'integer
  :group 'sasmod-mode
  )
(defcustom sasmod-goto-log-on-compile nil
  "* If not nill, then sasmod goes to the log file on a compile."
  :type 'boolean
  :group 'sasmod-mode
  )
(defcustom usefulldir nil
  "* If not nil, then sasmod uses the full directory instead of .. when autocompleting."
  :type 'boolean
  :group 'sasmod-mode
  )
;;
;; Allows extra things to be put on the end of the template.
;;
;(defcustom sasmod-extra-template ""
;  "* If not nill, this variable is appended to the current template."
;  :type 'string
;  :group 'sasmod-mode
;  )

(defcustom sasmod-play-with-cua nil
  "* If not nil, this variable changes the keybindings to be kind to people with CUA (i.e. PC-like copy and paste) preferences."
  :type 'boolean
  :group 'sasmod-mode
  )

;;
;; Allows extra user-specific code-completion cookes to be added to the startup.
;;
(defcustom sasmod-extra-completion '(
				     )
  "* This is a list of user completions that are automatically available for SAS."


  :type '(repeat
	  (list :tag "" 
		(string :tag "Completion Text (i.e. what you need to type for completion to get the template.)")
		(list :tag "" (string :tag "Template"))
		)
	  )
  :group 'sasmod-mode
  )

(defcustom sasw nil
  "* If not nil, then sasmod and others will open a window instead of just changing the buffer."
  :type 'boolean
  :group 'sasmod-mode
  )

(defcustom sasmod-play-with-flyspell nil
  "* Plays well with flyspell's meta-tab when non-nil"
  :type 'boolean
  :group 'sasmod-mode
  )

(defcustom sasmod-build-new-buffer 't
  "*If not nil, then sasmod-mode will insert sasmod-mode-new-buffer-strings
when new buffers are generated"
  :type 'boolean
  :group 'sasmod-mode
  )

;(defcustom sasmod-update-name 't
;  "*If non-nill, then SASmod mode updates the file name upon saving."
;  :type 'boolean
;  :group 'sasmod-mode
;  )

;(defcustom sasmod-updatebox 't
;  "*If non-nill refill the box upon save."
;  :type 'boolean
;  :group 'sasmod-mode
;  )

;(defcustom sasmod-compile-on-save nil
;  "* If non-nill sas compiles upon each save."
;  :type 'boolean
;  :group 'sasmod-mode
;  )

;(defcustom sasmod-update-mod 't
;  "*If non-nill, then SASmod mode updates what person last modified the file."
;  :type 'boolean
;  :group 'sasmod-mode
;  )

(defcustom sasmod-do-write-file-hooks 't
  "*If not nil, then sasmod-mode will modify the local-write-file-hooks
to do timestamps."
  :type 'boolean
  :group 'sasmod-mode
)

;(defcustom sasmod-do-backup 't
;  "*If non-nil, then sasmod-mode will write a backup based on the user name."
;  :type 'boolean
;  :group 'sasmod-mode
;  )

;(defcustom sasmod-input-directory nil
;  "* If non-nil, specifies the input directory used."
;  :type 'boolean
;  :group 'sasmod-mode
;  )

;(defcustom sasmod-output-directory nil
;  "* If non-nil, specifies the output directory used."
;  :type 'boolean
;  :group 'sasmod-mode
;  )

(defcustom sasmod-use-lightning 't
  "* If non-nill, sasmod uses lightning completion."
  :type 'boolean
  :group 'sasmod-mode
  )

(defcustom sasmod-whole-completion 't
  "* If non-nil, sasmod completes statements like univariates type= with type= (alpha= beta=), otherwise when pressing tab, just a message shows up."
  :type 'boolean
  :group 'sasmod-mode
  )

(defcustom sasmod-tab-width 4
  "* Defines the tab with for the SASMOD tabs."
  :type 'integer
  :group 'sasmod-mode)
(defcustom sasmod-tab-if-else-width 2
  "* Defines the tab with for the SASMOD if/else tabs."
  :type 'integer
  :group 'sasmod-mode)
(defcustom sasmod-indent-end-to-match-do nil
  "* If true, the do and end line up with one another when code is of the form:
if a then
  do;
    statment;
    statement;
  end;
else ...

If nil (false), the do and end line up for the following type of code:
if a then do;
    statment;
    statment;
end;
else ...
"
  :type 'boolean
  :group 'sasmod-mode)


(defcustom sasmod-add-semicolon-at-end-of-line nil
  "* Defines if you wish to add a semicolon at the end of the current line."
  :type 'boolean
  :group 'sasmod-mode)

(defcustom sasmod-add-run-quit 0
  "* Defines if you wish to add a quit at the end of the line"
  :type '(choice :tag "Adding quit options"
		(const :tag "Do not add quit/run" 0)
		(const :tag "Add quit/run with semicolon after proc xxx;" 1)
		(const :tag "Add quit/run without semicolon after proc xxx" 2)
		)
  :group 'sasmod-mode)
(provide 'sasmod-options)