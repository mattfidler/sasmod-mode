;;
;; Flags/State variables
;;
(defvar sasmod-mode-hook nil)
(defvar sasmod-get-sasuser nil)
(defvar sasmod-completing-options-flag 't)
(defvar sasmod-last-proc nil)
(defvar sasmod-last-del-par nil)
(defvar sasmod-last-return-pos "")
(defvar sasmod-magic-p nil) ; Defined so it won't complain.  Should go back but pressed for time MLF 5Nov2007
(defvar sasmod-dot-dot nil
  "* This is a tempoary varible used to store the ../ directory per SAS file.") ;; One directory down.
(defvar sasmod-dsn "") ;; DSN ring;
(defvar sasvt nil)
(defvar tfn nil)
(defvar hsze nil)
(defvar vsze nil)
(defvar np nil)
(defvar tcat "platesn.graphtmp")
(defvar ttemp nil)
(defvar ttfn nil)
(defvar sasmod-sticky-statement-temp nil)
;;
;; Alists
;;
(defvar sasmod-libref-local
  '(
    )
  "Alist of local libraries."
  )
(defvar sasmod-libref-ext
  '(
    )
  "Alist of external libraries."
  )

(defvar sasmod-dsn-local
  '(
    )
  "Alist of data sources."
  ) ;;DSN ring
(defvar sasmod-dsn-ext
  '(
    )
  "Alist of external data sources."
)

(defvar sasmod-includes
  '(
    )
  "A list of included files in the current list of local files and what not."
)

;;
;; Variables defining behavior
;;
(defvar sasmod-prog-text-faces
  '(font-lock-string-face font-lock-comment-face font-lock-doc-face)
  "Faces corresponding to text in sasmod-mode buffers.")
;;
;; Regular expression completion variables
;;

;;
;; SAS dataset file names
;;
(defvar sasmod-reg-filen "\\.[Ss]\\([Ss][Dd]01\\|[Aa][Ss]7[Bb][Dd][Aa][Tt]\\)$")
(defvar sasmod-reg-cat-filen "\\.[Ss][Aa][Ss]7[Bb][Cc][Aa][Tt]$")

(defvar sasmod-reg-complete-msg "^(\\([^)]*\\))")
(defvar sasmod-reg-complete-msg-inside "\\[\\([^]]*\\)\\]")
(defvar sasmod-next-statement ";[ \t\n]*\\([a-z][_a-z0-9]*\\)")

;;
;; Regular expressions to extract variables from a file.
;;
(defvar sasmod-reg-variable- "\\([a-z][_a-z0-9]*?\\)\\([0-9]+\\)-\\1?\\([0-9]+\\)")
(defvar sasmod-reg-variable "\\([a-z][_a-z0-9]+\\)")

(defvar sasmod-reg-variable-input ";[ \t\n]*input")
;;
;; Added drop and keep to statements to keep parsing to a minimum.
;; Also add any other statments that may contain just variables...
;;
(defvar sasmod-reg-variable-rename ";[ \t\n]*\\(rename\\|drop\\|keep\\|var\\|id\\)")
(defvar sasmod-reg-variable-rename-eq "[( \t\n]+rename=(")
(defvar sasmod-reg-variable-keep-drop "[( \t\n]+\\(drop\\|keep\\)=")
(defvar sasmod-reg-variable-keep-drop-end "\\(?:[a-z]+=\\|)\\)")
(defvar sasmod-reg-variable-define ";[ \t\n]*\\([a-z][_a-z0-9]*\\)[ \t\n]*[=+]")
(defvar sasmod-reg-variable-if-when ";[ \t\n]*\\(?:when\\|if\\)[ \t\n]*([^)]*)[ \t\n]*\\([a-z][_a-z0-9]+\\)[ \t\n]*=")
(defvar sasmod-reg-variable-else-otherwise ";[ \t\n]*\\(?:otherwise\\|else\\)[ \t\n]+\\([a-z][_a-z0-9]+\\)[ \t\n]*=")
(defvar sasmod-reg-output-find ";[ \t\n]*\\(?:output\\)")
(defvar sasmod-reg-output-get "\\([-_a-z0-9]*\\)[ \t\n]*=[ \t\n]*\\([-_a-z0-9]*\\)")
(defvar sasmod-reg-pctlpts-get "\\([^;=]*\\)")
(defvar sasmod-reg-pctlpts-get2 "\\([-_a-z0-9]*\\)$")
;;
;; Regular expressions to extract formats
;;

(defvar sasmod-reg-format-extract ";[ \t\n]*\\(?:picture\\|value\\)[ \t\n]+\\($?\\)[ \t\n]*\\([a-z][_a-z0-9]+\\)")


(defvar sasmod-end-of-statement ";")
(defvar sasmod-end-of-statement-nospace "[^\n\t ]*;")
(defvar sasmod-end-of-statement-space "[\n\t ]*;")
(defvar sasmod-option "/")
(defvar sasmod-empty-line "\\(;[ \n\t]*[a-z][-_a-z0-9]*[ \n\t]*\\(?:out=\\)?[ \n\t]*/?[ \n\t]*;\\)")
(defvar sasmod-empty-option "\\([ \n\t]*/[ \n\t]*;\\)")

(defvar sasmod-next-option "\\|[ \n\t(]+\\(;\\|[a-z][-_a-z0-9]*\\)\\([ \t\n]*=\\|\\)")
(defvar sasmod-last-equals "[ \n\t(]+\\([a-z][-_a-z0-9]*\\)[ \t\n]*=[ \t\n]*\\([^=(); \t\n]*\\)\\=")
;; Changed to allow format completion.
(defvar sasmod-last-option "[ \n\t(]+\\(\\$?[a-z][-_a-z0-9]*\\.?\\)\\=")
(defvar sasmod-delete-blank-option "\\([ \n\t]*[a-z][-_a-z0-9]*[ \n\t]*=\\)[ \n\t]*\\=")

