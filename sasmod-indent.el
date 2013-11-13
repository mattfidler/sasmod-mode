;; Lifed from ESS
(defun sasmod-bo-sas ()
  "Move point to beginning of current sas statement. (kind of)"
  (interactive)
  (let ((pos (point))
	(cont 't)
	)
    (if (search-forward ";" nil 1) 
	(forward-char -1)
      )
    (re-search-backward ";" nil t)
    (while (sasmod-is-between "/\\*" "\\*/")
      (re-search-backward ";" nil t)
      )
    (skip-chars-forward "\t\n\f; ")
    (while (and cont (looking-at "/\\*"))
      (if (not (re-search-forward "\\*/" nil t))
	  (setq cont nil)
	(skip-chars-forward "\t\n\f ")
	)
      )
    (if (> pos  (point)) nil
      (goto-char pos)
      (if (not (re-search-backward "[;\n]" nil t)) nil
	  (forward-char 1)
	  (skip-chars-forward "\t ;")
	  )
      )
    )
  )
;; SASmod indentation function
(defun sasmod-detab (arg)
  "Removes the tabs and places spaces in the string passed to the function."
  (let (
	(tmp arg)
	)
    (while (string-match "\t" tmp)
      (setq tmp (replace-match (make-string default-tab-width ? ) nil nil tmp)))
    (symbol-value 'tmp)
    )
  )
(defun sasmod-indent ()
  "Indentation function for SASmod"
  (interactive)
  (let* (
	(case-fold-search 't)
	(p nil)
	(bol nil)
	(bosas nil)
	(bosasl nil)
	(tmp nil)
	(boi nil) ;; Beginning of indent
	(sasindent '(
		     "proc"
		     "data"
		     "%macro"
		     ))
	(sasdeindent '(
		       "run"
		       "end"
		       "quit"
		       "%mend"
		       )
		     )
	(sasstop (regexp-opt (append sasindent
				     sasdeindent
			       )))
	(sasi (regexp-opt sasindent))
	(sasd (regexp-opt sasdeindent))
	(indent-length-a 0)
	(indent-length-b 0)
	(in-statement nil)
	(last-end nil)
	(di nil)
	(empty nil)
	(cont 't)
	(cur "")
	)
    (save-excursion
      (end-of-line)
      (skip-chars-backward " \t;")
      (setq p (point))
      (beginning-of-line)
      (if (not (looking-at (format "^[ \t]*\\<\\(%s\\)\\>" sasd))) nil
	(if (string= (match-string 1) "end")
	    (setq last-end 't)
	    )
	(setq di 't)
	)
      (setq bol (point))
      (goto-char p)
      (sasmod-bo-sas)
      (setq bosas (point))
      (beginning-of-line)
      (setq bosasl (point))
      (if (not (looking-at "^\\([ \t]*\\)\\(\\(?:proc[ \t]+\\)?%?[a-z]+\\)")) nil
	(setq tmp (match-string 0))
	(if (match-string 1)
	    (setq indent-length-a (length (sasmod-detab (match-string 1))))
	  (setq indent-length-a 0)
	  )
	(setq indent-length-b (+ 1 (length (sasmod-detab tmp))))
	(if (or (string= (match-string 2) "else") (string= (match-string 2) "if"))
	    (setq indent-length-b (+ sasmod-tab-if-else-width indent-length-a))
	  )
	)
      (setq in-statement (string-match "[^ \t\n\f]" (buffer-substring bosas p)))
      (setq indent-length-a nil)
      ; Now look for last stop word.
      ; Make sure the stop word is not in a comment/string.
;      (setq cont 't)
;      (if (not 
;	   (re-search-backward (format "\\(?:\\(?:;\\|\\*/\\)[\t\n\f ]*\\<\\(?:%s\\)\\>\\|\\<do\\>\\)" sasstop) nil t)
;	   ) nil
;	(setq tmp (match-string 0))
;	(while (and 
;		(string-match "\\<do\\>" tmp) (and
;		(memq (get-text-property (point) 'face) '(font-lock-comment-face font-lock-string-face))
;		(re-search-backward (format "\\(?:\\(?:;\\|\\*/\\)[\t\n\f ]*\\<\\(?:%s\\)\\>\\|\\<do\\>\\)" sasstop) nil t)
;		  ))
;	  (setq tmp (match-string 0))
;	  (setq cont 't)
;	  )
;	(setq cont nil)
;	)
      (if (not (re-search-backward (format "\\(?:\\(?:;\\|\\*/\\)[\t\n\f ]*\\<\\(?:%s\\)\\>\\|\\<do\\>\\)" sasstop) nil t)) nil 
	(setq tmp (match-string 0))
	(while (and 
		(string= "do" tmp)
		(memq (get-text-property (point) 'face) '(font-lock-comment-face font-lock-string-face))
		  )
	  (if (re-search-backward (format "\\(?:\\(?:;\\|\\*/\\)[\t\n\f ]*\\<\\(?:%s\\)\\>\\|\\<do\\>\\)" sasstop) nil t)
	      (setq tmp (match-string 0))
	    (setq tmp "")
	    )
	  )
	;; Ok found stop word.
	(if (looking-at "\\*/")
	    (forward-char 2))
	(if (string= tmp "do")
	    (progn
	      (sasmod-bo-sas)
	      (beginning-of-line)
	      (if (not (looking-at "^[ \t]*")) nil
		  (setq indent-length-a (+ (length (sasmod-detab (match-string 0))) sasmod-tab-width))
		  )
	      )
	  (skip-chars-forward "\t\n\f ;")
	  (if (not (looking-at (format "\\<\\(?:%s\\)\\>" sasi))) 
	      (progn
		(beginning-of-line)
		(if (looking-at "^\\([ \t]*\\)") 
		    (setq indent-length-a (length (sasmod-detab (match-string 0))))
		  )
		(if (and sasmod-indent-end-to-match-do (looking-at "^[ \t]*\\<end\\>"))
		  (setq indent-length-a (- indent-length-a sasmod-tab-if-else-width))
		  )
		;; Now fix data and proc do deindent if not already deindented on the last line.
		(save-excursion
		  (goto-char p)
		  (sasmod-bo-sas)
		  (if (looking-at "\\(data\\|proc\\)")
		      (progn
			(skip-chars-backward "\t\n\f; ")
			(sasmod-bo-sas)
			(if (looking-at "\\<\\(run\\|quit\\)\\>") nil
			  (setq indent-length-a (- indent-length-a sasmod-tab-width)))
			)
		    )
		  )
		)
	    (beginning-of-line)
	    (setq boi (point))
	    (if (= boi bol) nil
	      ;; Ok, add a tab if not looking at a stop word.
	      (if (not (looking-at "^\\([ \t]*\\)")) nil
		(setq indent-length-a (+ (length (sasmod-detab (match-string 1))) sasmod-tab-width))
		(if (looking-at (format "^[ \t]*\\<\\(?:%s\\)\\>" sasd))
		    (progn
		      (setq indent-length-a (- indent-length-a sasmod-tab-width))
		      )
		  )
		)
	      )
	    )
	  )
	)
      )
    (if (and di indent-length-a)
	(setq indent-length-a (- indent-length-a sasmod-tab-width)))
    (if (and sasmod-indent-end-to-match-do (and di last-end))
	(setq indent-length-a (+ indent-length-a sasmod-tab-if-else-width)))
;    (message "Indent: %s" indent-length-a)
    ;; First rule, if not ending a SAS statment do a hanging indent.
    (if (or (not in-statement) (= bosasl bol)) 
	(progn
	  (if indent-length-a
	      (sasmod-indent-line-to indent-length-a)
	    )
	  )
      (sasmod-indent-line-to indent-length-b)
      )
    )
  )
(defun sasmod-indent-line-to (arg)
  "Indents a line to the length using spaces only (sometimes tabs cause problems..."
  (save-excursion
    (beginning-of-line)
    (if (looking-at "^[ \t]*")
	(replace-match ""))
    (if (> arg 0)
	(insert (make-string arg ? ))
      )
    )
  (skip-chars-forward " ")
  )
(defalias 'si 'sasmod-indent)
(provide 'sasmod-indent)