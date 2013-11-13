;;
;; These are the auto-completion templates.
;;
(defgroup sasmod-cookies nil
  "Completion Cookies fo SASmod"
  :group 'sasmod-cookies
  )

  
(defvar sasmod-cookies 
  '(
    ("proc " ("proc "))
    ("data " ("data "))
;;
;; SAS language specific items
;;
;;    ("libname library" ("libname library \"" (p "Library Location: ")  "\";" > n "proc format lib=library;" > n "value " (s) > n "run;" > n))
    ("libname" ("libname "))
;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; SAS Supplied macros
;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Cognigen Specific Macros
;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;
;; Nonmem macros.
;;
    ("%cntit("  (& "%cntit("
				  (p "Variable to sort by (typically ID,SUBJECT,or PATNO): ") ","
				  (p "Variable frequency table is based on (typically SAMPLE): ")
				  ", dsn=" 
			       (p "Data Source Name (dsn): " dsn) 
			       ", titl=COUNT FOR DATASET " (s dsn) ");\n"
			       "/*------------------------.\n"
			       "| Count For Dataset " (s dsn) "|\n"
			       "|                         |\n"
			       "| OBS:    <->    PTS:     |\n"
			       "`------------------------*/\n") )
    ("%nmflat(lib=" (& "%nmflat(lib="
				       (p "Library name: ") ",dsn="
				       (p "Dataset name: ") ",fname="
				       (p "Output file name: ") ");" n))
;;
;; Cognigen data maros
;;
    ("%cleantmp(not=" (& "%cleantmp(not=" (p "What temporary variable do you wish to keep? ") ");"  n))
    ("%datasum(whatlib=" (& "%datasum(whatlib="
					   (p "What library should be summarized? ")
					   ","  n "mode="
					   (p "Creation or Summary (C/S): ")
					   ");" > n ))
    ("%doccont(inref=" (& "%doccont(inref="
					 (p "Fileref of Original proc contents: ")
					 ","  n "outref="
					 (p "Fileref of New proc contents: ")
					 ");" > n ))
    ("%dslegder" (& "%dsleger;\n"))
    ("%fmtdate(fmt=" (& "%fmtdate(fmt=" 
				       (p "Date format (stored in &fdate): ") 
				       ");"  n ))
    ("%flatfile(lib=" (& "%flatfile(lib="
					 (p "Library Name: ")
					 ","  n "dsn="
					 (p "Dataset Name: ")
					 "," > n "fname="
					 (p "File Name: ")
					 ");" > n ))
    ("%htmltab(data=" (& "%htmltab(data="
					(p "Name of input dataset: ") "," n
					"where="
					(p "Where clause, use where %str(val=val): ") "," > n
					"by="
					(p "Separate tables for each `by' value: ") "," > n
					"out="
					(p "Output fileref (FILE, PRINT or STDOUT): ") "," > n
					"outfile="
					(p "Name of output HTM[L] file: ") "," > n
					"tmpfile="
					(p "Name of temp file: ") "," > n
					"tabid="
					(p "table NAME= attribute: ") "," > n
					"id="
					(p "ID variable, or _NULL_: ") "," > n
					"vars="
					(p "List of variables to be printed: ") "," > n
					"caption="
					(p "Table caption text: ") "," > n
					"tattrib="
					(p "HTML <table> attributes: ") "," > n
					"colspec=," > n
					"ls="
					(p "output linesize: ") ","> n
					"htmlver="
					(p "HTML table style: ") ");" > n))
    ("%lfoot(num=" (& "%lfoot("
				   (p "Relative footnote line (1-10): ") ","
		 		   (p "Footnote Text: ") ");" n))
    ("%mixcase(var=" ("%mixcase(var=" 
				       (p "Variable converted to ``Mixed Case'': ") 
				       ",target=" 
				       (p "New variable with Mixed Case: ") 
				       ");" n)) 
    ("%moptions;" (& "%moptions;" n))
    ("%numobs(dsn=" ("%numobs(" (p "Data Source Name: ") ");" n))
    ("sasmod-sas2tran" "%sas2tran(" (& "%sas2tran("
				     (p "Path containing the SAS data set to convert: ") "," n
				     (p "Name of dataset to be converted: ") > n
				     (p "Name and location of converted SAS transport file: ") ");" 
				     > n))
    ("%sasmod-sigdig(" ("%sigdig("
					(p "Variable to round: ") ","
					(p "Number of signiciant digits:") ");" n))
    ("sasmod-tran2sas" "%tran2sas(" (& "%tran2sas("
				     (p "Path and file name of SAS transport: ") ","
				     (p "Path and file name of converted SAS dataset:") ");" n))
    ("%varcomp(newlib=" (& "%varcomp(newlib="
					  (p "Libref of the newest library: ") ",oldlib="
					  (p "Libref of the old library: ") ");" n))
    ("%varlist(whatlib=" (& "%varlist(whatlib="
					   (p "Libref of listed SAS datasets: ")
					   ",wherelib="
					   (p "Libref where ouput dataset mvarlist will be created: ")
					   ");" n))
    ("%varscan(whatlib=" (& "%varscan(whatlib="
					   (p "Libref for searching: ") ",keyword="
					   (p "Keyword (one word): ") "); " n))
    ("%varsum(whatlib=" (& "%varsum(whatlib="
					 (p "Libref for dataset: ") ",dset="
					 (p "Dataset Name: ") "); " n))
    ("%vartype(" ("%vartype(" 
				   (p "Variable to convert: ") ","
				   (p "Type of conversion ($char is character): ") ",format=8);" n))

;;
;; Statistics Macros
;;
;;    ("%allvars(dsname,var);")

    ("logisout(depvar=" (&
					   "%logisout(depvar="
					   (p "Binary Response Variable: ") ","  n
					   "indata="
					   (p "Dataset to model the logistic regression: ") "," > n
					   "sigonly=YES," > n
					   "title1="
					   (p "Title of first summary table: ") "," > n
					   "title2="
					   (p "Title of second summary table: ") ");" > n))
    ("%xovereq(dsn=" (&
				       "%xovereq(dsn="
				       (p "Dataset Name: ") "," n
				       "y="
				       (p "Exposure Variable:") "," > n
				       "ylab="
				       (p "Exposure Variable Label: ") "," > n
				       "tmt="
				       (p "Treatment Variable: ") "," > n
				       "seq="
				       (p "Crossover sequence: ") "," > n
				       "period="
				       (p "Crossover period: ") "," > n
				       "sujbect="
				       (p "Subject ID variable: ") "," > n
				       "takelogy=F," > n
				       "base=exp(1)," > n
				       "addc=0," > n
				       "conflev=90," > n
				       "glmall=F);" > n))
;;
;; Graphics macros:
;; 
    ("%setaxis(vvar=" (& "%setaxis(vvar="
					  (p "Verical (y) axis: ") ",hvar="
					  (p "Horizontal (x) axis: ") ",dsn="
					  (p "Datasource Name: ") ");" %))

;;
;; Commonly used phrases:
;;
    ("%include \"../sastrd/libref.sas\";" (& "%include \"" (sasmod-dd) "/sastrd/libref.sas\";" %)) 
;;
;; Required Templates.
;;
    ("/*-------------------------------------------------------------------------------" (& "/*---------------------------------------------------------------------------.\n" 
      "| " (s) "                                                                           |\n"
      "`---------------------------------------------------------------------------*/\n"))
    ("mut" (& "\"'B5'x\""))
    ("mug" (& "\"'E4'x\""))
    ("mu" (& "\"'E4'x\""))
    )
)
;
; Lightning Completion Tags.
;