(defvar sasmod-sitting-at-equals "\\([ \n\t(]+[a-z][-_a-z0-9]*[ \n\t]*=[ \n\t]*\\=\\)")
(defvar sasmod-is-an-empty-equals "[ \n\t(]+[a-z][-_a-z0-9]*[ \n\t]*=[ \n\t]*\\([^(); \t\n]*\\)")
(defvar sasmod-delete-spaced-equals "\\([ \n\t]+[a-z][-_a-z0-9]*[ \n\t]*=\\)[ \n\t]*\\=")
;; only deletes the current () if there is just one option inside.
(defvar sasmod-delete-only-equals-par "\\=\\(([ \n\t]*[a-z][-_a-z0-9]*[ \n\t]*=[ \n\t]*)\\)")
;; deletes option (type= to (
(defvar sasmod-delete-equals-par "\\([ \n\t]*([a-z][-_a-z0-9]*[ \n\t]*=\\)\\=")

(defvar sasmod-libname "^[ \t]*libname[ \t]+\\([A-Za-z_][A-Za-z_0-9]*\\)[ \t]+\\(?:v[0-9]+[ \t]+\\)?['\"][ \t]*\\([^'\"]*\\)[ \t]*['\"][ \t]*;[ \t]*$")
(defvar sasmod-include "^[ \t]*%include[ \t]*['\"][ \t]*\\([^'\"]*\\)[ \t]*['\"][ \t]*;?[ \t]*$")

(defun sasmod-add-to-alist (alist-var elt-cons &optional no-replace)
  "Add to the value of ALIST-VAR an element ELT-CONS if it isn't there yet.
If an element with the same car as the car of ELT-CONS is already present,
replace it with ELT-CONS unless NO-REPLACE is non-nil; if a matching
element is not already present, add ELT-CONS to the front of the alist.
The test for presence of the car of ELT-CONS is done with `equal'."
  (let ((existing-element (assoc (car elt-cons) (symbol-value alist-var))))
    (if existing-element
        (or no-replace
            (rplacd existing-element (cdr elt-cons)))
      (set alist-var (cons elt-cons (symbol-value alist-var))))))

(defun sasmod-append (alist1 alist2 &optional justComp)
  "Appends alist1 to alist2 and returns appended array.  Checks for duplicates...  Alist1 values are retained.
if justComp is true, then add just the first element of the two arrays and add a zero for the second element."
  (if (not justComp)
      (setq apout alist1)
    (setq apout '())
    (setq aplen (length alist1))
    (setq api 0)
    (while (< api aplen)
      (setq apcur (nth 0 (nth api alist1)))
      (sasmod-add-to-alist 'apout (cons apcur 0))
      (setq aplen (- aplen (length (nth 1 (nth api alist1)))))
      (setq api (+ api 1))
      )
    )
  (setq aplen (length alist2))
  (setq api 0)
  (while (< api  aplen)
    (setq apcur (nth api alist2))
    (if (not justComp)
	(sasmod-add-to-alist 'apout apcur)
      (setq apcur (nth 0 (nth api alist2)))
      (sasmod-add-to-alist 'apout (cons apcur 0))
      )
    (setq api (+ api 1))
    )
  apout
  )

(defun sasmod-help-state-ops (proc state what &optional init type)
  "Gets the help for the options of the current proc's state.
Options are within the sasmod-proc-options alist and of the form:
proc-statment for options before /
proc.statement for options after /
-statment for general options for statement before /
.statement for general options after /

/**/ represents the cursor location
/**/ alone represents what the default completion behavior of the statment is.
"
  (setq procstate (concat proc (or type ".") state))
  (if (not (assoc procstate sasmod-proc-state-options))
      (setq procstate (concat (or type ".") state))
    )
  (if (assoc procstate sasmod-proc-state-options)
      (progn
	(setq complete (car (cdr (assoc procstate sasmod-proc-state-options))))
	(if (assoc what complete)
	    (progn 
	      (sasmod-complete-message (car (cdr (assoc what complete))) proc state init)
	      )
	  )
	)
    )
  )
(defun sasmod-devowel (proc)
  "Takes out the vowels of the procedure."
  (setq pv proc)
  (while (string-match "[aeiou]" pv)
    (setq pv (replace-match "" nil nil pv))
    )
  pv
)
(defun sasmod-complete-message-get-alist (msg proc &optional state init) 
  "Completes messages based on their content and then returns an alist."
;;
;; The message determines what type of autocompletion can be done.  If the
;; message begins with a () and has options in it then an autocompletion is
;; built.  For specific functions like data, all datasets are listed by
;; (data) and then the bulk of the help message.  For example "(data) This
;; specifies a dataset" would be a message that determines a dataset.  If,
;; there are a variety of options that can be specified, it can be
;; specified by separating each option by |.  For example "(df|wdf) Choose
;; weighted or nonweighted degrees of freedom" creates an autocompletion
;; that assumes that there are two possible values of a message. If you
;; wish to use a function as well as other values, this is specified by
;; "([data]|df|wdf) Choose a dataset or weight/nonweighted degrees of
;; freedom.".
;;
;; No completion is assumed when  there is nothing in the ().
;; Anything that has a list of choices seperated by | is assuemd to complete those choices.
;; If you wish to put an additional completion based on a function enclose it in [].
;;

  ;; Create empty alist.
  (setq outm '())
  (if (not (string-match sasmod-reg-complete-msg msg))
      (message "%s" msg)
    (setq compops (match-string 1 msg))
    (if (not (string-match "|" compops))
	(progn
	  (setq outm (append
		     outm
		     (sasmod-get-alist proc compops )))
	  (if (not (= (length outm) 0))
	      (setq msg (substring msg (+ 2 (length compops)) nil))
	    )
	  )
      ;; Remove () from message.
      (setq msg (substring msg (+ (length compops) 2) nil ))
      ;;
      ;; Split values.
      ;;
      (setq ops (split-string compops "[ \t]*|[ \t]*"))
      (setq lenm (length ops))
      (setq im 0)
      (while (< im lenm)
	(setq tmpm (nth im ops))
	(if (string-match sasmod-reg-complete-msg-inside tmpm)
	    (progn
	      ;;
	      ;; Add functional completion.
	      ;;
	      (setq outm (append 
			 outm
			 (sasmod-get-alist proc (match-string 1 tmpm))))
	      )
	  ;;
	  ;; Add to output alist.
	  ;;
	  (sasmod-add-to-alist 'outm (cons tmpm 0))
	  )
	(setq im (+ im 1))
	)
      )
    )
  outm
  )
(defun sasmod-complete-message (msg proc &optional state init)
  "Completes messages based on their content" 
  (setq out (sasmod-complete-message-get-alist msg proc state init))
  (setq m msg)
  (if (> (length out) 0)
      (progn
	(if (string-match "^([^(]+)" m)
	    (setq m (replace-match "" nil nil m)))
	(completing-insert out nil (or init 0) nil m)
	)
    (message "%s" msg)
    )
  )
(defun sasmod-get-alist (proc type)
  "Return a list based on what type of output was specified."
;; The following autocompletions are complete:
;;
;; color 	= Color completion
;; data 	= Complete Data
;; library 	= Library/libref.
;; output-data 	= Complete Output Data
;;
;; The following are paritally complete:
;;
;; (variable) 		= Variable Name (doesn't get ALL variables.  
;;                        I would have to call SAS to make this work.)
;; (variable='')        = Variable Name with ='' attached to end.
;; (variable=)          = Variable Name with = attached to end.
;; (format) 		= Format completion (doesn't scan external file(s) yet.)
;;
;; Not completed, but may be completed in the future.
;;
;; (catalog) 		= Complete Catalog
;; (ods) 		= ODS document/destination
;; (axis-expression)  	= Axis expression
;; (new-variable)	= An ouput or new variable
;; (linetype) 		= Line Type
;; (file) 		= Fileref or name completion (include '' & directory inclusion?)
;; (informat) 		= Information completion
;; (font) 		= Font Specification
;; (pattern) 		= Fill pattern
;; (plot) 		= Default Plot syntax.
;; (label) 		= Label Completion
;; (where) 		= Where completeion
;;
;; Not completed (with no intention to complete)
;;
;; (#) 				= Specifies a number
;; (%) 				= Specifies a percent.
;; (password) 			= Specifies password.
;; (translation-list) 		= Specifies a translation between the two character sets.
;; (out-graphics-catalog) 	= Specifies a graphics catalog.
;;
  (setq out '())
  (cond
   ( (string= type "data")
     (setq out (append out (sasmod-get-alist-data) ) ) 
     (message "%s" out)
     )
   ( (string= type "output-data") 
     (setq out (append out (sasmod-get-alist-out proc) ) )
     )
   ( (string= type "library")
     (setq out (append out (sasmod-get-alist-library)))
     )
   ( (string= type "variable")
     (setq out (append out (sasmod-get-alist-variable)))
     )
   ( (string= type "variable=''")
     (setq out (append out (sasmod-get-alist-variable "='/**/'")))
     )
   ( (string= type "variable=")
     (setq out (append out (sasmod-get-alist-variable "=")))
     )
   ( (string= type "format")
     (setq out (append out (sasmod-get-alist-format)))
     )
   ( (assoc type sasmod-completions)
     (setq out (append out (car (cdr (assoc type sasmod-completions)))))
     )
   )
  out
  )
;;
;; Get format list.
;;
(defun sasmod-get-local-formats ()
  "Gets the formats for the local file."
  (setq out '())
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward sasmod-reg-format-extract nil 't)
	(setq format (concat (match-string 1) (match-string 2) "."))
	(sasmod-add-to-alist 'out (list format "User Defined format."))
	)
    )
  out
  )
(defun sasmod-get-alist-format ()
  "Gets the default formats along with currently defined formats (not in a catalog, though)"
  (interactive)
  (setq out '())
  (setq i 0)
  (setq len (length sasmod-formats))
  ;;
  ;; Get Standard formats.
  ;;
  (while (< i  len)
    (setq itm (nth i sasmod-formats))
    (setq val (concat (nth 0 itm) "."))
    (setq msg (nth 2 itm))
    (sasmod-add-to-alist 'out (list val msg))
    (setq i (+ i 1))
    )
  (setq out (append out
		    (sasmod-get-local-formats)))
  out
  )

;;
;; Get a SAS series.
;;

(defun sasmod-get-sas-series (str)
  "This function gets a series and returns a list with the elements. The series can be:
1 2 3 4 5 6
5, 4 to 3 by -1
1 to 6
3 to 8 by 1.4
etc."
  (setq spt (split-string str ","))
  (setq list '())
  (setq len (length spt))
  (if (< 1 len)
      (progn
	(setq j 0)
	(setq tlen len)
	(setq tmp spt) ;; With recursion these variables are overwritten in xemacs... silly.
	(setq tlst '());; Too bad.
	(setq curr nil)
	(while (< j tlen)
	  (setq curr (nth j tmp))
	  (setq tlst (append tlst
			     (sasmod-get-sas-series curr)))
	  (setq j (+ j 1))
	  )
	(setq list tlst)
	)
    ;;
    ;; Ok, no comma, try a space.
    ;;
    (setq spt (split-string str))
    (setq len (length spt))
    (if (and (> len  2) (string= (nth 1 spt) "to"))
	(progn
	  (if (and (> len 4) (string= (nth 3 spt) "by"))
	      (setq by (string-to-number (nth 4 spt)))
	    (setq by 1)
	    )
	  (setq start (string-to-number (nth 0 spt)))
	  (setq stop (string-to-number (nth 2 spt)))
	  (while (<= start stop)
	    (add-to-list 'list start)
	    (setq start (+ start by))
	    )
	  )
      ;;
      ;; No its a standard series.
      ;;
      (setq i 0)
      (while (< i len)
	(add-to-list 'list (string-to-number (nth i spt) ))
	(setq i (+ i 1))
	)
      )
    )
  list
  )

;;
;; Function to get (some) variables.
;;

(defun sasmod-get-alist-variable-look-inside-statement (regexp &optional endRegexp vsuf)
  "Gets the variables defined in a statment.  Assumes the whole inside of the statment contains variable definitions."
  (setq outlis '())
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward regexp nil t)
      (setq end nil)
      (save-excursion
	(if (re-search-forward (or endRegexp sasmod-end-of-statement) nil t)
	    (progn
	      (backward-char (length (match-string 0)))
	      (setq end (point))
	      )
	  (setq end (point-max))
	  )
	)
      (narrow-to-region (point) end)
      (goto-char (point-min))
      (while (re-search-forward sasmod-reg-variable nil t)
	(setq var (concat (match-string 1) (or vsuf "")))
	(sasmod-add-to-alist 'outlis (list var (concat var " is a local variable.")))
	(sasmod-add-to-alist 'outlis (list (downcase var) (concat var " is a local variable.") ))
	)
      (goto-char (point-min))
      (while (re-search-forward sasmod-reg-variable- nil t)
	(setq pre (match-string 1))
	(setq bstr (string-to-number (match-string 2)))
	(setq estr (string-to-number (match-string 3)))
	(setq i bstr)
	(while (<= i estr)
	  (setq tmp (concat pre (number-to-string i) (or vsuf "")))
	  (sasmod-add-to-alist 'outlis (list tmp (concat tmp " is a local variable.")))
	  (sasmod-add-to-alist 'outlis (list (downcase tmp) (concat tmp " is a local variable.")))
	  (setq i (+ i 1))
	  )
	)
      (widen)
      )
    )
  outlis
  )
(defun sasmod-get-alist-variable (&optional vsuf)
  "Gets the variables defined in the current file and adds them to the completion for the variable field.
vsuf defines the suffix that each constructed variable adds."
  (setq out '())
  ;;
  ;; First look for variables in the input statement.
  ;;
  (setq out (sasmod-append out
		    (sasmod-get-alist-variable-look-inside-statement sasmod-reg-variable-input nil vsuf)
		    ))
  ;;
  ;; Look for variables in the rename statement
  ;;
  (setq out (sasmod-append out
		    (sasmod-get-alist-variable-look-inside-statement sasmod-reg-variable-rename nil vsuf)
		    ))
  (setq out (append out
		    (sasmod-get-alist-variable-look-inside-statement sasmod-reg-variable-rename-eq ")" vsuf)
		    ))


  ;;
  ;; Look for variables in keep and drop statements.
  ;;
  (setq out (sasmod-append out
		    (sasmod-get-alist-variable-look-inside-statement sasmod-reg-variable-keep-drop sasmod-reg-variable-keep-drop-end vsuf)
		    ))
  ;;
  ;; Look for created variables in between the data and add them to the list.
  ;;
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward "^[ \t\n]*data" nil t)
      (setq c (point))
      (save-excursion
	(if (re-search-forward "^[ \t\n]*run" nil t)
	    (setq end (point))
	  )
	)
      ;;
      ;; Ok, now between the beginning and end get defined variables.
      ;;
      (while (< c end)
	(if (re-search-forward sasmod-reg-variable-define nil t)
	    (progn
	      (setq c (point))
	      (if (< c end)
		  (progn
		    (setq var (concat (match-string 1) (or vsuf "")))
		    (sasmod-add-to-alist 'out (list var (concat var " is a local variable.")))
		    (sasmod-add-to-alist 'out (list (downcase var) (concat var " is a local variable.")))
		    )
		)
	      )
	  (setq c (+ 7 end))
	  )
	)
      )
    )

  ;;
  ;; Now get the variables from the if type statements.
  ;;
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward "^[ \t\n]*data" nil t)
      (setq c (point))
      (save-excursion
	(if (re-search-forward "^[ \t\n]*run" nil t)
	    (setq end (point))
	  )
	)
      ;;
      ;; Ok, now between the beginning and end get defined variables.
      ;;
      (while (< c end)
	(if (re-search-forward sasmod-reg-variable-if-when nil t)
	    (progn
	      (setq c (point))
	      (if (< c end)
		  (progn
		    (setq var (concat (match-string 1) (or vsuf "")))
		    (sasmod-add-to-alist 'out (list var (concat var " is a local variable.")))
		    (sasmod-add-to-alist 'out (list (downcase var) (concat var " is a local variable.")))
		    )
		)
	      )
	  (setq c (+ 7 end))
	  )
	)
      )
    )
  ;;
  ;; Now get variables from otherwise or else.
  ;;
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward "^[ \t\n]*data" nil t)
      (setq c (point))
      (save-excursion
	(if (re-search-forward "^[ \t\n]*run" nil t)
	    (setq end (point))
	  )
	)
      ;;
      ;; Ok, now between the beginning and end get defined variables.
      ;;
      (while (< c end)
	(if (re-search-forward sasmod-reg-variable-else-otherwise nil t)
	    (progn
	      (setq c (point))
	      (if (< c end)
		  (progn
		    (setq var (concat (match-string 1) (or vsuf "")))
		    (sasmod-add-to-alist 'out (list var (concat var " is a local variable.")))
		    (sasmod-add-to-alist 'out (list (downcase var) (concat var " is a local variable.")))
		    )
		)
	      )
	  (setq c (+ 7 end))
	  )
	)
      )
    )
  ;;
  ;; Now look for variables in the ouptut statment.
  ;;
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward sasmod-reg-output-find nil t)
      (setq pctlpts nil) ;; Series.
      (setq pctlpre nil) ;; Series
      (setq pctlname nil) ;; 
      (setq c (point))
      (setq end (point-max))
      (save-excursion
	(if (re-search-forward ";" nil t)
	    (setq end (point))
	  )
	)
      (while (< c  end)
	(if (re-search-forward sasmod-reg-output-get nil t)
	    (progn
	      (setq ot (match-string 1))
	      (setq var (match-string 2))
	      (setq c (point))
	      (if (or (or (>= c end) (or (string= "out" ot) (string= "pctlpts" ot))) (looking-at "[ \n\t]*="))
		  (progn
		    (if (string= ot "pctlpts")
			(progn
			  (backward-char (length var))
			  (if (re-search-forward sasmod-reg-pctlpts-get nil t)
			      (progn
				(setq var (match-string 1))
				;;
				;; Take out last element if looking at =.
				;;
				(if (and (looking-at "=") (string-match sasmod-reg-pctlpts-get2 var))
				    (progn
				      (setq var (substring var 0 (- 0 (length (match-string 1)))))
				      (backward-char (length (match-string 1)))
				      (re-search-backward "[ \n\t]*\\=" nil t)
				    )
				  )
				(setq pctlpts (sasmod-get-sas-series var) )
				)
			    )
			  )
		      )
		    )
		(if (or (string= ot "pctlpre") (string= ot "pctlname"))
		    (progn
		      (backward-char (length var))
		      (if (re-search-forward sasmod-reg-pctlpts-get nil t)
			  (progn
			    (setq var (match-string 1))
			    ;;
			    ;; Take out last element if looking at =.
			    ;;
			    (if (and (looking-at "=") (string-match sasmod-reg-pctlpts-get2 var))
				(progn
				  (setq var (substring var 0 (- 0 (length (match-string 1)))))
				  (backward-char (length (match-string 1)))
				  (re-search-backward "[ \n\t]*\\=" nil t)
				  )
			      )
			    ;;
			    ;; ok, now split it and put it in the appropriate variable.
			    ;;
			    (if (string= ot  "pctlpre")
				(progn
				  (setq pctlpre (split-string var))
				  )
			      (setq pctlname (split-string var))
			      )
			    )
			)
		      )
		  (setq var (conat var (or vsuf "")))
		  (sasmod-add-to-alist 'out (list var (concat var " is a local variable.")))
		  (sasmod-add-to-alist 'out (list (downcase var) (concat var " is a local variable.")))
		  )
		)
	      )
	  (setq c (+ 7 end))
	  )
	;;
	;; Construct univariate output percentile ouput variables.
	;;
	(if (and pctlpts pctlpre)
	    (progn
	      (setq i 0)
	      (setq len (length pctlpts))
	      (setq lenj (length pctlpre))
	      (while (< i len)
		(setq j 0)
		(while (< j lenj)
		  (setq prefix (nth j pctlpre))
		  (if pctlname
		      (if (< i (length pctlname))
			  (setq suffix (nth i pctlname))
			(setq suffix nil)
			)
		    (setq suffix nil)
		    )
		  (setq mid (format "%g" (nth i pctlpts)))
		  (while (string-match "\\." mid)
		    (setq mid (replace-match "_" nil nil mid)))
		  (setq var (concat prefix (or suffix mid) (or vsuf "")))
		  (sasmod-add-to-alist 'out (list var (concat var " is a local variable.")))
		  (sasmod-add-to-alist 'out (list (downcase var) (concat var " is a local variable.")))
		  (setq j (+ j 1))
		  )
		(setq i (+ i 1))
		)
	      )
	  )
	)
      )
    )

  ;;
  ;; Now get variables from the new-varaible= statements.
  ;;
  (setq procs (sasmod-get-all-procs))
  (setq i 0)
  (setq len (length procs))
  (while (< i  len)
    (setq proc (nth i procs))
    (if (assoc proc sasmod-create-variable-statements)
	(save-excursion
	  (goto-char (point-min))
	  (while (re-search-forward (concat "proc[ \t\n]+" (regexp-quote proc)) nil t)
	    (setq start (point))
	    (save-excursion
	      (if (re-search-forward "\\(run\\|quit\\);" nil t)
		  (setq end (point))
		(setq end (point-max))
		)
	      )
	    ;;
	    ;; OK, now lets get the proc's new variables
	    ;;
	    (setq complete (car (cdr (assoc proc sasmod-create-variable-statements))))
	    (setq j 0)
	    (setq lenj (length complete))
	    (while (< j lenj)
	      (goto-char start)
	      (setq current (nth j complete))
	      (setq item (car current))
	      (setq notThere (car (cdr current)))
	      ;;
	      ;; Fix regexp current.
	      ;;
	      (if (string-match "=" item)
		(setq item (replace-match "[ \t\n]*=" nil nil item))
		)
	      (setq c (point))
	      (setq item (concat item "\\([a-z][_-a-z0-9]+\\)"))
	      (setq foundItem nil)
	      (while (< c end)
		(if (not (re-search-forward item nil t))
		    (setq c (+ end 7))
		  (setq c (point))
		  (setq var (match-string 1))
		  (if (< c end)
		      (progn
			(setq var (concat var (or vsuf "")))
			(sasmod-add-to-alist 'out (list var (concat var " is a local variable.")))
			(sasmod-add-to-alist 'out (list (downcase var) (concat var " is a local variable.")))
			(setq foundItem 't)
			)
		    )
		  )
		)
	      (if (and (not foundItem) (not (string= notThere "")))
		  (progn
		    (setq notThere (concat notThere (or vsuf "")))
		    (sasmod-add-to-alist 'out (list notThere (concat notThere " is a local variable.")))
		    )
		)
	      (setq j (+ j 1))
	      )
	    (goto-char end)
	    )
	  )
      )
    (setq i (+ i 1))
    )
  out
  )
(defun sasmod-get-alist-out (proc &optional prefix)
  "Completes Output datasets based on some naming convention."
  ;;
  ;; Now make an association list for the one option for the output dataset.
  ;;
  ;;
  ;; First take out the vowels in the proc.
  ;; Then, look for a dataset that is used in the current procedure, and ouput the name
  ;; to the new dataset procedure.
  ;;
  (sasmod-get-local-data)
  (setq pre (sasmod-devowel proc))
  (setq out sasmod-dsn-local)
  ;;
  ;; Travserse sasmod-dsn-local and possibilites to output.
  ;;
  (setq i 0)
  (setq len (length sasmod-dsn-local))
  (while (< i len)
    (setq tmp (nth i sasmod-dsn-local))
    (setq dsn (car tmp))
    (setq dsn2 nil)
    (if (= (length dsn) 0)
	(setq dsn2 pre )
      )
    (if (and (not dsn2) (string-match "^\\([_A-Za-z0-9]+\\)$" dsn))
	(setq dsn2 (replace-match (concat pre "_\\1") nil nil dsn))
      )
    (if (and (not dsn2) (string-match "^\\([_A-Za-z0-9]+\\)\\.\\([_A-Za-z0-9]+\\)$" dsn))
	(setq dsn2 (replace-match (concat "\\1." pre "_\\2") nil nil dsn))
      )
    (if dsn2
	(sasmod-add-to-alist 'out (cons dsn2 0))
	)
    (if (and prefix (= 0 (length prefix)))
	(progn
	  (setq dsn2 nil)
	  (if (= (length dsn) 0)
	      (setq dsn2 (concat prefix pre ))
	    )
	  (if (and (not dsn2) (string-match "^\\([_A-Za-z0-9]+\\)$" dsn))
	      (setq dsn2 (replace-match (concat prefix pre "_\\1") nil nil dsn))
	    )
	  (if (and (not dsn2) (string-match "^\\([_A-Za-z0-9]+\\)\\.\\([_A-Za-z0-9]+\\)$" dsn))
	      (setq dsn2 (replace-match (concat "\\1." prefix pre "_\\2") nil nil dsn))
	    )
	  (if dsn2
	      (sasmod-add-to-alist 'out (cons dsn2 0))
	    )
	  )
      )
    (setq i (+ i 1))
    )
  ;;  (completing-insert out nil (or init 0) nil "Output dataset completion")
  out
  )
(defun sasmod-help-proc-ops (proc what &optional init)
  (if (assoc proc sasmod-proc-options)
      (progn
	(setq complete (car (cdr (assoc proc sasmod-proc-options))))
	(if (assoc what complete)
	    (progn
	      (sasmod-complete-message (car (cdr (assoc what complete))) proc nil init )
	      )
	  ;;
	  ;; See if there is only one with completing and then return it.
	  ;; It takes care of problems with statements such as trim= in univariate that has
	  ;; more information automatically added, but not necessicarly in the way things are typed...
	  ;;
	  (setq tmp (all-completions what complete))
	  (if (= 1 (length tmp))
	      (progn
		;;
		;; cool, now just message, or finish completion based on user options.
		;;
		(message "%s" (car (cdr (assoc (car tmp) complete))))
		(setq wcomp (split-string (car (assoc (car tmp) complete)) (regexp-quote "/**/")))
		;;
		;; First split it based on /**/ position
		;;
		(setq before nil)
		(setq after nil)
		(setq complete nil)
		(if (= (length wcomp) 2)
		    (progn
		      (setq before (concat (car wcomp) " "))
		      (setq after (car (cdr wcomp)))
		      (setq before (regexp-quote before))
		      (while (string-match "[ \n\t]+" before)
			(setq before (replace-match "[:blank:]*" nil nil before))
			)
		      (while (string-match ":blank:" before)
			(setq before (replace-match " \n\t" nil nil before))
			)
		      (if (string-match "[ \n\t]*\\(.\\)" after)
			  (progn
			    (setq afterc (match-string 1 after))
			    (setq after (concat "[ \n\t]*" (match-string 1 after)))
			    )
			)
		      (save-excursion
			(if (re-search-backward "proc" nil t)
			    (setq startc (point))
			  (beginning-of-line)
			  (setq startc (point))
			  )
			(if (re-search-forward ";" nil t)
			    (setq endc (point))
			  (end-of-line)
			  (setq endc (point))
			  )
			)
		      (narrow-to-region startc endc)
		      (setq before (concat before "\\="))
		      (save-excursion
			(if (looking-at after)
			    (if (re-search-backward before nil t)
				(setq complete nil)
			      )
			  (if (looking-at (concat "[^=" afterc "]*" after))
			      (setq complete nil)
			    (setq complete 't)
			    )
			  )
			)
		      (widen)
		      )
		  (setq complete 't)
		  )
		(if (not sasmod-whole-completion)
		    (message "There is only one.")
		  (if (and (not sasmod-last-del-par) complete)
		      (sasmod-complete-proc-options proc (length what))
		    )
		  )
		)
	      )
	  )
	)
    )
  )
(defun sasmod-space-line ()
  "Removes more than one whitespace per line. So '  ' becomes  ' '; Preserve indentation."
  (interactive)
  ;; Don't do it on label statements
  (setq backsemi nil)
  (if (re-search-backward ";[ \t]*\\=" nil t)
      (progn
	(setq backsemi 't)
	(replace-match ";")
	(backward-char 1)
	)
    )
  (setq proc (sasmod-get-current-proc))
  (setq state (sasmod-get-state proc))
  (setq addend nil)
  (save-excursion
    (beginning-of-line)
    (if (looking-at "^\\(.*\\)$")
	(setq line (match-string 1))
      (setq line "")
      )
    (if (re-search-forward ";" nil t)
	(progn
	  (beginning-of-line)
	  (setq complete (sasmod-get-full-state-completion proc))
	  (if (and (and (not (looking-at (concat "^" (regexp-quote line) "$"))) (looking-at "[ \t]*\\([a-z][-_a-z0-9]*\\)")) (assoc state complete))
	      (progn
		(sasmod-add-to-alist 'complete (list "run" 0))
		(sasmod-add-to-alist 'complete (list "quit" 0))
		(if (assoc (match-string 1) complete)
		    (setq addend 't)
		  )
		)
	    )
	  )
      )
    )
  (if addend
      (if (not (assoc proc sasmod-alternate-statements))
	  (save-excursion
	    (end-of-line)
	    (insert sasmod-end-of-statement)
	    )
	  )
      )
  (if (string= "label" state)
      (progn
	;;
	;; Hack for save-excursion not working right...
	;;
	(setq back nil)
	(save-excursion
	  (if (re-search-backward "^\\(.*\\)\\=" nil t)
	      (progn
		(setq back (match-string 1))
		(while (string-match "=" back)
		  (setq back (replace-match " [:equals:] " nil nil back))
		  )
		(while (string-match "\\[:equals:\\]" back)
		  (setq back (replace-match "=" nil nil back))
		  )
		(while (string-match "[ \n\t]+" back)
		  (setq back (replace-match "[:blank:]*" nil nil back))
		  )
		(while (string-match ":blank:" back)
		  (setq back (replace-match " \n\t" nil nil back))
		  )
		)
	    )
	  )
	(sasmod-align-equals-statement state 't)
	(if back
	    (progn
	      (beginning-of-line)
	      (re-search-forward (concat "\\=" back) nil t)
	      )
	  )
	)
    (if (and (string= "format" proc) (string= "invalue" state))
	(save-excursion
	  (sasmod-align-equals-statement state nil 't)
	  )
      (save-excursion
	(end-of-line)
	(setq e (point))
	(beginning-of-line)
	(re-search-forward "^[ \t]*" nil t)
	(setq c (point))
	(untabify c e)
	(while (< c  e)
	  (if (re-search-forward "\\([ \t]+\\)" nil t)
	      (progn
		(setq c (point))
		(if (< c e)
		    (replace-match " ")
		  )
		)
	    (setq c (+ 7 e))
	    )
	  )
	)
      )
    (save-excursion
      (beginning-of-line)
      (re-search-forward "^[ \t]*" nil t)
      (setq c (point))
      (while (< c  e)
	(if (re-search-forward "\\(([ \t]+\\)" nil t)
	    (progn
	      (setq c (point))
	      (if (< c e)
		  (replace-match "(")
		)
	      )
	  (setq c (+ 7 e))
	  )
	)
      )
    )
  (if backsemi
      (progn
	(re-search-forward "\\=[ \n\t]*;" nil t)
	)
    )
  )
(defun sasmod-at-run-quit (proc what)
  "Defines what is done when the next statment is a run or quit statment."
  ;;
  ;; See if the last line is blank.
  ;;
  (setq addLine 't)
  (save-excursion
    (beginning-of-line)
    (forward-line -1)
    (if (looking-at "[ \t]*$")
	(setq addLine nil)
      )
    )
  ;;
  ;; First take out extra lines from the procedure.
  ;;
  (save-excursion
    (if (re-search-backward (concat "proc[ \n\t]+" proc "[^;]*;") nil t)
	(progn
	  (setq start (+ (point) (length (match-string 0))))
	  )
      (setq start (point))
      )
    )
  (setq end (- (point) (length what)))
  (narrow-to-region start end)
  (goto-char (point-min))
  (setq isempty nil)
  (while (re-search-forward "\\([ \t]*\n\\)+" nil t)
    (replace-match "\n")
    )
  (widen)
  (if addLine
      (progn
	;; 
	;; Insert a line.
	;;
	(beginning-of-line)
	(insert "\n")
	(backward-char 1)
	(sasmod-indent)
	)
    ;;
    ;; Go forward and insert a line-feed
    ;;
    
    (if (re-search-forward sasmod-end-of-statement nil t)
	(progn
	  (if (looking-at "\n")
	      (forward-char 1)
	    (insert-string "\n")
	    )
	  )
      (insert-string ";\n")
      )
    )
  )
(defun sasmod-help-sas (proc what &optional init)
  "Display a message of help about the option."
  (cond
   ( (or (string= what "run") (string= what "quit")) (sasmod-at-run-quit proc what) )
   )
   (if (assoc proc sasmod-help)
      (progn
	(setq complete (car (cdr (assoc proc sasmod-help))))
	(if (assoc what complete)
	    (progn
	      (message "%s" (car (cdr (assoc what complete))))
	      )
	  )
	)
      )
  (if (string= what "from")
      (progn
;;	(sasmod-light-complete-data init)
	)
    )
  (setq sasmod-last-return-pos what)
)
;;
;; sasmod lightning
;;
(defun sasmod-is-between2 (first middle last &optional eof value)
  " Returns nil if the we are not between first and last (or value)
Returns 1 if only between first and middle
Returns 2 if only between middle and last
Returns 3 if between both (first and middle), and (middle and last).
Returns 4 if middle is outside of first and last
If eof is true, then the last point can be the end of the file instead of the actual match."
  (setq pointA nil)
  (setq pointB nil)
  (setq pointC nil)
  (setq between 4)
  ;;
  ;; First get points one and two.
  ;;
  (save-excursion
    (if (re-search-backward first nil t)
	(setq pointA (point))
      ;;
      ;; Not present, obviously not.
      ;;
      (setq between nil)
      )
    )
  (if between
      (save-excursion
	(if (re-search-forward last nil t)
	    (setq pointC (point))
	  (if eof
	      (setq pointC (point-max))
	    (setq between nil)
	    )
	  )
	)
    )
  (if between
      (save-excursion
	(if (re-search-forward first nil t)
	    (if (< (point) pointC)
		(setq between nil)
	      )
	  )
	)
      )
  (if between
      (save-excursion
	(if (re-search-backward last nil t)
	    (if (> (point) pointA)
		(setq between nil)
	      )
	  )
      )
    )
  ;;
  ;; Ok, now we know its between, figure out point B.
  ;;
  (if between
      (save-excursion
	(if (re-search-forward middle nil t)
	    (if (< (point)  pointC)
		(setq between 1)
		)
	    )
	)
    )
  (if between
      (save-excursion
	(if (re-search-backward middle nil t)
	    (if (> (point) pointA)
		(if (= between 1)
		    (setq between 3)
		  (setq between 2)
		  )
	      )
	  )
	)
    )
  (if (and value (not between))
      (setq between value))
  between
  )
(defun sasmod-is-between (first last &optional eof)
  "Returns true of the carat is between the first and last .

If eof is true, then the last position is:
   (1) the position of the variable last
   (2) the position of the next variable first
   (3) the end of the buffer.
If eof is nil, then the last position is:
   (1) the position of the next variable last.
"
  (setq first-posB nil)
  (setq last-posF nil)
  (setq between 't)
  (save-excursion
    (if (re-search-backward first nil t)
	(setq first-posB (point))
      (setq between nil)
      )
    )
  (if between
      (save-excursion
	(if (re-search-forward last nil t)
	    (setq last-posF (point))
	  ;; 
	  ;; Last not found, look for first.
	  ;;
	  (if eof
	      (progn
		(if (re-search-forward first nil t)
		    (setq last-posF (point))
		  ;;
		  ;; First not found, set to end of buffer.
		  ;;
		  (setq last-posF (point-max))
		  )
		)
	    ;;
	    ;; Eof not true.  
	    ;;
	    (setq between nil)
	    )
	  )
	)
    )
  (if (and (not eof) between)
      (save-excursion
	(if (re-search-forward first nil t)
	    (if (< (point) last-posF)
		(setq between nil)
	      )
	  )
	)
    )
  (if between
      (save-excursion
	(if (re-search-backward last nil t)
	    (if (> (point) first-posB)
		(setq between nil)
	      )
	  )
	)
    )
  between
)
(defun sasmod-delete-empty-options()
  "Deletes blank options. Returns nil if not deleted"
  (setq deleted 't)
  (setq pt 0)
  (save-excursion 
    (if (re-search-forward sasmod-end-of-statement nil t)
	(setq pt (point))
      (setq deleted nil)
      )
    )
  (if deleted
      (save-excursion
	(if (re-search-backward sasmod-option nil t)
	    (if (re-search-forward sasmod-empty-option nil t)
		(progn 
		  (if (= (point) pt)
		      (replace-match sasmod-end-of-statement t t)
		    (setq deleted nil)
		    )
		  )
	      (setq deleted nil)
	      )
	  )
	)
    )
  (if deleted
      (setq sasmod-completing-options-flag 't)
    )
 deleted
)
(defun sasmod-delete-empty-line (proc state)
  "Deletes blank a line.  Returns nil if not deleted."
  (setq tmpstate state)
  (setq deleted 't)
  (setq semi sasmod-end-of-statement)
  (setq empty sasmod-empty-line)
  (if (assoc proc sasmod-alternate-statements)
      (progn
	(setq complete (car (cdr (assoc proc sasmod-alternate-statements))))
	(if (assoc ";" complete)
	    (setq semi (car (cdr (assoc ";" complete))))
	  )
	(if (assoc "delete" complete)
	    (setq empty (car (cdr (assoc "delete" complete))))
	  )
	)
      )
  (save-excursion
    (beginning-of-line)
    (if (looking-at empty)
	(kill-entire-line))
    (setq delted 't)
    )
  (setq pt 0)
  (if deleted
      (save-excursion
	(if (re-search-forward semi nil t)
	    (setq pt (point))
	  (setq deleted nil)
	  )
	)
    )
  (if deleted
      (save-excursion
	(if (re-search-backward semi nil t)
	    (if (re-search-forward empty nil t)
		(progn
		  (if (= (point) pt)
		      (replace-match semi t t)
		    (setq deleted nil)
		    )
		  )
	      (setq deleted nil)
	      )
	  )
	)
    )
  (if (not deleted)
      ;; Add sticky statement if the current statement supports it.
      (if (assoc proc sasmod-sticky-statements)
	  (progn 
	    (setq complete (car (cdr (assoc proc sasmod-sticky-statements))))
	    (if (assoc state complete)
		(save-excursion
		  (if (re-search-forward semi nil t)
		      (progn
			  (setq nstate (sasmod-get-state proc))
			  (setq state tmpstate) ;; Somehow this variable gets overwritten... 
			  (if (not (string= tmpstate nstate))
			      (insert sasmod-sticky-statement-temp)
			    )
			)
		    )
		  )
	      )
	    )
	)
    )
  deleted
  )
(defun sasmod-delete-blank-state-equals (proc state)
  "Deletes blank option= if the cursor is at the end of the = sign for a statement's options."
  (setq delete nil)
  (setq option nil)
  (save-excursion
    (if (re-search-backward sasmod-sitting-at-equals nil t)
	(progn
	  (if (re-search-forward sasmod-is-an-empty-equals nil t)
	      (progn
		(setq option (match-string 1))
		;; See if this is an equals, or option, and if not delete.
		(if (looking-at "[ \n\t]*=")
		    (setq delete 't))
		(if (assoc proc sasmod-proc-options)
		    (progn
		      (setq complete (car (cdr (assoc (concat proc (concat "." state)) sasmod-proc-state-options))))
		      (if (assoc option complete)
			  (setq delete 't)
			)
		      )
		  )
		)
	    (setq delete 't)
	    )
	  )
      )
    )
  (save-excursion
    (if (and delete 
	     (re-search-backward sasmod-delete-blank-option nil t))
	(progn
	  (replace-match "" t t)
	  (setq delete nil)
	  )
      )
    )
  )
(defun sasmod-delete-blank-proc-equals (proc &optional dontDelete)
  "Deletes blank option= if the cursor is at the end of the = sign.
if dontDelete=nil then delete the option
if dontDelete='t then just return if you would have deleted the option."
  (setq delete nil)
  (setq option nil)
  (if (looking-at "[ \n\t];")
      (setq option 't)
      )
  (save-excursion
    (if (re-search-backward sasmod-sitting-at-equals nil t)
	(progn
	  (if option 
	      (progn
		(setq delete 't)
		(setq option nil)
		)
	    (if (re-search-forward sasmod-is-an-empty-equals nil t)
		(progn
		  (setq option (match-string 1))
		  (if (and (string= option "") (looking-at "[ \n\t]*)"))
		      (setq delete 't))
		  (if (and (string= option "") (looking-at "[ \n\t]*;"))
		      (setq delete 't))
		  (if (and (not delete) (assoc proc sasmod-proc-options))
		      (progn
			(setq complete (car (cdr (assoc proc sasmod-proc-options))))
			(if (assoc option complete)
			    (setq delete 't)
			  (if (> (length option)  1)
			      (progn
				(setq tmp (substring option -1 nil))
				(if (string= tmp "=")
				    (setq delete 't)
				  )
				)
			    )
			  (if (not delete)
			      (progn
				(setq tmp (all-completions option complete) )
				(if (and (= 1 (length tmp)) (looking-at "[ \n\t]*="))
				      (setq delete 't)
				  )
				)
			    )
			  )
			)
		    )
		  )
	      )
	    )
	  )
      )
    )
  (setq pardel nil)
  (save-excursion
    (if (and (and delete (not dontDelete))
	     (re-search-backward sasmod-delete-spaced-equals nil t))
	(progn
	  (replace-match "")
	  (if (and (looking-at "[ \t\n]*)") (= 1 (sasmod-is-between2 "(" ")" sasmod-end-of-statement nil 5)))
	      (if (and (re-search-backward "(" nil t) (re-search-forward "\\(([ \t\n]*)\\)" nil t))
		  (progn
		    (replace-match "")
		    (setq pardel 't)
		    )
		)
	      )
	  (setq delete nil)
	  )
      )
    )
  (if (and delete (not dontDelete))
      (save-excursion
	(if (re-search-backward "(" nil t)
	    (if (re-search-forward sasmod-delete-only-equals-par nil t)
		(progn
		  (replace-match "" nil t)
		  (if (re-search-backward "\\([ \t\n]*\\)" nil t)
		      (progn 
			(setq pardel 't)
			(replace-match "" nil t)
			)
		    )
		  (setq delete nil)
		)
	      )
	  )
	)
    )
  (if (and delete (not dontDelete))
      (if (re-search-backward sasmod-delete-equals-par nil t)
	  (progn
	    (replace-match "(" t t)
	    (setq pardel 't)
	    (setq delete nil)
	    )
	)
      )
  (if (and delete (not dontDelete))
      (sasmod-space-line)
      )
  (and pardel (re-search-backward sasmod-sitting-at-equals nil t))
  (if (not dontDelete)
      (setq sasmod-last-del-par pardel)
    )
  delete
  )
(defun sasmod-get-full-state-completion (proc)
  "Get all of the proc statments for completion."
  (let (
	(fsout (car (cdr (assoc proc sasmod-help))))
	(fstmp '())
	(fsi 0)
	(fslen 0)
	(fscur 0)
	)
    (if (string= proc "data")
	(symbol-value 'fsout)
      (setq fstmp (all-completions "-" sasmod-proc-state-options))
      (setq fslen (length fstmp))
      (while (< fsi fslen)
	(setq fscur (nth fsi fstmp))
	(setq fscur (substring fscur 1))
	(sasmod-add-to-alist 'fsout (list fscur " "))
	(setq fsi (+ fsi 1))
	)
      (symbol-value 'fsout)
      )
    )
  )
(defun sasmod-get-full-state-name (proc what)
  "Gets the ``full'' state name, or the name in the array (for # and /**/ processing)
Returns nil if a full state name could note be found."
  (setq fscomplete (sasmod-get-full-state-completion proc))
  (setq fscomp (all-completions what fscomplete))
  (setq fstate nil)
  (if (=(length fscomp) 1)
      (setq fstate (car fscomp))
    )
  fstate
  )
(defun sasmod-get-state (proc &optional move statecomp)
  "Returns the statement currently at, or the statement moved to.
  If move is true, then move to the next statement."
  (setq state nil)
  (setq semi sasmod-end-of-statement)
  (setq next sasmod-next-statement)
  (setq opt sasmod-option)
  (if (assoc proc sasmod-alternate-statements)
      (progn
	(setq complete (car (cdr (assoc proc sasmod-alternate-statements))))
	(if (assoc ";" complete)
	    (setq semi (car (cdr (assoc ";" complete))))
	  )
	(if (assoc "state" complete)
	    (setq next (car (cdr (assoc "state" complete))))
	  )
	(if (assoc "/" complete)
	    (setq opt (car (cdr (assoc "/" complete))))
	  )
	)
      )
  (setq stateposi (point))
  (setq statepos nil)
  (save-excursion
    (if (and (not move) (re-search-backward semi nil t))
	(if (re-search-forward next nil t)
	    (progn
	      (setq state (match-string 1))
	      )
	  )
      (if (re-search-forward semi nil t)
	  (progn
	    (backward-char 1)
	    (if (re-search-forward next nil t)
		(progn
		  (setq state (match-string 1))
		  (setq statepos (- (point) stateposi))
		  )
	      )
	    )
	)
      )
    )
  ;;
  ;; See if this option is actually composed of other substatements
  ;; For example in proc template there are statements that consist of two words like
  ;; define header
  ;;
  (if (assoc proc sasmod-state-multiple)
      (progn
	(setq complete (car (cdr (assoc proc sasmod-state-multiple))))
	(if (assoc state complete)
	    (progn
	      (setq num (car (cdr (assoc state complete))))
	      (save-excursion
		(if (not move )
		    (re-search-backward semi nil t)
		  (re-search-forward semi nil t)
		  (backward-char 1)
		  )
		(re-search-forward next nil t)
		(while (> num  0)
		  (if (re-search-forward "\\=[ \n\t]+\\([a-z][-_a-z0-9]*\\)" nil t)
		      (progn
			(setq state (concat state " " (match-string 1)))
			(setq statepos (- (point) stateposi))
			)
		    )
		  (setq num (- num 1))
		  )
		)
	      )
	  )
	)
      )
  (if (and move statepos)
      (progn
	;;
	;; If statement is sticky, then stick it.
	;;
	(forward-char statepos)
	(re-search-forward "\\=[ \t]?" nil t)
	(if (assoc proc sasmod-sticky-statements)
	    (progn
	      (setq complete (car (cdr (assoc proc sasmod-sticky-statements))))
	      (if (assoc state complete)
		  (progn
		    (setq ep (point))
		    (setq bp (point))
		    (save-excursion
		      (if (re-search-backward semi nil t)
			  (progn
			    (forward-char 1)
			    (setq bp (point))
			    )
			)
		      )
		    (setq sticky (buffer-substring bp ep))
		    (if (try-completion (concat proc "." state) sasmod-proc-state-options)
			    (setq sticky (concat sticky opt semi))
		      (setq sticky (concat sticky semi))
		      )
		    (setq sasmod-sticky-statement-temp sticky)
		    )
		  )
	      )
	    )
	)
      )
  (if statecomp
      (progn
	(setq pstate (sasmod-get-full-state-name proc state))
	(if (not pstate)
	    (if (string-match "\\([a-z]*\\)[0-9]*" state)
		(progn
		  (setq pstate (sasmod-get-full-state-name proc (concat (match-string 1 state) "#" )))
		  (if pstate
		      (setq state pstate)
		    )
		  )
	      )
	  (setq state pstate)
	  )
	)
    )
  state
  )
(defun sasmod-get-all-procs ()
  "Returns a list of all the procs in the current buffer."
  (setq procs '())
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward "proc[ \n\t]+\\([a-z][-_a-z0-9]*\\)" nil t)
      (add-to-list 'procs (match-string 1))
      )
    )
  procs
  )
(defun sasmod-get-current-proc ()
  (let (
	(proc nil)
	(data (regexp-opt (all-completions "" (sasmod-get-alist "data" "data"))))
	)
    (save-excursion
      (if (re-search-backward (format "\\(?:%s\\)[ \t\n\f]*([^)]*\\(([^)]*)[^)]*\\)*\\=" data) nil t)
	  (setq proc "data(")
	)
      )
    (if proc nil
      (save-excursion
	(if (re-search-backward "\\(proc\\|data\\)" nil t)
	    (progn 
	      (sasmod-bo-sas)
	      (if (looking-at "data")
		  (setq proc "data"))
	      )
	  )
	)
      )
    (if (not proc)
	(save-excursion
	  (if (re-search-backward "proc[ \n\t]+\\([a-z][-_a-z0-9]*\\)" nil t)
	      (setq proc (match-string 1))
	    )
	  )
      )
    (symbol-value 'proc)
    )
)
(defun sasmod-expand-options (complete proc state)
  "Expands an alist of completions based on /**/ defining what normally goes into this list."
  (setq ret '(
	      ))
  (if (not (assoc "/**/" complete) )
      (progn
	(message "Nothing new added.  Return whole alist.")
	(setq ret (append ret complete))
	)
    (setq tmp (assoc "/**/" complete))
    (setq ret (append ret
		      (remq tmp complete)))
    (setq tmp (nth 1 tmp))
    (setq ret (append ret 
		      (sasmod-complete-message-get-alist tmp proc state )))
    )
  ret
)
(defun sasmod-complete-state-options (proc state &optional init type)
  "Completes the options for the current proc's statement."
  (setq what (concat proc (or type ".") state))
  (setq msg what)
  (if (not (assoc what sasmod-proc-state-options))
      (setq what (concat (or type ".") state)))
  (if (and init (assoc what sasmod-proc-state-options))
      (progn
	(setq complete (car (cdr (assoc what sasmod-proc-state-options))))
	(setq complete (sasmod-expand-options complete proc state))
	(if (< 0 (length complete))
	    (completing-insert complete nil init 'sasmod-light-complete-options-move (concat msg " options"))
	  )
	)
    (if (and sasmod-completing-options-flag (assoc what sasmod-proc-state-options))
	(progn
	  (if (re-search-forward sasmod-end-of-statement nil t)
	      (progn
		(setq sasmod-completing-options-flag nil)
		(backward-char 1)
		(setq insert 't)
		(save-excursion
		  (backward-char 1)
		  (if (looking-at "[ \t\n]")
		      (setq insert nil)))
		(if insert
		    (insert-string " ")
		  )
		(sasmod-complete-state-options proc state 0)
		)
	    )
	  )
      (if sasmod-completing-options-flag
	  (progn
	    (message "SASmod does not understand the options of this statement.")
	    (setq sasmod-completing-options-flag nil)
	    )
	(setq sasmod-completing-options-flag 't)
	(beginning-of-line)
	(if (re-search-forward "[ \n\t]*;" nil t)
	    (progn
	      (replace-match sasmod-end-of-statement)
	      )
	  )
	(backward-char 1)
	(if (sasmod-delete-empty-options)
	    (backward-char 1)
	  )
	(sasmod-help-sas proc (sasmod-get-state proc 't))
	)
      )
    )

  )
(defun sasmod-complete-proc-options (proc &optional init)
  "Completes the options for the current proc, making sure that the cursor is in the right place."
  (if (and init (assoc proc sasmod-proc-options))
      (progn
	(setq complete (car (cdr (assoc proc sasmod-proc-options))))
	(if (< 0 (length complete))
	    (completing-insert complete nil init 'sasmod-light-complete-options-move (concat "proc " (concat proc " options")))
	  )
	)
    ;;
    ;; Move to the appropriate place.
    ;;
    (if (and sasmod-completing-options-flag (assoc proc sasmod-proc-options))
	(progn
	  (if (re-search-forward sasmod-end-of-statement nil t)
	      (progn
		(setq sasmod-completing-options-flag nil)
		(backward-char 1)
		(insert-string " ")
		(sasmod-complete-proc-options proc 0)
		)
	    )
	  )
      (setq sasmod-completing-options-flag 't)
      (beginning-of-line)
      (if (re-search-forward "[ \n\t]*;" nil t)
	  (progn
	    (replace-match sasmod-end-of-statement)
	    )
	)
      (backward-char 1)
      (sasmod-help-sas proc (sasmod-get-state proc 't))
      )
    )
  )
(defun sasmod-completed-statement (arg)
  "Run after a statement is completed."
  (setq tmp (car arg))
  (setq proc (sasmod-get-current-proc))
  (if (string= proc "data")
      ()
    (if (string-match "^\\([a-z]*\\)#" tmp)
	(progn
	  (setq numState (match-string 1 tmp))
	  (message numState)
	  (save-excursion
	    (setq start (point))
	    (if (re-search-backward (concat "proc *" proc) nil t)
		(setq start (+ (point) (length (match-string 0))))
	      )
	    )
	  (save-excursion
	    (narrow-to-region start (point))
	    (goto-char (point-max))
	    (if (re-search-backward (concat ";[ \n\t]*" (regexp-quote numState) "\\([0-9]*\\)[ \n\t]+") nil t)
		(progn
		  (setq number (number-to-string (+ 1 (string-to-number (match-string 1)))))
		  (if (string= number "1")
		      (setq number "2"))
		  )
	      (setq number "")
	      )
	    (widen)
	    )
	  (save-excursion
	    (if (re-search-backward "#" nil t)
		(replace-match number)
	      )
	    )
	  )
      )
    (if (string-match (regexp-quote "/**/") tmp)
	(if (re-search-backward (regexp-quote "/**/") nil t)
	    (replace-match "")
	  )
      )
    (if (looking-at "[ \t]*$")
	(progn
	  (setq ins ";")
	  (insert ins)
	  (backward-char 1)
	  )
      )
    (if (looking-at ";")
	(insert " ")
      )
    (if (and (looking-at ";") (not sasmod-add-semicolon-at-end-of-line))
	(delete-char)
      )
    (if (looking-at "[ \t]+;")
	(forward-char 1)
      )
    (sasmod-help-sas proc tmp)
    )
  )
(defun sasmod-completed-proc (arg)
  "Run after a procedure is completed."
  (let (
	(tmp nil)
	(isquit nil)
	(ins "")
	(beg "")
	)
    (save-excursion
      (if (re-search-backward "^\\([ \t]*\\)\\=" nil t)
	  (setq beg (match-string 0)))
      )
    (setq tmp (car (all-completions (concat "proc " (car arg) " ") sasmod-mode-light-procs)))
    (if (= 1 (length tmp))
	(if (string-match "quit;" tmp)
	    (setq isquit 't)
	  )
      )
    (if (= 0 sasmod-add-run-quit) 
	(setq ins " ")
      (if (= 1 sasmod-add-run-quit) 
	  (if isquit
	      (setq ins " ;\nquit;")
	    (setq ins " ;\nrun;")
	    )
	(if (= 2 sasmod-add-run-quit)
	    (if isquit
		(setq ins " \nquit;")
	      (setq ins " \nrun;")
	      )
	  )
	)
      )
    (if (sasmod-is-between "\\(proc\\)" "\\(run\\|quit\\);")
	(if (looking-at ";")
	    (insert " ")
	  )
      (insert ins)
      (backward-char (length ins))
      (forward-char 1)
      )
    )
  )
(defun sasmod-tab ()
  (interactive)
  (if (looking-at "^\\=")
      (sasmod-indent)      
    (setq sasmod-completing-options-flag 't)
    (if (not sasmod-use-lightning)
	(progn
	  )
      (if (not (sasmod-is-between "\\(proc\\|data\\)" "\\(run\\|quit\\);" t))
	  (progn
	    (sasmod-complete-tag)
	    )
	(setq proc (sasmod-get-current-proc))
	;;
	;; is this procedure in the list?
	;;
	(if (not (or (string= proc "data") (assoc proc sasmod-procs)))
	    (progn
	      ;;
	      ;; Complete the procedure if you are sitting at it.
	      ;;
	      (setq init nil)
	      (save-excursion
		(if (re-search-backward "proc[ \t\n]+\\([-a-z0-9_]*\\)\\=" nil t)
		    (setq init (length (match-string 1)))
		  )
		)
	      (if init
		  (completing-insert sasmod-procs nil init 'sasmod-completed-proc "SAS Procedures")
		)
	      )
	  ;;
	  ;; Get some information about how this proc's statement should be completed.
	  ;;
	  (setq semi sasmod-end-of-statement)
	  (setq next sasmod-next-statement)
	  (setq option sasmod-option)
	  (if (assoc proc sasmod-alternate-statements)
	      (progn
		(setq complete (car (cdr (assoc proc sasmod-alternate-statements))))
		(if (assoc ";" complete)
		    (setq semi (car (cdr (assoc ";" complete))))
		  )
		(if (assoc "state" complete)
		    (setq next (car (cdr (assoc "state" complete))))
		  )
		(if (assoc "/" complete)
		    (setq opt (car (cdr (assoc "/" complete))))
		  )
		)
	    )
	  (setq procp nil)
	  (if (string= "data" proc)
	      (setq reg "data")
	    (setq reg "proc[ \n\t]+[a-z][-_a-z0-9]*")
	    )
	  (save-excursion
	    (if (re-search-backward reg nil t)
		(setq procp (point)))
	    )
	  (if (sasmod-is-between reg sasmod-end-of-statement 't)
	      (progn
		;;
		;; Completing within current proc
		;;

		(if (string= proc "data")
		    (progn
		      (save-excursion
			(if (re-search-backward "\\([-a-z0-9_]*\\)\\=" nil t)
			    (setq init (length (match-string 1))))
			(if init
			    (completing-insert (sasmod-get-alist "data" "data") nil init nil "Data")
			  )
			)
		      )
		  (setq what nil)
		  (setq init nil)
		  (save-excursion
		    (if (re-search-backward sasmod-last-equals nil t)
			(progn
			  (if (< procp (point))
			      (progn
				(setq what (concat (match-string 1) "="))
				(setq init (length (match-string 2)))
				)
			    )
			  )
		      )
		    )
		  (if what
		      (sasmod-help-proc-ops proc what init)
		    (save-excursion
		      (if (re-search-backward sasmod-last-option nil t)
			  (if (< procp (point))
			      (progn
				(setq what (match-string 1))
				(setq init (length (match-string 1)))
				)
			    )
			(if (not (re-search-backward "[ \t\n]+\\=" nil t))
			    (setq what nil)
			  )
			)
		      )
		    (if what
			(progn
			  (sasmod-complete-proc-options proc init)
			  )
		      (sasmod-complete-proc-options proc 0)
		      )
		    )
		  )
		)
	    (setq state (sasmod-get-state proc))
	    (message state)
	    (setq where (sasmod-is-between2 next option semi 't))
	    (if (not where)
		(if (assoc proc sasmod-help)
		    (progn
		      (setq complete (sasmod-get-full-state-completion proc))
		      (completing-insert complete nil 0 'sasmod-completed-statement (concat "proc " proc "'s statements."))
		      )
		  )
	      )
	    (if (assoc proc sasmod-help)
		(progn
		  (setq atState nil)
		  (save-excursion
		    (if (re-search-backward "[ \n\t;]+\\([a-z][_a-z0-9]*\\)\\=" nil t )
			(progn
			  (if (string= (match-string 1) state)
			      (setq atState 't)
			    )
			  )
		      )
		    )
		  (if atState
		      (progn
			(setq complete (sasmod-get-full-state-completion proc))
			(setq tmp (all-completions state complete))
			(if (> (length tmp) 0)
			    (progn
			      (setq where nil)
			      (completing-insert complete nil (length state) 'sasmod-completed-statement (concat "proc " proc "'s statements."))
			      )
			  )
			)
		    )
		  )
	      )
	    (setq state (sasmod-get-state proc nil 't))
	    (if where
		(if (or (= where 4) (= where 1))
		    (progn
		      ;; Before the options.
		      (setq what nil)
		      (setq init nil)
		      (save-excursion 
			(if (re-search-backward sasmod-last-equals nil t)
			    (progn 
			      (if (< procp (point))
				  (progn
				    (setq what (concat (match-string 1) "="))
				    (setq init (length (match-string 2)))
				    )
				)
			      )
			  )
			)
		      (if what
			  (progn
			    (sasmod-help-state-ops proc state what init "-")
			    )
			(save-excursion
			  (if (re-search-backward sasmod-last-option nil t)
			      (if (< procp (point))
				  (progn 
				    (setq what (match-string 1))
				    (setq init (length (match-string 1)))
				    )
				)
			    (if (re-search-backward "[ \t\n]+\\=" nil t)
				(setq what 't)
			      )
			    )
			  )
			(if what
			    (progn
			      (if init
				  (sasmod-complete-state-options proc state init "-")
				(sasmod-complete-state-options proc state 0 "-")
				)
			      )
			  )
			)
		      )
		  (if (= where 2)
		      (progn
			;;
			;; In the options part of the statement.
			;;
			(setq what nil)
			(setq init nil)
			(save-excursion
			  (re-search-backward "/" nil t)
			  (forward-char 1)
			  (if (not (looking-at "[ \t]+") )
			      (insert " ")
			    )
			  )
			(setq move nil)
			(save-excursion
			  (backward-char 1)
			  (if (looking-at "/")
			      (setq move 't))
			  )
			(if move
			    (forward-char 1))
			(save-excursion
			  (if (re-search-backward sasmod-last-equals nil t)
			      (progn
				(if (< procp (point))
				    (progn
				      (setq what (concat (match-string 1) "="))
				      (setq init (length (match-string 2)))
				      )
				  )
				)
			    )
			  )
			(if what
			    (progn
			      (sasmod-help-state-ops proc state what init)
			      )
			  (save-excursion
			    (if (re-search-backward sasmod-last-option nil t)
				(if (< procp (point))
				    (progn
				      (setq what (match-string 1))
				      (setq init (length (match-string 1)))
				      )
				  )
			      (if (re-search-backward "[ \t\n]+\\=" nil t)
				  (setq what 't)
				)
			      )
			    )
			  (if what
			      (sasmod-complete-state-options proc state init)
			    )
			  )
			)
		    )
		  )
	      )
	    )
	  )
	)
      )
    (sasmod-indent)
    )
  )
(defun sasmod-mode-return ()
  "Lightning completion control for smart return"
  (interactive)
  (sasmod-indent)
  (newline-and-indent)
  )
(defun sasmod-toggle-magic-letters ()
  "Toggles Magic Letters."
  (interactive)
  (setq sasmod-magic-p (not sasmod-magic-p))
)
(defun sasmod-end-of-line ()
  "This function goes to the end of line, unless in a boxed comment, then go to the end of a comment line."
  (interactive)
  (let (
	(comment nil)
	)
    (save-excursion
      (beginning-of-line)
      (if (looking-at "^[ \t]*|.*|[ \t]*$")
	  (setq comment 't))
      )
    (if (and comment (looking-at "[ \t]*|[ \t]*$"))
	(setq comment nil))
    (if (and comment (not (sasmod-is-between (regexp-quote "/*") (regexp-quote "*/"))))
	(setq comment nil))
    (if (not comment)
	(end-of-line)
      (end-of-line)
      (re-search-backward "|[ \t]*\\=" nil t)
      (re-search-backward "[^ \t][ \t]*\\=" nil t)
      (forward-char 1)
      )
    )
  )
(defun sasmod-mode-light-p ()
  "Lightning complete control sequence."
  (interactive)
  (insert "p")
  (if (and sasmod-magic-p sasmod-use-lightning)
      (progn
	;;
	;; If it is at the beginning of a line.
	;;
	(setq bol nil)
	(save-excursion
	  (beginning-of-line)
	  (if (looking-at "^p$")
	      (setq bol 't))
	  (setq pt (point))
	  )
	(if bol
	    (progn
	      ;;
	      ;; if is is not in a commment or string.
	      ;;
	      (let ((f (get-text-property pt 'face)))
		(if (not (memq f nonmem-prog-text-faces))
		    (progn		      
		      (completing-insert sasmod-mode-light-procs nil 1 'sasmod-light-complete-move
					 "sas procs")
		      )
		  )
		)
	      )
	  )
	)
    )
  )

(defun sasmod-dd ()
  (if usefulldir
      sasmod-dot-dot
    ".."
    ))

(defun sasmod-toggle-dd ()
  (interactive)
  (if usefulldir
      (progn
	(setq usefulldir nil)
	(message "No longer using full directory")
	)
    (setq usefulldir 't)
    (message "Use full directory")
    )
)

(require 'sasmod-options)
(require 'sasmod-cookies)
(require 'sasmod-templates)
(require 'sasmod-keys)
(require 'saslog-mode)
(require 'saslst-mode)
(require 'sasmod-indent)
(require 'tempo)
(require 'light)
(autoload 'rebox-comment "rebox" nil t)
(autoload 'rebox-region "rebox" nil t)


;;
;; Passed to tempo-use-tag-list to find tags to complete.
;;
(defvar sasmod-completion-finder
  "^[ \t]*\\(.*?\\)\\=")
(defvar sasmod-tempo-tags nil
  "List of tags used in completion")

(defun sasmod-add-cookie (l)
  (setq count 0)
  (setq tl (nth count l))
  (while tl
    ;;
    ;; Get template name.
    ;;
    (setq fn (nth 0 tl))
    (while (string-match "[^A-Za-z]+" fn)
      (setq fn (replace-match "" nil nil fn))
      )
    (setq fn (concat "sasmod-" fn))
    (message (concat "Creating autocompletion " fn))
    (tempo-define-template fn (nth 1 tl) (nth 0 tl) nil 'sasmod-tempo-tags)
    ;; Next element
    (setq count (+ count 1))
    (setq tl (nth count l))
    )
  )

(defun sasmod-complete-tag ()
  (interactive)
  (if (not sasmod-play-with-flyspell)
      (progn 
	(tempo-complete-tag)
	)
    (let ((f (get-text-property (point) 'face)))
      (if (memq f sasmod-prog-text-faces)
	  (flyspell-auto-correct-word)
	(progn
	  (tempo-complete-tag)
	  )
	)
      )
    )
  )
(defun sasmod-get-data-dir (prefix dir &optional reg)
  (setq  data (directory-files dir nil (concat ".*" (or reg sasmod-reg-filen))))
  (setq len (length data))
  (setq i 0)
  (while (< i len)
    (setq tmp (nth i data))
    ;;    (setq tmp (substring tmp 0 (- (length tmp) 9)))
    (while (string-match (or reg sasmod-reg-filen) tmp)
      (setq tmp (replace-match "" nil nil tmp))
      )
    (setq tmp (concat prefix tmp))
    (message "%s" tmp)
    (setq i (+ i 1))
    (sasmod-add-to-alist 'sasmod-dsn-local (cons tmp 0))
    )
)
(defun sasmod-align-equals-statement (state &optional break direction)
  "Aligns at an equals for a statment state.
If break is true, then add a line break before the equals statment.
"
  ;;
  ;; For some reason the save-excursion does not work...
  ;;
  (setq proc (sasmod-get-current-proc))
  (save-excursion
    (if (re-search-backward (concat ";[\n\t ]*" (regexp-quote state)) nil t)
	(forward-char (length state))
      )
    (setq startp (point))
    (if (re-search-forward ";" nil t)
	(backward-char 1))
    (setq endp (point))
    )
  (setq start startp)
  (setq end endp)
  (if break
      (progn
	(save-excursion
	  (narrow-to-region start end)
	  (goto-char (point-min))
	  (while (re-search-forward "\\([ \t]*[a-z][_a-z0-9]*[ \t]*\\)=" nil t)
	    (replace-match "\n\\1=")
	    )
	  (goto-char (point-min))
	  (while (re-search-forward "\\([ \t]*\n\\)+" nil t)
	    (replace-match "\n")
	    )
	  (goto-char (point-min))
	  (if (and direction (looking-at "\n"))
	      (replace-match ""))
	  (setq start (point-min))
	  (setq end (point-max))
	  (widen)
	  (goto-char start)
	  (forward-line 1)
	  (sasmod-indent)
	  )
	(sasmod-align-equals-statement state nil direction)
	)
    (sasmod-align-equals startp endp "=" direction)
    )
  )
(defun sasmod-align-equals (start end &optional regexpAlign rightAlign regexpSpace spaceChar spaceBefore spaceAfter)
  "Aligns the current items based on the equal sign.
start		= where the aligned region should start
end		= where the aligned region should end
regexpAlign	= the character that aligns
rightAlign	= true if the alignment is right-justified instead of left.
regexpSpace	= Regular expression for space;  default [ \t]*
spaceCharacter	= What character should be used to make a space.
spaceBefore	= Number of spaces before the alignment character
spaceAfter	= Number of spaces after the alignment character.
"
  (setq align (or regexpAlign "="))
  (setq spaceReg (or regexpSpace "[ \t]*"))
  (setq regexp (concat "^\\(" spaceReg "\\)\\(.*\\)\\(" align"\\)\\(" spaceReg "\\)"))
  (setq space (or spaceChar ? ))
  (setq firstLineAmt 0)
  (save-excursion
    (goto-char start)
    (beginning-of-line)
    (setq firstLineAmt (- start (point)))
    )
  (save-excursion
    (narrow-to-region start end)
    (goto-char (point-min))
    (setq maxpre 0)
    (setq maxsum 0)
    (while (re-search-forward regexp nil t)
      (if rightAlign
	    (setq maxpre (max (length (match-string 2)) maxpre))
	(setq maxpre (max (length (match-string 1)) maxpre))
	(if (= maxpre 0 )
	    (setq maxpre (+ maxpre firstLineAmt))
	    )
	)
      )
    ;;
    ;; Step one, align ALL of the pre-spaces.
    ;;
    (goto-char (point-min))
    (setq sb (make-string (or spaceBefore 1) space))
    (setq sa (make-string (or spaceAfter 1) space))
    (while (re-search-forward regexp nil t)
      (if rightAlign
	  (setq pre (length (match-string 2)))
	(setq pre (length (match-string 1)))
	)
      (if (< pre maxpre)
	  (setq what (make-string (- maxpre pre) space))
	(setq what "")
	)
      (if rightAlign
	  (replace-match (concat (match-string 1) (match-string 2) what (match-string 3)) t t)
	(replace-match (concat (match-string 1) what (match-string 2) (match-string 3)) t t)
	)
      )
    (goto-char (point-min))
    (setq first 't)
    (while (re-search-forward regexp nil t)
      (setq item (match-string 2))
      (setq pre (match-string 1))
      (if rightAlign
	  (save-excursion
	    (beginning-of-line)
	    (if (looking-at (concat "^" spaceReg))
		(if (re-search-forward (concat "^" spaceReg) nil t)
		    (replace-match " ")
		  )
	      )
	    (setq pre 1)
	    )
	(setq pre (length pre))
	)
      (if (string-match (concat "\\(" spaceReg "\\)$") item)
	(setq item (replace-match "" nil nil item))
	)
      (if first
	  (save-excursion
	    (beginning-of-line)
	    (if (= start (point))
		(setq pre (+ pre firstLineAmt))
	      )
	    (setq first nil)
	    )
	)
      (setq maxsum (max maxsum (+ pre (length item))))
      )
    (goto-char (point-min))
    (setq first 't)
    (while (re-search-forward regexp nil t)
      (setq pre (length (match-string 1)))
      ;;
      ;; Take of spaces from match-string 2.
      ;;
      (setq item (match-string 2))
      (setq m1 (match-string 1))
      (setq m3 (match-string 3))
      (replace-match "" t t)
      (setq exit nil)
      (if (string-match (concat "\\(" spaceReg "\\)$") item)
	(setq item (replace-match "" nil nil item))
	)
      (setq pre (+ pre (length item)))
      (if first
	  (save-excursion
	    (beginning-of-line)
	    (if (= start (point))
		(setq pre (+ pre firstLineAmt))
	      )
	    (setq first nil)
	    )
	)

      (if (< pre maxsum)
	  (setq what (make-string (- maxsum pre) space))
	(setq what "")
	)
      (if rightAlign
	  (insert (concat m1 what item sb m3 sa))
	(insert (concat m1 item what sb m3 sa))
	)
      )
    (widen)
    )
  )
(defun sasmod-light-complete-options-move (arg)
  (setq sasmod-completing-options-flag 't)
  (setq more nil)
  (setq bet (or (sasmod-is-between2 "^" (regexp-quote "/**/") "$") ))
  (if (and bet (and (= bet 1) (re-search-forward (regexp-quote "/**/") nil t)))
      (replace-match "")
    (if (and bet (and (= bet 2) (re-search-backward (regexp-quote "/**/") nil t)))
	(replace-match "")
      )
    (if (and (looking-at "$") (re-search-backward (regexp-quote "/**/") nil t))
      (replace-match "")
      )
    )
  (save-excursion
    (if (re-search-backward "=[ \t]*\\=" nil t)
	(setq more 't)
      )
    )
  ;; 
  ;; Move backward on format completions.
  (setq moveBackward nil)
  (setq quote nil)
  (save-excursion
    (backward-char 1)
    (if (looking-at "\\.")
	(if (re-search-backward "\\(\$?[a-zA-z0-9]+\\)\\=" nil t)
	    (setq moveBackward (match-string 1))))
    (if (looking-at "'")
	(setq quote 't))
    )
  (if quote
      (progn
	(setq state (sasmod-get-state (sasmod-get-current-proc) ))
	(if (string= state "label")
	    (progn 
	      (save-excursion
		;; get to the end of the statement.
		(backward-word)
		(if (not (re-search-backward "^[ \t\n]*\\=" nil t))
		    (insert "\n")
		  )
		(sasmod-indent)
		(end-of-line)
		(backward-char 1)
		(if (looking-at ";")
		    (progn
		      (insert "\n")
		      (sasmod-indent)
		      )
		  )
		(if (re-search-backward (regexp-quote "/**/") nil t)
		    (replace-match "")
		  )

		;;
		;; now align-regexp
		;;
		(sasmod-align-equals-statement "label" 't)
		)
	      )
	  )
	)
    )
  (if moveBackward
      (progn
	(if (assoc moveBackward sasmod-formats)
	    (progn
	      ;;
	      ;; Message help.
	      ;;
	      (backward-char 1)	
	      (setq msg (nth 2 (assoc moveBackward sasmod-formats)))
	      (message "%s" msg)
	      )
	  (message "User Defined Format.")
	  )
	)
    )
  (if more
      (sasmod-tab)
    )
  )
(defun sasmod-light-complete-move (arg)
  (forward-char (car (cdr arg)))
  (setq sasmod-last-return-pos "out=")
  (sasmod-tab)
)

(defun sasmod-get-alist-data ()
  (setq found 't)
  (sasmod-get-local-data)
  (if found
      (progn
	(if sasmod-get-sasuser
	    (progn 
	      (sasmod-get-data-dir "sasuser." sasmod-get-sasuser)
	      (setq sasmod-get-sasuser nil)
	      )
	  )
	)
    )
  sasmod-dsn-local
  )
(defun sasmod-get-alist-library (&optional dir external)
  "Gets the library data and loads the datasets into external datasets."
  (if (not external)
      (progn
	(sasmod-get-include)
	(setq out '(
		    ("work" 0)
		    ))
	)
    (setq out '())
    )

  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward sasmod-libname nil t)
      (setq ms (match-string 1))
      (if ms
	  (progn
	    (if dir
		(sasmod-get-data-dir (concat ms ".") (match-string 2) )
	      )
	    (message "Adding Library: %s" ms)
	    (sasmod-add-to-alist 'out (cons ms 0))
	    )
	)
      )
    )
  (setq sasmod-libref-local out)
  (setq out (append out sasmod-libref-ext))
  out
  )
(defun sasmod-get-include ()
  "Get the file information from the files inputted into the current buffer. (Return it)"
  (let
      (
       (ob (current-buffer))
       (cinclude '())
       (empty '())
       (ext '())
       (extl '())
       (dirty nil)
       (tmp nil)
       (buf nil)
       (sgii 0)
       (sgilen 0)
       )
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward sasmod-include nil t)
	(progn
	  (setq tmp (expand-file-name (match-string 1)))
	  (sasmod-add-to-alist 'cinclude (cons tmp 0))
	  (if (not (assoc tmp sasmod-includes))
	      (progn
		(setq dirty 't)
		)
	    )
	  )
	)
      )
    (if (not (= (length cinclude) (length sasmod-includes)))
	(setq dirty 't)
      )
    (if (= (length cinclude) 0)
	(setq dirty 't))
    (if (not dirty)
	(message "No new includes.")
      (message "Rebuild include information.")
      (setq sasmod-includes cinclude)
      (setq sgii 0)
      (setq sgilen (length (all-completions "" cinclude)))
      (while (< sgii sgilen)
	(setq tmp (car (nth sgii cinclude)))
	(if (and tmp (file-readable-p tmp))
	    (progn
	      (setq buf (set-buffer (generate-new-buffer tmp)))
	      (insert-file-contents tmp t)
	      (sasmod-get-all-buffer-info)
	      (setq ext (append ext sasmod-dsn-local))
	      (setq extl (append extl sasmod-libref-local))
	      (kill-buffer (current-buffer))
	      )
	  )
	(setq sgii (+ sgii 1))
	)
      (if ob
	  (set-buffer ob)
	)
      (setq sasmod-dsn-ext ext)
      (setq sasmod-libref-ext extl)
      (setq sasmod-dsn-local empty)
      (setq sasmod-libref-local empty)
      )
    )
  )
(defun sasmod-get-all-buffer-info ()
  ;;
  ;; Get all the current buffer's information.
  ;;
  (sasmod-get-local-data 't)
)
(defun sasmod-get-local-data (&optional external)
  (if (not external)
      (sasmod-get-include)
    )
  (setq sasmod-dsn-local
	sasmod-dsn-ext)
  (sasmod-get-alist-library 't external)
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward "^ *data +\\([A-Za-z_][A-Za-z_0-9]*\\)" nil t)
      (setq tmp (match-string 1))
      (if (not (or (looking-at "[ \t\n]*=") (looking-at "\\.")))
	  (progn
	    (sasmod-add-to-alist 'sasmod-dsn-local  (cons tmp 0))
	    (sasmod-add-to-alist 'sasmod-dsn-local (cons (concat "work." tmp) 0))
	    )
	)
      )
    (goto-char (point-min))
    (while (re-search-forward "^ *data +\\([A-Za-z_][A-Za-z_0-9]*\\.[A-Za-z_][A-Za-z_0-9]*\\)" nil t)
      (setq tmp (match-string 1))
      (sasmod-add-to-alist 'sasmod-dsn-local  (cons tmp 0))
      )
    (while (re-search-forward " +out *= *\\([A-Za-z_][A-Za-z0-9_]*\\)" nil t)
      (setq tmp (match-string 1))
      (if (not (or (looking-at "[ \t\n]*=") (looking-at "\\.")))
	  (progn
	    (sasmod-add-to-alist 'sasmod-dsn-local  (cons tmp 0))
	    (sasmod-add-to-alist 'sasmod-dsn-local (cons (concat "work." tmp) 0))
	    )
	)
      )
    (goto-char (point-min))
    (while (re-search-forward " +out *= *\\([A-Za-z_][A-Za-z0-9_]*\\.[A-Za-z_][A-Za-z_0-9]*\\)" nil t)
      (setq tmp (match-string 1))
      (sasmod-add-to-alist 'sasmod-dsn-local  (cons tmp 0))
      )
    (goto-char (point-min))
    (while (re-search-forward "^ *create *table *\\([A-Za-z_][A-Za-z0-9_]*\\)" nil t)
      (setq tmp (match-string 1))
      (if (not (or (looking-at "[ \t\n]*=") (looking-at "\\.")))
	  (progn
	    (sasmod-add-to-alist 'sasmod-dsn-local  (cons tmp 0))
	    (sasmod-add-to-alist 'sasmod-dsn-local (cons (concat "work." tmp) 0))
	    )
	)
      )
    (goto-char (point-min))
    (while (re-search-forward "^ *create *table *\\([A-Za-z_][A-Za-z0-9_]\\.[A-Za-z_][A-Za-z0-9_]*\\)" nil t)
      (setq tmp (match-string 1))
      (sasmod-add-to-alist 'sasmod-dsn-local (cons tmp 0))
      )
    )
  ;;
  ;; Do Data# processing
  ;;
  (setq i 1)
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward "^[ \t]*data[ \t]*;" nil t)
      (while (assoc (format "data%g" i) sasmod-dsn-local)
	(setq i (+ i 1))
	)
      (sasmod-add-to-alist 'sasmod-dsn-local (cons (format "data%g" i) 0))
      (sasmod-add-to-alist 'sasmod-dsn-local (cons (format "work.data%g" i) 0))
      )
    )
  ;;
  ;; Add the two default datasets.
  ;;
  (sasmod-add-to-alist 'sasmod-dsn-local (cons "_last_" 0))
  (sasmod-add-to-alist 'sasmod-dsn-local (cons "_null_" 0))
  )
(defun sasmod-get-data ()
  (setq tmp "")
  (if (string-match " \\([^ ]*\\)\\([^;]*\\)" sasmod-dsn)
      (progn
	(setq tmp (match-string 1 sasmod-dsn))
	(setq sasmod-dsn (concat (match-string 2 sasmod-dsn) (concat (match-string 1 sasmod-dsn) " ")))
	)
    )
  tmp
  )
(defun sasmod-cookies nil
  "Variable for sas cookies")

(defun* sasmod-comment()
  "Insert new comment, or comment out region."
  (interactive) ;; Let it be visible!
  (tempo-template-sasmod-)
)

(defvar sasmod-mode-syntax-table nil)
(if sasmod-mode-syntax-table
    ()
  (setq sasmod-mode-syntax-table (make-syntax-table))

;; (if (equal system-type 'windows-nt)
;;     ;; backslash is punctuation (used in MS file names)
;;     (modify-syntax-entry ?\\ "."  sasmod-mode-syntax-table)
;;    ;; backslash is an escape character
;;    (modify-syntax-entry ?\\ "\\" sasmod-mode-syntax-table))
(modify-syntax-entry ?\\ "."  sasmod-mode-syntax-table)  ;; backslash is punctuation
(modify-syntax-entry ?+  "."  sasmod-mode-syntax-table)
(modify-syntax-entry ?-  "."  sasmod-mode-syntax-table)
(modify-syntax-entry ?=  "."  sasmod-mode-syntax-table)
(modify-syntax-entry ?%  "w"  sasmod-mode-syntax-table)
(modify-syntax-entry ?<  "."  sasmod-mode-syntax-table)
(modify-syntax-entry ?>  "."  sasmod-mode-syntax-table)
(modify-syntax-entry ?&  "w"  sasmod-mode-syntax-table)
(modify-syntax-entry ?|  "."  sasmod-mode-syntax-table)
(modify-syntax-entry ?\' "\"" sasmod-mode-syntax-table)
(modify-syntax-entry ?*  ". 23"  sasmod-mode-syntax-table) ; comment character
(modify-syntax-entry ?\; "."  sasmod-mode-syntax-table)
(modify-syntax-entry ?_  "w"  sasmod-mode-syntax-table)
(modify-syntax-entry ?<  "."  sasmod-mode-syntax-table)
(modify-syntax-entry ?>  "."  sasmod-mode-syntax-table)
(modify-syntax-entry ?/  ". 14"  sasmod-mode-syntax-table) ; comment character
(modify-syntax-entry ?.  "w"  sasmod-mode-syntax-table)
)

;(define-derived-mode sasmod-mode sas-mode "SAS (MLF)"
(defun sasmod-mode ()
  "Major mode for editing SAS code"
  (interactive)
  (kill-all-local-variables)
  (set-syntax-table sasmod-mode-syntax-table)
  (set (make-local-variable 'indent-line-function) 'sasmod-indent)
  (setq comment-start "*")
  (setq comment-start-skip "*\\W*")
  ;;
  ;; Some good variables to initialize.
  ;;
  (make-variable-buffer-local 'sasmod-last-par-del)
  (make-variable-buffer-local 'sasmod-libref-local)
  (make-variable-buffer-local 'sasmod-libref-ext)
  (make-variable-buffer-local 'sasmod-includes)
  (make-variable-buffer-local 'sasmod-dot-dot)
  (make-variable-buffer-local 'sasmod-dsn-local)
  (make-variable-buffer-local 'sasmod-dsn-llocal)
  (make-variable-buffer-local 'sasmod-dsn)
  (make-variable-buffer-local 'sasmod-dsn-ext)
  (make-variable-buffer-local 'sasmod-get-sasuser)
  (setq sasmod-dot-dot (sasmod-chop-dir (sasmod-chop-dir (buffer-file-name))))
  (make-variable-buffer-local 'rebox-set-box-size)
  (make-variable-buffer-local 'rebox-no-wrap)
  (make-variable-buffer-local 'rebox-uncomment)
  ;;
  ;; Column Wrapping length
  ;;
  (setq-default fill-column 75)
  (if sasmod-play-with-cua
	(use-local-map sasmod-mode-map-cua)
      (use-local-map sasmod-mode-map)
    )
  (define-key sasmod-mode-map "p" 'sasmod-mode-light-p)
  (define-key sasmod-mode-map [(control m)] 'sasmod-mode-return)
  (define-key sasmod-mode-map [(control j)] 'sasmod-mode-return)
  (define-key sasmod-mode-map [(control i)] 'sasmod-mode-tab)
  (define-key sasmod-mode-map [(control e)] 'sasmod-end-of-line)
  ;;
  ;; Turn on autocompletion.
  ;;
  (sasmod-add-cookie sasmod-cookies)
  (sasmod-add-cookie sasmod-extra-completion)
  (tempo-use-tag-list 'sasmod-tempo-tags sasmod-completion-finder)
  ;; register fontlock keywords
  ;; Lifted from Emacs Speaks statistics.
  (defvar sasmod-mode-font-lock-keywords
    (append
     (list
	 (cons "^[ \t]*%?\\*.*;"		font-lock-comment-face)
	 (cons ";[ \t]*%?\\*.*;"		font-lock-comment-face)
	 (list "/\\*\\([^*/]\\)*\\*/"      0  font-lock-comment-face t)

	 ;; SAS execution blocks, DATA/RUN, PROC/RUN, %MACRO/%MEND
	 (cons "\\<\\(data\\|run\\|%macro\\|%mend\\)\\>" font-lock-reference-face)
	 (cons "\\<proc[ \t]+[a-z][a-z_0-9]+"            font-lock-reference-face)

	 ;; SAS statements

	 (cons (concat
		"\\<"
		"%?do[ \t]*" (make-regexp '("over" "%?until" "%?while") t) "?"
		"\\>")
	       font-lock-keyword-face)

	 (cons (concat
		"\\<"
		(make-regexp
		 '(
		   "abort" "array" "attrib" "by" "delete" "display" "dm"
		   "drop" "error" "file" "filename" "footnote\\(10?\\|[2-9]\\)?"
		   "format"
		   "%go[ \t]*to" "%if" "%then" "%else"
		   "go[ \t]*to" "if" "then" "else"
		   "infile" "informat" "input" "%input" "keep" "label"
		   "length" "libname" "link"
		   "merge" "missing" "modify" "note" "options" "goptions" "output"
		   "otherwise" "put" "%put" "rename" "retain" "select" "when" "set"
		   "skip" "title\\(10?\\|[2-9]\\)?" "where" "window" "update" "out"
		   "change" "class" "exchange" "exclude" "freq" "id" "index"
		   "model" "plot" "save" "sum" "tables?" "var" "weight" "with"
		   "manova" "repeated" "value" "random" "means" "lsmeans"
		   ;; SAS macro statements not handled above
		   "%global" "%include" "%local" "%let" "%sysexec"
		   ) t) "\\>")
	       font-lock-keyword-face)

	 ;; SAS statements that must be followed by a semi-colon
	 (cons (concat
		"\\<"
		(make-regexp
		 '(
		   "cards4?" "end" "%end" "endsas" "list" "lostcard" "page"
		   "return" "stop"
		   ) t) "\\>" "[ \t]*;")
	       font-lock-keyword-face)

	 ;; SAS/GRAPH statements not handled above
	 (cons (concat
		"\\<"
		(make-regexp
		 '("axis" "legend" "pattern" "symbol") t) "\\([1-9][0-9]?\\)?"
		"\\>")
	       font-lock-keyword-face)

	 ;; SAS functions and SAS macro functions
	 (cons "%[a-z_][a-z_0-9]*[ \t]*[(;]"
	       font-lock-function-name-face)
	 (cons "\\<call[ \t]+[a-z_][a-z_0-9]*[ \t]*("
	       font-lock-function-name-face)

	 (cons (concat
		"\\<"
		(make-regexp
		 '(
		   "abs" "arcos" "arsin" "atan" "betainv" "byte" "ceil" "cinv"
		   "collate" "compress" "cosh?" "css" "cv"
		   "daccdb" "daccdbsl" "daccsl" "daccsyd" "dacctab"
		   "depdb" "depdbsl" "depsl" "depsyd" "deptab"
		   "date" "datejul" "datepart" "datetime" "day" "hms" "dhms" "dif"
		   "digamma" "dim" "erfc?" "exp" "finv"
		   "fipnamel?" "fipstate" "floor" "fuzz" "gaminv" "gamma"
		   "hbound" "hour" "indexc?" "input" "int" "intck" "intnx" "intrr"
		   "irr" "juldate" "kurtosis" "lag" "lbound" "left" "length"
		   "lgamma" "log" "log10" "log2" "max" "mdy" "mean" "min" "minute"
		   "mod" "month" "mort" "n" "netpv" "nmiss" "normal" "npv"
;;;) t) "\\>" "[ \t]*(")
;;;      font-lock-function-name-face)
;;;
;;;    (cons (concat "\\<"
;;;(make-regexp '(
		   "probbeta" "probbnml" "probchi" "probf" "probgam" "probhypr"
		   "probit" "probnegb" "probnorm" "probt"
		   "ordinal" "poisson" "put" "qtr" "range" "rank" "repeat"
		   "ranbin" "rancau" "ranexp" "rangam" "rannor" "ranpoi"
		   "rantbl" "rantri" "ranuni"
		   "reverse" "right" "round" "saving" "scan" "second" "sign" "sinh?"
		   "sqrt" "std" "stderr" "stfips" "stnamel?" "substr" "sum"
		   "symget" "tanh?" "time" "timepart" "tinv" "today" "translate"
		   "trigamma" "trim" "trunc" "uniform" "upcase" "uss" "var"
		   "verify" "weekday" "year" "yyq"
		   "zipfips" "zipnamel?" "zipstate"
;;;) t) "\\>" "[ \t]*(")
;;;      font-lock-function-name-face)
;;;
;;;
;;;    ;; SAS functions introduced in Technical Report P-222
;;;    ;; SCL functions that are known to work with SAS macro function %sysfunc
;;;    (cons (concat "\\<"
;;;(make-regexp '(
		   "airy" "band" "blshift" "brshift" "bnot" "bor" "bxor"
		   "cnonct" "fnonct" "tnonct" "compbl" "dairy" "dequote"
		   "ibessel" "jbessel"
		   "indexw" "inputc" "inputn"  "lowcase"
		   "putc" "putn" "quote" "resolve" "soundex" "sysprod"
		   "tranwrd" "trimn"
		   "%sysfunc" "attrc" "attrn" "cexist" "close" "dclose" "dnum"
		   "dopen" "dread" "exist" "fclose" "fetchobs" "fileexist"
		   "finfo" "fopen" "fput" "fwrite" "getoption"
		   "getvarc" "getvarn" "libname" "libref" "open" "optgetn" "optsetn"
		   "pathname" "sysmsg" "varfmt" "varlabel" "varnum" "vartype"
		   ) t) "\\>" "[ \t]*(")
	       font-lock-function-name-face)
	 )
	(list
	 ;; .log NOTE: messages
	 (cons "^NOTE: .*$"                         font-lock-reference-face)

	 ;; .log ERROR: messages
	 (cons "^ERROR: .*$"                        font-lock-keyword-face)

	 ;; .log WARNING: messages
	 (cons "^WARNING: .*$"                      font-lock-function-name-face)	

	 ;; SAS comments
;; /* */ handled by grammar above
;;	 (list "/\\*.*\\*/"                      0  font-lock-comment-face t)
	 (cons "\\(^[0-9]*\\|;\\)[ \t]*\\(%?\\*\\|comment\\).*\\(;\\|$\\)" font-lock-comment-face)

	 ;; SAS execution blocks, DATA/RUN, PROC/RUN, SAS Macro Statements
	 (cons "\\<%do[ \t]*\\(%until\\|%while\\)?\\>"
						    font-lock-reference-face)
	 ;;(cons (concat "\\(^[0-9]*\\|;\\)[ \t]*"
		;;"%\\(end\\|global\\|local\\|m\\(acro\\|end\\)\\)"
		;;"\\>")				    font-lock-reference-face)
	 (cons "\\<%\\(end\\|global\\|local\\|m\\(acro\\|end\\)\\)\\>"
						    font-lock-reference-face)

	 (cons (concat "\\(^[0-9]*\\|;\\|):\\|%then\\|%else\\)[ \t]*"
		"\\(data\\|endsas\\|finish\\|quit\\|run\\|start\\)[ \t\n;]")
		      				    font-lock-reference-face)
	 (cons (concat "\\(^[0-9]*\\|;\\|):\\|%then\\|%else\\)[ \t]*"
		"proc[ \t]+[a-z][a-z_0-9]+")        font-lock-reference-face)

	 ;;(cons (concat "\\(^[0-9]*\\|;\\|%then\\|%else\\)[ \t]*"
		;;"\\(%\\(go[ \t]*to\\|i\\(f\\|n\\(clude\\|put\\)\\)\\|let\\|put\\|sysexec\\)\\)"
		;;"\\>")				    font-lock-reference-face)
	 (cons "\\<%\\(go[ \t]*to\\|i\\(f\\|n\\(clude\\|put\\)\\)\\|let\\|put\\|sysexec\\)\\>"
						    font-lock-reference-face)

	 (cons "\\<%\\(by\\|else\\|t\\(o\\|hen\\)\\)\\>"
						    font-lock-reference-face)

	 ;; SAS dataset options/PROC statements followed by an equal sign/left parentheses

	 (cons (concat
		"[ \t(,]"
		"\\(attrib\\|by\\|compress\\|d\\(ata\\|rop\\)\\|f\\(irstobs\\|ormat\\)"
		"\\|i\\(d\\|f\\|n\\)\\|ke\\(ep\\|y\\)\\|l\\(abel\\|ength\\)"
		"\\|o\\(bs\\|rder\\|ut\\)\\|rename\\|s\\(ortedby\\|plit\\)"
		"\\|var\\|where\\)"
		"[ \t]*=")
						    font-lock-keyword-face)
	 (cons "\\<\\(in\\(:\\|dex[ \t]*=\\)?\\|until\\|wh\\(en\\|ile\\)\\)[ \t]*("
						    font-lock-keyword-face)

	 ;; SAS statements
	 (cons (concat
		"\\(^[0-9]*\\|):\\|[;,]\\|then\\|else\\)[ \t]*"
		"\\(a\\(bort\\|rray\\|ttrib\\)\\|by"
		"\\|c\\(hange\\|lass\\|ontrast\\)"
		"\\|d\\(elete\\|isplay\\|m\\|o\\([ \t]+\\(data\\|over\\)\\)?\\|rop\\)"
		"\\|e\\(rror\\|stimate\\|xc\\(hange\\|lude\\)\\)"
		"\\|f\\(ile\\(name\\)?\\|o\\(otnote\\(10?\\|[2-9]\\)?\\|rmat\\)\\|req\\)"
		"\\|go\\([ \t]*to\\|ptions\\)"
		"\\|i\\(d\\|f\\|n\\(dex\\|f\\(ile\\|ormat\\)\\|put\\|value\\)\\)"
		"\\|keep\\|l\\(abel\\|ength\\|i\\(bname\\|nk\\|st\\)\\|smeans\\)"
		"\\|m\\(anova\\|e\\(ans\\|rge\\)\\|issing\\|od\\(el\\|ify\\)\\)\\|note"
		"\\|o\\(ptions\\|therwise\\|utput\\)\\|p\\(lot\\|ut\\)"
		"\\|r\\(andom\\|e\\(name\\|peated\\|tain\\)\\)"
		"\\|s\\(ave\\|e\\(lect\\|t\\)\\|kip\\|trata\\|umby\\)"
		"\\|t\\(ables?\\|i\\(me\\|tle\\(10?\\|[2-9]\\)?\\)\\)\\|update"
		"\\|va\\(lue\\|r\\)\\|w\\(eight\\|here\\|i\\(ndow\\|th\\)\\)"

	;; IML statements that are not also SAS statements
		"\\|append\\|c\\(lose\\(file\\)?\\|reate\\)\\|edit\\|f\\(ind\\|orce\\|ree\\)"
		"\\|insert\\|load\\|mattrib\\|p\\(a[ru]se\\|rint\\|urge\\)"
		"\\|re\\(move\\|peat\\|place\\|set\\|sume\\)"
		"\\|s\\(et\\(in\\|out\\)\\|how\\|ort\\|tore\\|ummary\\)\\|use\\)?"

		"\\>")				    font-lock-keyword-face)

	

;;	 (cons "\\<\\(\\(then\\|else\\)[ \t]*\\)?\\(do\\([ \t]*over\\)?\\|else\\)\\>"
;;						    font-lock-keyword-face)

	 ;; SAS statements that must be followed by a semi-colon
	 (cons (concat
		"\\(^[0-9]*\\|):\\|[;,]\\|then\\|else\\)[ \t]*"
		"\\(cards4?\\|datalines\\|end\\|l\\(ostcard\\)\\|page\\|return\\|stop\\)?"
		"[ \t]*;")			    font-lock-keyword-face)

	 ;; SAS/GRAPH statements not handled above
	 (cons (concat
		"\\(^[0-9]*\\|):\\|[;,]\\)[ \t]*"
		"\\(axis\\|legend\\|pattern\\|symbol\\)"
		"\\([1-9][0-9]?\\)?\\>")	    font-lock-keyword-face)

	 ;; SAS Datastep functions and SAS macro functions
	 (cons "%[a-z_][a-z_0-9]*[ \t]*[(;]"
						    font-lock-function-name-face)
	 (cons "\\<call[ \t]+[a-z_][a-z_0-9]*[ \t]*("
						    font-lock-function-name-face)

	 (cons (concat
		"\\<"
		"\\(a\\(bs\\|r\\(cos\\|sin\\)\\|tan\\)\\|b\\(etainv\\|yte\\)"
		"\\|c\\(eil\\|inv\\|o\\(llate\\|mpress\\|sh?\\)\\|ss\\|v\\)"
		"\\|dacc\\(db\\(\\|sl\\)\\|s\\(l\\|yd\\)\\|tab\\)"
		"\\|dep\\(db\\(\\|sl\\)\\|s\\(l\\|yd\\)\\|tab\\)"
		"\\|d\\(a\\(te\\(\\|jul\\|part\\|time\\)\\|y\\)\\|hms\\|i\\([fm]\\|gamma\\)\\)"
		"\\|e\\(rfc?\\|xp\\)"
		"\\|f\\(i\\(nv\\|p\\(namel?\\|state\\)\\)\\|loor\\|uzz\\)\\|gam\\(inv\\|ma\\)"
		"\\|h\\(bound\\|ms\\|our\\)\\|i\\(n\\(dexc?\\|put\\|t\\(\\|ck\\|nx\\|rr\\)\\)\\|rr\\)"
		"\\|juldate\\|kurtosis\\|l\\(ag\\|bound\\|e\\(ft\\|ngth\\)\\|gamma\\|og\\(\\|10\\|2\\)\\)"
		"\\|m\\(ax\\|dy\\|ean\\|in\\(\\|ute\\)\\|o\\(d\\|nth\\|rt\\)\\)\\|n\\(\\|etpv\\|miss\\|ormal\\|pv\\)"
		"\\|prob\\([ft]\\|b\\(eta\\|nml\\)\\|chi\\|gam\\|hypr\\|it\\|n\\(egb\\|orm\\)\\)"
		"\\|ordinal\\|p\\(oisson\\|ut\\)\\|qtr\\|r\\(e\\(peat\\|verse\\)\\|ight\\|ound\\)"
		"\\|ran\\(bin\\|cau\\|exp\\|g\\(am\\|e\\)\\|k\\|nor\\|poi\\|t\\(bl\\|ri\\)\\|uni\\)"
		"\\|s\\(aving\\|can\\|econd\\|i\\(gn\\|nh?\\)\\|qrt\\|t\\(d\\(\\|err\\)\\|fips\\|namel?\\)\\|u\\(bstr\\|m\\)\\|ymget\\)"
		"\\|t\\(anh?\\|i\\(me\\(\\|part\\)\\|nv\\)\\|oday\\|r\\(anslate\\|i\\(gamma\\|m\\)\\|unc\\)\\)"
		"\\|u\\(niform\\|pcase\\|ss\\)\\|v\\(ar\\|erify\\)"
		"\\|weekday\\|y\\(ear\\|yq\\)\\|zip\\(fips\\|namel?\\|state\\)"

;;;    ;; SAS functions introduced in Technical Report P-222

		"\\|airy\\|b\\(and\\|lshift\\|not\\|or\\|rshift\\|xor\\)"
		"\\|c\\(nonct\\|ompbl\\)\\|d\\(airy\\|equote\\)\\|fnonct\\|tnonct"
		"\\|i\\(bessel\\|n\\(dexw\\|put[cn]\\)\\)\\|jbessel\\|put[cn]"
		"\\|lowcase\\|quote\\|resolve\\|s\\(oundex\\|ysprod\\)\\|tr\\(anwrd\\|imn\\)"
		
;;;    ;; IML functions that are not also Datastep functions
		"\\|a\\(ll\\|ny\\|pply\\|rmasim\\)\\|b\\(lock\\|ranks\\|tran\\)"
		"\\|c\\(har\\|hoose\\|on\\(cat\\|tents\\|vexit\\|vmod\\)\\|ovlag\\|shape\\|usum\\|vexhull\\)"
		"\\|d\\(atasets\\|esignf?\\|et\\|iag\\|o\\|uration\\)"
		"\\|e\\(chelon\\|igv\\(al\\|ec\\)\\)\\|f\\(ft\\|orward\\)\\|ginv"
		"\\|h\\(alf\\|ankel\\|dir\\|ermite\\|omogen\\)"
		"\\|i\\(\\|fft\\|nsert\\|nv\\(updt\\)?\\)\\|j\\(\\|root\\)\\|loc\\|mad"
		"\\|n\\(ame\\|col\\|leng\\|row\\|um\\)\\|o\\(pscal\\|rpol\\)"
		"\\|p\\(olyroot\\|roduct\\|v\\)\\|r\\(anktie\\|ates\\|atio\\|emove\\|eturn\\|oot\\|owcatc?\\)"
		"\\|s\\(etdif\\|hape\\|olve\\|plinev\\|pot\\|qrsym\\|ssq\\|torage\\|weep\\|ymsqr\\)"
		"\\|t\\(\\|eigv\\(al\\|ec\\)\\|oeplitz\\|race\\|risolv\\|ype\\)"
		"\\|uni\\(on\\|que\\)\\|v\\(alue\\|ecdiag\\)\\|x\\(mult\\|sect\\)\\|yield"
		
;;;    ;; SCL functions that are known to work with SAS macro function %sysfunc

		"\\|attr[cn]\\|c\\(exist\\|lose\\)\\|d\\(close\\|num\\|open\\|read\\)"
		"\\|exist\\|f\\(close\\|etchobs\\|i\\(leexist\\|nfo\\)\\|open\\|put\\|write\\)"
		"\\|get\\(option\\|var[cn]\\)\\|lib\\(name\\|ref\\)\\|op\\(en\\|t\\(getn\\|setn\\)\\)"
		"\\|pathname\\|sysmsg\\|var\\(fmt\\|l\\(abel\\|en\\)\\|n\\(ame\\|um\\)\\|type\\)\\)"
		"[ \t]*(")			    font-lock-function-name-face)
	 )))
	 

  ;;
  ;; Build new buffer.
  ;;
  (sasmod-menu-setup)
  (if (and sasmod-build-new-buffer (zerop (buffer-size)))
      (sasmod-insert-new-buffer-strings))
  ;;
  ;; Update Header information.
  ;;
  (make-local-hook 'write-contents-hooks)
  (add-hook 'write-contents-hooks 'sasmod-update-file-header nil t)

  (setq major-mode 'sasmod-mode)
  (setq mode-name "SASmlf")
  (run-hooks 'sasmod-mode-hook)
)

(defun sasmod-compile ()
  "* Complies the current buffer."
  (interactive)
  ;;
  ;; First try to determine from the buffer.
  ;;
  (let  (
	 (vertxt "Written for use with SAS version %s")
	 (len (length sasmod-sas-versions))
	 (i 0)
	 (cmd nil)
	 )
    (while (and (< i len) (not cmd))
      (save-excursion
	(goto-char (point-min))
	(if (search-forward (format vertxt (nth 1 (nth i sasmod-sas-versions))) nil t)
	    (setq cmd (nth 2 (nth i sasmod-sas-versions))))
	)
      )
    (if (not cmd)
	(error "The SAS version is unknown by SASmod, not compiling.")
      (shell-command (concat cmd " &"))
      )
    )
  )


(defun sasmod-log-file()
  "Open the current SAS file's log."
  ;;
  ;; Get Log File Name.
  ;;
  (interactive)
  (setq fn (buffer-file-name))
  (string-match "\\.sas" fn)
  (setq fn (replace-match ".log" nil nil fn))
  (if sasw
      (switch-to-buffer-other-window (find-file-noselect fn))
    (switch-to-buffer (find-file-noselect fn))
    )
  (message fn)
  )

(defun sasmod-lst-file()
  "Open the current SAS file's lst."
  ;;
  ;; Get Log File Name.
  ;;
  (interactive)
  (setq fn (buffer-file-name))
  (string-match "\\.sas" fn)
  (setq fn (replace-match ".lst" nil nil fn))
  (if sasw
      (switch-to-buffer-other-window (find-file-noselect fn))
    (switch-to-buffer (find-file-noselect fn))
    )
;;  (display-buffer (find-file-noselect fn))
  (message fn)
)

(defun sasmod-chop-dir (dir)
  "Go ../ on a directory"
  (if (string-match "/[^/]*$" dir)
      (replace-match "" nil nil dir)
    )
)

(defun sasmod-rebox-full()
  "Rebox the whole comment with the full comment length."
  (interactive)
  (setq rebox-set-box-size 't)
  (rebox-region 223)
)

(defun sasmod-uncomment()
  "Uncomment the box."
  (interactive)
  (if rebox-no-wrap
      (progn 
	(setq rebox-uncomment 't)
	(rebox-comment 223)
	(setq rebox-uncomment  nil)
	)
    (setq rebox-no-wrap 't)
    (setq rebox-uncomment 't)
    (rebox-comment 223)
    (setq rebox-uncomment  nil)
    (setq rebox-no-wrap nil)
    )
  )

(defun sasmod-comment-region-full()
  "Comment the region in a full box (no wrapping)"
  (interactive)
  (if rebox-no-wrap
      (progn 
	(setq rebox-set-box-size 't)
	(rebox-region 223)
	)
    (setq rebox-no-wrap 't)
    (setq rebox-set-box-size 't)
    (rebox-comment 223)
    (setq rebox-no-wrap nil)
    )
  )

(defun sasmod-rebox-part ()
 "Rebox the whole comment with the full comment length."
 (interactive)
 (setq rebox-set-box-size nil)
 (if (not (rebox-comment 223))
     (sasmod-space-line))
 )

(defun sasmod-comment-region-part()
  "Comment the region in a box based on the text size (no wrapping)"
  (interactive)
  (if rebox-no-wrap
      (progn
	(setq rebox-set-box-size nil)
	(rebox-region 223)
	)
    (setq rebox-no-wrap 't)
    (setq rebox-set-box-size nil)
    (if (not (rebox-region 223))
	(sasmod-space-line)
      )
    (setq rebox-no-wrap nil)
    )
  )


(add-to-list 'auto-mode-alist '(".sas\\'" . sasmod-mode))
(provide 'sasmod-mode)
