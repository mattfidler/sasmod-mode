(defgroup sasmod-templates nil
  "Options about SAS Templates"
  :group 'sasmod-mode
  )
(defun sasmod-get-sasmod-version-text()
  "Gets the sasmod version text."
  (let (
	(len (length sasmod-sas-versions))
	(i 0)
	(ret nil)
	(not-first nil)
	(ver sasmod-sas-version)
	(vertxt "")
	(verreg "")
	)
    (while (not ret)
      (setq vertxt "")
      (setq verreg "")
      (setq i 0)
      (while (and (< i len) (not ret))
	(if (= ver (nth 0 (nth i sasmod-sas-versions)))
	    (setq ret (nth 1 (nth i sasmod-sas-versions)))
	  (setq vertxt (concat vertxt (number-to-string (nth 0 (nth i sasmod-sas-versions))) ", "))
	  (setq verreg (concat verreg (number-to-string (nth 0 (nth i sasmod-sas-versions))) "\\|"))
	  )
	(setq i (+ i 1))
	)
      (if ret nil
	(setq vertxt (substring vertxt 0 -2))
	(setq verreg (concat "^\\(" (substring verreg 0 -2) "\\)$"))
	(setq ver nil)
	(while (not ver)
	  (if not-first
	      (setq ver (read-string (format "Invalid version, choose a version (%s):" vertxt)))
	    (setq ver (read-string (format "Choose a version (%s):" vertxt)))
	    (setq not-first 't)
	    )
	  (if (not (string-match verreg ver))
	      (setq ver nil)
	    (setq ver (string-to-number ver))
	    )
	  )
	)
      )
    (setq ret (sasmod-get-comment-padded-item (concat "Written for use with SAS version " ret ".")))
    (symbol-value 'ret)
    )
  )
(defun sasmod-insert-new-buffer-strings()
  "Insert new buffer template."
  (interactive)
  (let (
	(buf sasmod-empty-template)
	(name (sasmod-get-comment-padded-item sasmod-template-name-tag))
	(date-user (sasmod-get-comment-padded-item (concat 
		    (format-time-string "%a %b %d %T %Z %Y")
		    " "
		    (or (and (boundp 'user-full-name) user-full-name) (user-full-name))
		    " ("
		    (user-login-name)
		    ")")))
	(sasv (sasmod-get-sasmod-version-text))
	)
    (if (string-match (regexp-quote "(date-user)") buf)
	(setq buf (replace-match date-user nil nil buf))
      )
    (if (string-match (regexp-quote "(sasv)") buf)
	(setq buf (replace-match sasv nil nil buf))
      )
    (if (string-match (regexp-quote "(name)") buf)
	(setq buf (replace-match name nil nil buf))
      )
    (insert buf)
    )
  )
(defun sasmod-get-comment-padded-item (arg)
  (let (
	(b sasmod-template-comment-begin)
	(e sasmod-template-comment-end)
	(ln sasmod-template-comment-len)
	(ret "")
	(a (concat "" arg))
	 )
    (setq ln (- ln (+ (length b) (length e))))
    (if (> (length a) ln)
	(setq ret (concat b arg e))
      (setq ret (concat b arg (make-string (- ln (length a) ) ? ) e))
      )
    (symbol-value 'ret)
    )
  )

(defun sasmod-update-file-header()
  "Updating Header information."
  (interactive)
  (if (not sasmod-do-write-file-hooks) nil 
    (sasmod-update-nameF)
    (sasmod-add-modF)
    )

  nil)
(defun sasmod-add-modF()
  "Adding new user modification if necessacary."
  (let (
	(sasmod-name-start (concat
			    sasmod-template-comment-begin
			    sasmod-template-name-tag
			    ))
	(date-user (sasmod-get-comment-padded-item (concat 
		    (format-time-string "%a %b %d %T %Z %Y")
		    " "
		    (or (and (boundp 'user-full-name) user-full-name) (user-full-name))
		    " ("
		    (user-login-name)
		    ")")))
	)
    (save-excursion
      (goto-char (point-min))
      (if (re-search-forward (format "%s.*%s.*%s"
				     (regexp-quote sasmod-template-comment-begin)
				     (regexp-quote (concat "(" (user-login-name) ")"))
				     (regexp-quote sasmod-template-comment-end)) nil t) nil
	;; Not found, add
	(if (not (search-forward sasmod-name-start nil t)) nil
	  (end-of-line)
	  (insert "\n")
	  (insert date-user)
	  )
	)
      )
    )
  )
(defun sasmod-update-nameF()
  "Update the file name"
  (let (
	(sasmod-name-start (concat
			    sasmod-template-comment-begin
			    sasmod-template-name-tag
			    ))

	(sasmod-name-stop sasmod-template-comment-end)
	)
    (save-excursion
      (goto-char (point-min))
      (if (not (search-forward sasmod-name-start nil t))
	  (message "File Name not found.")
	(let ((ts-start (+ (point) ))
	      (ts-end (if (search-forward sasmod-name-stop nil t)
			  (- (point) (length sasmod-name-stop))
			nil)))
	  (if (not ts-end)
	      (message "File Name Deliminator not found")
	    ;;
	    ;; First check to see if the name is the same.
	    ;;
	    (goto-char ts-start)
	    (beginning-of-line)
	    (setq ts-start (point))
	    (end-of-line)
	    (setq ts-end (point))
	    (delete-region ts-start ts-end)
	    (goto-char ts-start)
	    (insert (sasmod-get-comment-padded-item (concat 
						     sasmod-template-name-tag
						     " "
						     (buffer-file-name)
						     )
						    )
		    )
	    )
	  )
	)
      )
    )
  )


(defcustom sasmod-sas-versions 
  '(
    (6 "6.12" "/misc/apps/bin/sas6")
    (8 "8.2" "/misc/apps/bin/sas8")
    (9 "9.1" "/misc/apps/bin/sas9")
    )
  " * This defines the versions that SASmod knows about as well as their corresponding minor verson numbers."
  :type '(repeat
	  (list
	   (integer :tag "Major Version Number")
	   (string :tag "Major/Minor version description")
	   (string :tag "Command Line to run SAS version")
	   )
	  )
  :group 'sasmod-template
  )
(defcustom sasmod-template-comment-begin "/* "
  " * Defines what is used to begin a template for Inserting the empty buffer."
  :type 'string
  :group 'sasmod-template
  )
(defcustom sasmod-template-comment-end "*/"
  " * Defines what is used to begin a template for Inserting the empty buffer."
  :type 'string
  :group 'sasmod-template
  )

(defcustom sasmod-template-comment-len 79
  " * Defines the total length of the column for template insertion"
  :type 'integer
  :group 'sasmod-template
  )
(defcustom sasmod-template-name-tag "Name:"
  " * Defines what to look for when updating the file name."
  :type 'string
  :group 'sasmod-template
  )

(defcustom sasmod-empty-template
"/*!*************************************************************************!*/
(name)
(date-user)
(sasv)
/*---------------------------------------------------------------------------*/
/*                                                                           */
/* PURPOSE:                                                                  */
/*                                                                           */
/*                                                                           */
/*                                                                           */
/* INPUT FILES:                                                              */
/*                                                                           */
/*                                                                           */
/*                                                                           */
/* OUTPUT FILES:                                                             */
/*                                                                           */
/*                                                                           */
/*                                                                           */
/*!*************************************************************************!*/

"
" * Defines the template used for creating a new file.
(name) is replaced with the file name with
(date-user) is replaced with the date and user information
(sasv) is the SAS version used.
"
:type 'string
:group 'sasmod-templates
)

(provide 'sasmod-templates)