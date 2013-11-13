;;
;; Keyboard macros for grabbing information from SAS website.
;;

;;
;; Insert one option from clipboard.  Position at the end of the line.
;;
;; Example:
;;
;; nobyplot
;;   produduces a table...
;;
(setq last-kbd-macro (read-kbd-macro
"RET C-y C-a C-p (\" M-l \") <backspace> C-k M-SPC \" M-c C-e .\") TAB"))


;;
;; Insert two options from the clipboard.
;;
;; Example:
;;
;; MODES|MODE
;;    requests a table of all possible modes

(setq last-kbd-macro (read-kbd-macro
"RET C-y C-a C-p (\" M-l SPC a M-l M-b C-w RET (\" C-p C-e <backspace> \" C-n \" <backspace> C-e \" SPC \" C-k M-SPC <backspace> M-c M-b C-k C-y \") C-p C-e SPC \" C-y \") TAB C-n TAB"))

;;
;; Insert two options from the clipboard.
;;
;; Example:
;;
;; NORMAL
;; NORMALTEST
;;     requests tests for normality that include a series of goodness-of-fit tests based on the empirical distribution function
(setq last-kbd-macro (read-kbd-macro
"RET C-y C-a 2*<C-p> (\" M-l \" C-n C-a (\" M-l \" C-n C-a C-p C-e SPC \" C-k M-SPC M-c M-b <backspace> C-k C-y \") C-p SPC \" C-y \") TAB C-n TAB C-e"))

;;
;; Insert one option= from clipboard.  Position at end of line.
;;
;; Example:
;;
;; DATA=SAS-data-set
;;    specifies the input SAS data set to be analyzed
(setq last-kbd-macro (read-kbd-macro
"RET C-y C-a C-p (\" M-l C-f \" SPC \"( C-e \") 2*<backspace> ) C-k M-SPC M-c C-e \") TAB"))

;;
;; Insert two option= from clipboard.  Position at end of the line.
;;
;; Example
;; annotate=SAS-data-set
;; anno=SAS-data-set
;;   Specifies an ...
;;
(setq last-kbd-macro (read-kbd-macro
"RET C-y 2*<C-p> C-a (\" M-l C-f \" SPC \"( C-e ) C-SPC SPC C-n C-a (\" M-l C-f \" SPC \"( C-e () 2*<backspace> ) SPC C-k M-SPC M-c C-b M-b C-k C-y \") C-p C-y \") TAB C-n TAB"))

;;
;; Define a two-parameter functional option
;; 
;; Example
;;
;; CIPCTLDF <(<TYPE=keyword> <ALPHA=\alpha\gt)>
;; CIQUANTDF <(<TYPE=keyword> <ALPHA=\alpha\gt)>
;;    requests confidence limits for quantiles based on a method that is distribution-free
;;
(setq last-kbd-macro (read-kbd-macro
"RET C-y C-a 2*<C-p> (\" M-l (a M-l M-b C-w 2*<M-f> C-l M-l M-b C-w SPC 2*<M-f> M-b C-a 3*<M-f> C-f C-k )\" SPC \" C-n C-a (\" M-l (a C-f C-k C-p C-e C-y C-n 3*<backspace> C-p C-a M-f C-k C-y C-n C-y C-k M-SPC M-c M-b C-k C-y \") C-p SPC C-y \") TAB C-n TAB"))

;; 
;; Define a two parameter option function
;;
;; Example:
;;
;; TRIMMED=values <(<TYPE=keyword> <ALPHA=\alpha\gt)>
;; TRIM=values <(<TYPE=keyword> <ALPHA=\alpha\gt)>
;;    requests a table of trimmed means, where value specifies the number or the proportion of observations that PROC UNIVARIATE trims

(setq last-kbd-macro (read-kbd-macro
"RET C-y C-a 2*<C-p> (\" M-l C-f SPC ( C-k C-y C-a M-f 3*<C-f> M-f M-l M-b C-w 2*<M-f> M-l M-b C-w SPC M-f C-f C-k )\" SPC \" C-y 3*<M-y> C-a 3*<M-f> 3*<C-f> 3*<M-b> C-f M-f C-f C-k C-y C-n C-a (\" M-l C-f C-y 2*<C-k> M-SPC M-c M-b C-k C-y \") C-p SPC C-y \") TAB C-n TAB C-e"))

;;
;; Insert one statement;
;;
;; Example
;;
;; Transpose each BY group  	BY
;;
(setq last-kbd-macro (read-kbd-macro
"RET C-y M-b C-k M-SPC <backspace> C-a (\" C-y SPC M-b M-l \" C-f \" C-e \") TAB"))
;;
;; Also stranspose one statement, reversed from above:
;;
;; Example:
;;
;; BY	calculates separate frequency or crosstabulation tables for each BY group.
;;

(setq last-kbd-macro
  (read-kbd-macro "RET C-y C-a (\" M-l \" M-SPC \" M-c C-e \") TAB"))

;; Insert one statement;
;;
;; Example
;;
;; Create a column defintion  	DEFINE COLUMN
;;
(set last-kbd-macro (read-kbd-macro
"RET C-y 2*<M-b> C-k M-SPC <backspace> C-a C-y SPC C-a (\" 2*<M-l> \" C-f \": <backspace> M-SPC <backspace> C-e \") TAB"))

;;
;;
;; STATEMENT WITH BLANK LINE BETWEEN IT...
;;

;;
;; Insert one option from the clipboard.
;;
;; Example:
;;
;; LET
;;
;;    allows duplicate values of an ID variable
(setq last-kbd-macro (read-kbd-macro
"RET C-y C-a 2*<C-p> (\" M-l \" 2*<C-k> M-SPC \" M-c C-e .\") TAB"))
;;
;; Insert two options from clipboard.
;;
;; Example:
;;
;;
;; THREADS | NOTHREADS
;; 
;;     enables or disables parallel processing of the input data set
(setq last-kbd-macro (read-kbd-macro
"RET C-y 2*<C-p> C-a (\" M-l SPC <backspace> \" RET a M-l M-b C-w (:\" 2*<backspace> \" C-e \" 2*<C-k> M-SPC \" M-c M-b C-k C-y \") C-p SPC \" C-y \") TAB C-n TAB"))

;;
;; Insert two options from clipboard.
;;
;; Example:
;;
;; DANISH
;; NORWEGIAN
;;
;;    sorts characters according to the Danish and Norwegian national standard
(setq last-kbd-macro (read-kbd-macro
"RET C-y C-a 3*<C-p> (\" M-l \" C-n C-a (\" M-l \" 2*<C-k> M-SPC \" M-c M-b C-b C-k C-p SPC C-k RET C-p C-e C-y M-y \") TAB C-n C-y \") TAB"))


;;
;; Insert one option= from the clipboard.
;; 
;; Example
;; 
;; DATA= input-data-set
;;
;;    names the SAS data set to transpose
(setq last-kbd-macro (read-kbd-macro
"RET C-y C-a 2*<C-p> (\" M-l C-f \" M-SPC \"( C-e ) 2*<C-k> M-SPC M-c C-e .\") TAB"))