(require 'sasmod-cookies-base)
(require 'sasmod-cookies-data)
(require 'sasmod-cookies-graph)

(defvar sasmod-formats
  '(
    ;; Character
    ("$hex" 1 "Hexadecimal character conversion.  w=twice char length (1-32767;4)")
    ("$" 1 "Character Data; doesn't trim leading blanks. (1-32767)")
    ;; Date, Time & Datetime
    ("date" 1 "Date in ddmmmyy ddmmmyyyy (5-9;7)")
    ("datetime" 2 "Date/Time in ddmmmyy:hh:mm:ss.ss (7-40;16)")
    ("day" 1 "Writes the day of the month from SAS value (2-32;2)")
    ("eurdfdd" 1 "Writes sas date value in form dd.mm.yy (2-10;8)")
    ("julian" 1 "Writes a julian date in yyddd or yyyyddd (2-10;5)")
    ("mmddyy" 1 "Writes SAS date values in form mmddyy or mmddyyyy (2-10;8)")
    ("time" 2 "Writes SAS time values in form hh:mm:ss.ss (2-20;8)")
    ("weekdate" 1 "Writes SAS date values in form day-of-week, month-name dd, yy or yyyy (3-37;29")
    ("worddate" 1 "Writes date in form month-name dd, yyyy (3-32; 18)")
    ;; Numeric
    ("best" 1 "Best format for writing (1-32;12)")
    ("comma" 2 "Writes numbers with commas separating every three digits (2-32;6)")
    ("dollar" 2 "Writes a leading $ and commas separating every three digits (2-32;6)")
    ("e" 1 "Writes numbers in scientific notation (7-32;12)")
    ("pd" 2  "Writes numbers in packed decimal -w is # of bytes. (1-16;1)")
    ("" 2 "Standard numeric data (1-32)")
    )
  "Defines the standard formats.  The number represents the type of format.  Then there is a description.
1 = fmtW.
2 = fmtW.D
"
  )

(defvar sasmod-create-variable-statements
  '()
  "Defines what statemtns output to a new variable (and defaults if omitted)"
  )

(setq sasmod-create-variable-statements (append
					 sasmod-create-variable-statements
					 sas-base-create-variable-statements))

(defvar sasmod-completions
  '(
    ("color" (
	      ("white")
	      ("black")
	      ("gray22")
	      ("gray33")
	      ("gray44")
	      ("gray66")
	      ("gray88")
	      ("grayaa")
	      ("graycc")
	      ("red")
	      ("green")
	      ("blue")
	      ("cyan")
	      ("magenta")
	      ("gray")
	      ("pink")
	      ("orange")
	      ("brown")
	      ("yellow")
	      ))
    )
  "Completions for a specific type of data."
  )


(defvar sasmod-sticky-statements
  '(
    ()
    )
  "Statments that stick (or repeat when not empty) when pressing return."
)
(setq sasmod-sticky-statements 
  (append sasmod-sticky-statements
				       sas-base-sticky-statements)
  )

(defvar sasmod-help
  '( 
    ()
    )
  "Help for what each statment in a procedure means."
)
(setq sasmod-help (append sasmod-help
			  sas-data-help
			  sas-graph-help
			  sas-base-help
			  ))

(defvar sasmod-alternate-statements
  '(
    )
  "Defines alternate regular expressions for a specific procedure's statment."
)

(setq sasmod-alternate-statements (append sasmod-alternate-statements 
					  sas-base-alternate-statements))

(defvar sasmod-state-multiple
  '(
    )
  "Defines multiple word keyword beginnings for specific procedures."
)
(setq sasmod-state-multiple
      (append sasmod-state-multiple
	      sas-base-multiple))

(defvar sasmod-mode-light-procs
  '(
    )
  )
(setq sasmod-mode-light-procs (append sasmod-mode-light-procs 
				      sas-base-procs
				      sas-graph-procs
				      ))
(defvar sasmod-proc-options
  '(
    )
  )

(setq sasmod-proc-options (append sasmod-proc-options 
				  sas-data-options
				  sas-graph-options
				  sas-base-options))

(defvar sasmod-proc-state-options
  '(
    )
  )
(setq sasmod-proc-state-options (append sasmod-proc-state-options sas-base-state-options))

(setq sasmod-procs (sasmod-append sasmod-help sasmod-proc-options t))

(provide 'sasmod-cookies)