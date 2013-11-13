;;
;; Missing procs that I do not intend to implement
;;
;; trantab (SAS translation tables)
;; registry (editing the SAS registry)
;; pwencode (pasword encoding)
;; prtexp (printer device capabilities)
;; prtdef (printer device defintion)
;; proto (register custom C++ programs)
;; pmenu (Creates custom menus for SAS programs)
;; optsave (saves registry settings)
;; optload (loads registry settings)
;; metaoperate (?)
;; metalib (?)
;; metadata (?)
;; infomaps (?)
;; fslist (interactively browse files)
;; forms (?)
;; fcmp (?)
;; explode (?)
;; display (Execute SAS/AF Application)
;; dbcstab (?)
;; cv2view (converts SAS/ACCESS view descriptors to SQL)
;; calendar (creates a text calendar based on calendar data)
;;
;; missing Procs that I may implement
;;
;; template
;; datasets
;;
;; Incomplete Procs
;;
;; sql (only what I think is useful is included).
;; report (only what I think is useful is included).
;; format (need to allow = based processing in the sasmod-mode and figure out what 
;;         to do for this to work.)
;;
;;
;; proc document options that may deleted when they should not are:
;; del ;
;; doc ;
;; Also numbered statements are not quite supported yet. e.g.:
;; obanote1
;; obbnote1
;; obstitle1
;; obtitle1

;;
;; This alist gives variable values if option not present in certain procedures.
;; It also list which options specify an output variable.
;;
(defvar sas-base-create-variable-statements
  '(
    ("transpose" (
		  ("label=" "_LABEL_")
		  ("name=" "_NAME_")
		  ("prefix=" "COL")
		  ))
    )
  "Defines what statments output to a new variable."
  )

(defvar sas-base-alternate-statements
  '(
    ("sql" (
	    (";" "^") ;; End of statement
	    ("state" "^[ \t]*\\([a-z][_a-z0-9]*\\)")
	    ("delete" "^[ \t]*\\(?:where\\|\\(?:group\\|order\\) by\\)[ \t]*$")
	    ))
    ("import" (
	       ("state" "^[ \t]*\\(run\\| +\\)") ;; Phantom statment. Requires one space before ; & on seperate line.
	       ("delete" "^[ \t]+;[ \t]*$")
	       ))
    ("export" (
	       ("state" "^[ \t]*\\(run\\| +\\)") ;; Phantom statment. Requires one space before ; & on seperate line.
	       ("delete" "^[ \t]+;[ \t]*$")
	       ))
    
    )
  "Alternate regular expression for navigating and deleting lines."
)

(defvar sas-base-multiple
  '(
    ("sql" (
	    ("create" 1)
	    ("group" 1)
	    ("order" 1)
	    ("as" 1)
	    ))
    ("document" (
		 ("doc" 1) ;; For Doc-close statement.
		 ))
    )
  "Defines statments with multiple keywords required.  The number of extra keywords is also defined."
  )

;;
;; This can also be a numbered sticky statement.
;;
;; 0=No sticky
;; n=max number of sticky statments to go through.

(defvar sas-base-sticky-statements
  '( 
    ("freq" (
	     ("tables" 0)
	     ))
    ("tabulate" ( 
		 ("table" 0)
		 ))
    ("plot" (
	     ("plot" 0)
	     ))
    ("import" (
	       (" " 0);; Phantom sticky.
	       ))
    ("export" (
	       (" " 0);; Phantom sticky.
	       ))
    )
  "Sticky statments;  that is if non-empty, repeat the line."
  )
(defvar sas-base-help
  '(
    ("catalog" (
		("copy" "Copy or move all entries")
		("delete" "Delete specified entries")
		("save" "Delete all except the entries specified")
		("change" "Change the names of catalog entries")
		("exchange" "Switch the names of two catalog entries")
		("modify" "Change the description of a catalog entry")
		("contents" "Print the contents of a catalog")
		))
    ("chart" (
	      ("block" "Produce a block chart")
	      ("by" "Produce a separate chart for each BY group")
	      ("hbar" "Produce a horizontal bar chart")
	      ("pie" "Produce a pie chart")
	      ("star" "Produce a star chart")
	      ("vbar" "Produce a vertical bar chart")
	      ))
    ("cimport" (
		("exclude" "Exclude the specified file or catalog entry from the transport file to be read")
		("select" "Include the specified file or catalog entry in the transport file to be read")
		))
    ("compare" (
		("by" "Produce a separate comparison for each BY group")
		("id" "Identify variables to use to match observations")
		("var" "Restrict the comparison to values of specific variables")
		("with" "Compare variables of different names")
		("var" "Compare variables of different names")
		))
    ("copy" (
	     ("exclude" "Exclude files or memtypes")
	     ("select" "Select files or memtypes.")
	     ))
    ("corr" (
	     ("by" "The BY statement specifies groups in which separate correlation analyses are performed.")
	     ("freq" "The FREQ statement specifies the variable that represents the frequency of occurrence for other values in the observation.")
	     ("partial" "The PARTIAL statement identifies controlling variables to compute Pearson, Spearman, or Kendall partial-correlation coefficients")
	     ("var" "The VAR statement lists the numeric variables to be analyzed and their order in the correlation matrix. If you omit the VAR statement, all numeric variables not listed in other statements are used")
	     ("weight" "The WEIGHT statement identifies the variable whose values weight each observation to compute Pearson product-moment correlation")
	     ("with" "The WITH statement lists the numeric variables with which correlations are to be computed")
	     ))
    ("cport" (
	      ("exclude" "Exclude the specified file or catalog entry from the transport file to be created.")
	      ("select" "nclude the specified file or catalog entry in the transport file to be created.")
	      ("trantab" "Apply the specified translation table to the file or catalog entry in the transport file to be created.")
	      ))
    ("document" (
		 ("copy" "Insert a copy of an entry into a specified path.")
		 ("delete" "Delete entries from a specified path or paths.")
		 ("dir" "Set or display the current directory.")
		 ("doc" "Open a document and its contents to browse or edit.")
		 ("doc close" "Close the current document.")
		 ("hide" "Prevent output from being displayed when the document is replayed.")
		 ("import" "Import a data set or graph segment into the current directory.")
		 ("link" "Create a symbolic link from one output object to another output object.")
		 ("list" "List the content of one or more entries.")
		 ("make" "Create one or more new directories.")
		 ("move" "Move entries from one directory to another directory.")
		 ("note" "Create text strings in the current directory.")
		 ("obanote" "Create or modify lines of text after the specified output object.")
		 ("obbnote" "Create or modify lines of text before the specified output object.")
		 ("obfootn" "Create or modify lines of text at the bottom of the page in which the output object is displayed.")
		 ("obpage" "Create or delete a page break for an output object.")
		 ("obstitle" "Create or modify subtitles.")
		 ("obtitle" "Create or modify lines of text at the top of the page where the output object is displayed.")
		 ("rename" "Assign a different name to a directory or output object.")
		 ("replay" "Replay one or more entries to the specified open ODS destination(s).")
		 ("setlabel" "Assign a label to the current entry.")
		 ("unhide" "Enable the output of a hidden entry to be displayed when it is replayed.")
		 ))
    ("import" (
	       (" " "Extra options for the import procedure.")
	       ))
    ("export" (
	       (" " "Extra options for the export procedure.")
	       ))
    ("fontreg" (
		("fontfile" "Identify which font files to process")
		("fontpath" "Search directories to identify valid font files to process")
		("truetype" "Search directories to identify TrueType font files")
		("type1" "Search directories to identify valid Type 1 font files")
		))
    ("format" (
	       ("exclude" "Exclude catalog entries from processing by the FMTLIB and CNTLOUT= options")
	       ("invalue" "Create an informat for reading and converting raw data values")
	       ("picture" "Create a template for printing numbers")
	       ("select" "Select catalog entries from processing by the FMTLIB and CNTLOUT= options")
	       ("value" "Create a format that specifies character strings to use to print variable values")
	       ))
    ("freq" (
	     ("by" "Calculates separate frequency or crosstabulation tables for each BY group.")
	     ("exact" "Requests exact tests for specified statistics.")
	     ("output" "Creates an output data set that contains specified statistics.")
	     ("tables" "Specifies frequency or crosstabulation tables and requests tests and measures of association.")
	     ("test" "Requests asymptotic tests for measures of association and agreement.")
	     ("weight" "Identifies a variable with values that weight each observation.")
	     ))
    ("plot" (
	     ("by" " Produce a separate plot for each BY group")
	     ("plot" "Describe the plots that you want")
	     ))
    ("print" (
	      ("by" "Produce a separate section of the report for each BY group")
	      ("id" "Identify observations by the formatted values of the variables that you list instead of by observation numbers")
	      ("pageby" "Control page ejects that occur before a page is full")
	      ("sumby" "Limit the number of sums that appear in the report")
	      ("sum" "Total values of numeric variables")
	      ("var" "Select variables that appear in the report and determine their order")
	      ))
    ("rank" (
	     ("by" "Calculate a separate set of ranks for each BY group")
	     ("ranks" "Identify a variables that contain the ranks")
	     ("var" "Specify the variables to rank")
	     ))
    ("sort" (
	     ("by" "Sort for each BY group")
	     ))
    ("sql" (
	    ("create table" "Specifies the table/dataset that is created.")
	    ("as select"  "Specifies what columns to select (including summary stats")
	    ("from" "Specifies the table to select from.")
	    ("where" "Specifies the SQL where statement")
	    ("group by" "Specifies what variables to group by.")
	    ("order by" "Specifies what variables to order by.")
	    ))
    ("standard" (
		  ("by" "Calculate separate standardized values for each BY group")
		  ("freq" "Identify a variable whose values represent the frequency of each observation")
		  ("var" "Select the variables to standardize and determine the order in which they appear in the printed output")
		  ("weight" "Identify a variable whose values weight each observation in the statistical calculations")
		  ))
    ("summary" (
		("by" "Calculate separate statistics for each BY group")
		("class" "Identify variables whose values define subgroups for the analysis")
		("freq" "Identify a variable whose values represent the frequency of each observation")
		("id" "Include additional identification variables in the output data set")
		("output" "Create an output data set that contains specified statistics and identification variables")
		("types" "Identify specific combinations of class variables to use to subdivide the data")
		("var" "Identify the analysis variables and their order in the results")
		("ways" "Specify the number of ways to make unique combinations of class variables")
		("weight" "Identify a variable whose values weight each observation in the statistical calculations")
		))
    ("means" (
		("by" "Calculate separate statistics for each BY group")
		("class" "Identify variables whose values define subgroups for the analysis")
		("freq" "Identify a variable whose values represent the frequency of each observation")
		("id" "Include additional identification variables in the output data set")
		("output" "Create an output data set that contains specified statistics and identification variables")
		("types" "Identify specific combinations of class variables to use to subdivide the data")
		("var" "Identify the analysis variables and their order in the results")
		("ways" "Specify the number of ways to make unique combinations of class variables")
		("weight" "Identify a variable whose values weight each observation in the statistical calculations")
		))
    ("tabulate" (
		 ("by" "Create a separate table for each BY group")
		 ("class" "dentify variables in the input data set as class variables")
		 ("classlev" "Specify a style for class variable level value headings")
		 ("freq" "Identify a variable in the input data set whose values represent the frequency of each observation")
		 ("keylabel" "Specify a label for a keyword")
		 ("table" "Describe the table to create")
		 ("var" "Identify variables in the input data set as analysis variables")
		 ("weight" "Identify a variable in the input data set whose values weight each observation in the statistical calculations")
		 ))
    ("timeplot" (
		 ("by" "Produce a separate plot for each BY group")
		 ("class" "Group data according to the values of the class variables")
		 ("id" "Print in the listing the values of the variables that you identify")
		 ("plot" "Specify the plots to produce")
		 ))
    ("transpose" (
		  ("by" "Transpose each BY group")
		  ("copy" "Copy variables directly without transposing them")
		  ("id" "Specify a variable whose values name the transposed variables")
		  ("idlabel" "Create labels for the transposed variables")
		  ("var" "List the variables to transpose")
		  ))
    ("univariate" (
		   ("by" "You can specify a BY statement with PROC UNIVARIATE to obtain separate analyses for each BY group")
		   ("class" "The CLASS statement specifies one or two variables that the procedure uses to group the data into classification levels")
		   ("freq" "The FREQ statement specifies a numeric variable whose value represents the frequency of the observation")
		   ("histogram" "The HISTOGRAM statement creates histograms and optionally superimposes estimated parametric and nonparametric probability density curves.")
		   ("id" "The ID statement specifies one or more variables to include in the table of extreme observations")
		   ("inset" "The INSET statement places a box or table of summary statistics, called an inset, directly in a high-resolution graph created with the HISTOGRAM, PROBPLOT, or QQPLOT statement")
		   ("output" "The OUTPUT statement saves statistics and BY variables in an output data set")
		   ("probplot" "The PROBPLOT statement creates a probability plot")
		   ("qqplot" "The QQPLOT statement creates quantile-quantile plots")
		   ("var" "The VAR statement specifies the analysis variables and their order in the results")
		   ("weight" "The WEIGHT statement specifies numeric weights for analysis variables in the statistical calculations")
		   ))
    )
)
;;
;; The following precodes specify what type of completion to do on the option like data= "(data)" will
;; complete the data step.  
;;
;; No completion is assumed when  there is nothing in the ().
;; Anything that has a list of choices seperated by | is assuemd to complete those choices.
;; If you wish to put an additional completion based on a function enclose it in [].
;;
;; (catalog) 		= Complete Catalog
;; (data) 		= Complete Data
;; (output-data) 	= Complete Output Data
;; (file) 		= Fileref or name completion (include '' & directory inclusion?)
;; (library) 		= Library/libref.
;; (format) 		= Format completion
;; (color) 		= Color completion
;; (font) 		= Font Specification
;; (pattern) 		= Fill pattern
;;
;; Not completed, but may be completed in the future.
;;
;; (ods) 		= ODS document/destination
;; (axis-expression)  	= Axis expression
;; (variable) 		= Variable Name
;; (linetype) 		= Line Type
;;
;; Not completed (with no intention to complete)
;;
;; (#) 				= Specifies a number
;; (%) 				= Specifies a percent.
;; (password) 			= Specifies password.
;; (translation-list) 		= Specifies a translation between the two character sets.
;; (out-graphics-catalog) 	= Specifies a graphics catalog.
;;
(defvar sas-base-options
  '(
    ("append" (
	       ("appendver=v6" "Add observations to the data set one at a time")
	       ("base=" "(output-data) Specify the name of the destination data set")
	       ("data=" "(data) Specify the name of the source data set")
	       ("force" "Forces the append when variables are different")
	       ("getsort" "Copies the strong sort assertion from the DATA= data set to the BASE= data set if certain criteria are met.")
	       ))
    ("catalog" (
		("catalog=" "(catalog) Specifies the SAS catalog to process.")
		("entrytype=" "(etype) Restricts processing of the current PROC CATALOG step to one entry type.")
		("et=" "(etype) Restricts processing of the current PROC CATALOG step to one entry type.")
		("force" "Forces statements to execute on a catalog that is opened by another resource environment.")
		("kill" "Deletes all entries in a SAS catalog.")
		))
    ("chart" (
	      ("data=" "(data) Identifies the input SAS data set.")
	      ("lpi=" "(#) Specifies the proportions of PIE and STAR charts.")
	      ("formchar /**/ =" "('formchar-string') Defines the characters to be used for constructing the outlines and dividers for the cells of contingency tables")
	      ))
    ("cimport" (
		("catalog=" "(catalog) Identifies the catalog to import")
;;		("cat=" "(catalog) Identifies the catalog to import")
;;		("c=" "(catalog) Identifies the catalog to import")
		("data=" "(data) Identifies the data to import")
		("ds=" "(data) Identifies the data to import")
;;		("d=" "(data) Identifies the data to import")
		("library=" "(library) Identifies the library to import")
		("lib="  "(library) Identifies the library to import")
		("l="  "(library) Identifies the library to import")
		("eet=" "((etype(s))) Excludes specified entry types from the import process.")
		("et=" "((etype(s))) Specifies the entry types to import.")
		("extendsn=" "(yes|no) Specifies whether to extend by 1 byte the length of short numerics.")
		("infile=" "(file) Specifies a previously defined fileref or the filename of the transport file to read.")
		("memtype=" "(all|catalog|cat|data|ds) Specifies that only data sets, only catalogs, or both, be moved when a SAS library is imported.")
		("datecopy" "Copies the SAS internal date and time when the SAS file was created and the date and time when it was last modified to the resulting destination file.")
		("force" "Enables access to a locked catalog.")
		("new" "Creates a new catalog to contain the contents of the imported transport file when the destination you specify has the same name as an existing catalog.")
		("noedit" "Imports SAS/AF PROGRAM and SCL entries without edit capability.")
		("nosrc" "Suppresses the importing of source code for SAS/AF entries that contain compiled SCL code.")
		("tape" "Reads the input transport file from a tape.")
		))
    ("compare" (
		("allobs" "Includes in the report of value comparison results the values and, for numeric variables, the differences for all matching observations, even if they are judged equal.")
		("allstats" "Prints a table of summary statistics for all pairs of matching variables.")
		("allvars" "Includes in the report of value comparison results the values and, for numeric variables, the differences for all pairs of matching variables, even if they are judged equal.")
		("briefsummary" "Produces a short comparison summary and suppresses the four default summary reports.")
		("error" "Displays an error message in the SAS log when differences are found.")
		("listall" "Lists all variables and observations that are found in only one data set.")
		("listbase" "Lists all observations and variables that are found in the base data set but not in the comparison data set.")
		("listbaseobs" "Lists all observations that are found in the base data set but not in the comparison data set.")
		("listbasevar" "Lists all variables that are found in the base data set but not in the comparison data set.")
		("listcomp" "Lists all observations and variables that are found in the comparison data set but not in the base data set.")
		("listcompobs" "Lists all observations that are found in the comparison data set but not in the base data set.")
		("listcompvar" "Lists all variables that are found in the comparison data set but not in the base data set.")
		("listequalvar" "Prints a list of variables whose values are judged equal at all observations in addition to the default list of variables whose values are judged unequal.")
		("listobs" "Lists all observations that are found in only one data set.")
		("listvar" "Lists all variables that are found in only one data set.")
		("nodate" "Suppresses the display in the data set summary report of the creation dates and the last modified dates of the base and comparison data set.")
		("nomissbase" "Judges a missing value in the base data set equal to any value.")
		("nomisscomp" "Judges a missing value in the comparison data set equal to any value.")
		("nomissing" "Judges missing values in both the base and comparison data sets equal to any value.")
		("noprint" "Suppresses all printed output.")
		("nosummary" "Suppresses the data set, variable, observation, and values comparison summary reports.")
		("note" "Displays notes in the SAS log that describe the results of the comparison, whether or not differences were foun.")
		("novalues" "Suppresses the report of the value comparison results.")
		("outall" "Writes an observation to the output data set for each observation in the base data set and for each observation in the comparison data set.")
		("outbase" "Writes an observation to the output data set for each observation in the base data set, creating observations in which _TYPE_=BASE.")
		("outcomp" "Writes an observation to the output data set for each observation in the comparison data set, creating observations in which _TYPE_=COMP.")
		("outdif" "Writes an observation to the output data set for each pair of matching observations. The values in the observation include values for the differences between the values in the pair of observations. The value of _TYPE_ in each observation is DIF.")
		("outnoequal" "Suppresses the writing of an observation to the output data set when all values in the observation are judged equal.")
		("outpercent" "Writes an observation to the output data set for each pair of matching observations.")
		("printall" "Invokes the following options: ALLVARS, ALLOBS, ALLSTATS, LISTALL, and WARNING.")
		("stats" "Prints a table of summary statistics for all pairs of matching numeric variables that are judged unequal.")
		("transpose" "Prints the reports of value differences by observation instead of by variable.")
		("warning" "Displays a warning message in the SAS log when differences are found.")
		("base=" "(data) Specifies the data set to use as the base data set.")
		("compare=" "(data) Specifies the data set to use as the comparison data set.")
		("fuzz=" "(number) Alters the values comparison results for numbers less than number.")
		("method=" "(absolute|exact|percent|relative) Specifies the method for judging the equality of numeric values.")
		("outstats=" "(output-data) Writes summary statistics for all pairs of matching variables to the specified SAS-data-set.")
		))
    ("contents" (
		 ("centiles" "Print centiles information for indexed variables")
		 ("data=" "(data) Specify the input data set")
		 ("details" "Include information in the output about the number of observations, number of variables, number of indexes, and data set labels.")
		 ("nodetails" "Exclude information in the output about the number of observations, number of variables, number of indexes, and data set labels.")
		 ("directory" "Print a list of the SAS files in the SAS data library")
		 ("fmtlen" "Print the length of a variable's informat or format")
		 ("memtype=" "(data|view|all) Restrict processing to one or more types of SAS files")
		 ("nods" "Suppress the printing of individual files")
		 ("noprint" "Suppress the printing of the output")
		 ("order=" "(ignorecase|varnum) Print a list of variables in alphabetical order even if they include mixed-case names")
		 ("out=" "(output-data) Specify the name for an output data set")
		 ("out2=" "(output-data) Specify the name of an output data set to contain information about indexes and integrity constraints")
		 ("short" "Print abbreviated output")
		 ("varnum" "Print a list of the variables by their position in the data set. By default, the CONTENTS statement lists the variables alphabetically.")
		 ))
    ("copy" (
	     ("alter=" "(password) Provides the alter password for any alter-protected SAS files that you are moving from one data library to another.")
	     ("constraint=" "(yes|no) Specifies whether to copy all integrity constraints when copying a data set.")
	     ("in=" "(library) Names the SAS library containing SAS files to copy.")
	     ("index=" "(yes|no) Specifies whether to copy all indexes for a data set when copying the data set to another SAS data library.")
	     ("memtype=" "(access|all|catalog|data|fdb|mddb|program|view) Restricts processing to one or more member types.")
	     ("datecopy" "Copies the SAS internal date and time when the SAS file was created and the date and time when it was last modified to the resulting copy of the file.")
	     ("force" "Allows you to use the MOVE option for a SAS data set on which an audit trail exists.")
	     ("move" "Moves SAS files from the input data library (named with the IN= option) to the output data library (named with the OUT= option) and deletes the original files from the input data library.")
	     ("clone" "Specifies whether to copy the following data set attributes")
	     ("noclone" "Specifies whether to copy the following data set attributes")
	     ))
    ("corr" (
	     ("alpha" "Calculates and prints Cronbach's coefficient alpha.")
	     ("cov" "Displays the variance and covariance matrix.")
	     ("csscp" "Displays a table of the corrected sums of squares and crossproducts.")
	     ("exclnpwgt" "Excludes observations with nonpositive weight values from the analysis.")
	     ("hoeffding" "Requests a table of Hoeffding's D statistic.")
	     ("kendall" "Requests a table of Kendall's tau-b coefficients based on the number of concordant and discordant pairs of observations.")
	     ("nocorr" "Suppresses displaying of Pearson correlations.")
	     ("nomiss" "Excludes observations with missing values from the analysis.")
	     ("noprint" "Suppresses all displayed output.")
	     ("noprob" "Suppresses displaying the probabilities associated with each correlation coefficient.")
	     ("nosimple" "Suppresses printing simple descriptive statistics for each variable. However, if you request an output data set, the output data set still contains simple descriptive statistics for the variables.")
	     ("pearson" "Requests a table of Pearson product-moment correlations.")
	     ("rank" "Displays the ordered correlation coefficients for each variable.")
	     ("spearman" "Requests a table of Spearman correlation coefficients based on the ranks of the variables.")
	     ("sscp" "Displays a table the sums of squares and crossproducts.")
	     ("best=" "(#) Prints the n highest correlation coefficients for each variable, n >= 1.")
	     ("data=" "(data) Names the SAS data set to be analyzed by PROC CORR")
	     ("fisher(alpha=/**/ biasadj= rho0= type=)" "requests confidence limits and p-values under a specified null hypothesis, H_0:p = p_0, for correlation coefficients using Fisher's z transformation")
	     ("outh=" "(output-data) Creates an output data set containing Hoeffding's D statistics")
	     ("outk=" "(output-data) Creates an output data set containing Kendall correlation statistics")
	     ("out=" "(output-data) Creates an output data set containing Pearson correlation statistic")
	     ("outp=" "(output-data) Creates an output data set containing Pearson correlation statistic")
	     ("outs=" "(output-data) Creates an output data set containing Spearman correlation coefficients")
	     ("singular=" "(#) Specifies the criterion for determining the singularity of a variable if you use a PARTIAL statement")
	     ("vardef=" "(df|n|wdf|weight|wgt) Specifies the variance divisor in the calculation of variances and covariances")
	     ))
    ("cport" (
	      ("after=" "(date) Exports copies of all data sets or catalog entries that have a modification date later than or equal to the date you specify.")
	      ("constraint=" "(yes|no) Controls the exportation of integrity constraints that have been defined on a data set.")
	      ("eet=" "((etype(s))) Excludes specified entry types from the transport file.")
	      ("et=" "((etype(s))) Includes specified entry types in the transport file.")
	      ("file=" "(file) Specifies a previously defined fileref or the filename of the transport file to write to.")
	      ("generation=" "(yes|no) Specifies whether to export all generations of a SAS data set.")
	      ("index=" "(yes|no) Specifies whether to export indexes with indexed SAS data set.")
;;	      ("intype=" "(DBCS-type) Specifies the type of DBCS data stored in the SAS files to be exported.")
;; Not allowed with the UNIX version of SAS.
	      ("memtype=" "(all|catalog|cat) Restricts the type of SAS file that PROC CPORT writes to the transport file.")
	      ("outlib=" "(library) Specifies a libref associated with a SAS data library.")
	      ("outtype=upcase" " Writes all displayed characters to the transport file and to the OUTLIB= file in uppercase.")
	      ("translate=" "(translation-list) Translates specified characters from one ASCII or EBCDIC value to anoth.")
	      ("asis" "Suppresses the conversion of displayed character data to transport format.")
	      ("datecopy" "Copies the SAS internal date and time when the SAS file was created and the date and time when it was last modified to the resulting transport file.")
	      ("nocompress" "Suppresses the compression of binary zeros and blanks in the transport file.")
	      ("noedit" "Exports SAS/AF PROGRAM and SCL entries without edit capability when you import them.")
	      ("nosrc" "Specifies that exported catalog entries contain compiled SCL code but not the source code.")
	      ("tape" "Directs the output from PROC CPORT to a tape.")
	      ))
    ("document" (
		 ("name=" "(ods) Specifies the name of a new or existing document and its access mode.")
		 ("label=" "('label') Assigns a label to a document.")
		))
    ("fontreg" (
		("mode=" "(add|replace|all) Specifies how to handle new and existing fonts in the SAS registry.")
		("msglevel=" "(verbose|normal|terse|none) Specifies the level of detail to include in the SAS log:.")
		("noupdate" "Specifies that the procedure should run without actually updating the SAS registry.")
		("usesashelp" "Specifies that the SAS registry in the SASHELP library should be updated.")
		))
    ("format" (
	       ("cntlin=" "(data) Specifies a SAS data set from which PROC FORMAT builds informats and formats.")
	       ("cntlout=" "(output-data) Creates a SAS data set that stores information about informats and formats that are contained in the catalog specified in the LIBRARY= option.")
	       ("library=" "([library]|[catalog]) Specifies a catalog to contain informats or formats that you are creating in the current PROC FORMAT step.")
	       ("maxlablen=" "(#) Specifies the number of characters in the informatted or formatted value that you want to appear in the CNTLOUT= data set or in the output of the FMTLIB option.")
	       ("maxselen=" "(#) Specifies the number of characters in the start and end values that you want to appear in the CNTLOUT= data set or in the output of the FMTLIB option.")
	       ("fmtlib" "Prints information about all the informats and formats in the catalog that is specified in the LIBRARY= option.")
	       ("noreplace" "Prevents a new informat or format that you are creating from replacing an existing informat or format of the same name.")
	       ("page" "Prints information about each format and informat (that is, each entry) in the catalog on a separate page.")
	       ))
    ("freq" (
	     ("compress" "Begins display of the next one-way frequency table on the same page as the preceding one-way table if there is enough space to begin the table.")
	     ("nlevels" "Displays the 'Number of Variable Levels' table.")
	     ("noprint" "Suppresses the display of all output. Note that this option temporarily disables the Output Delivery System (ODS).")
	     ("page" "Displays only one table per page.")
	     ("data=" "(data) Names the SAS data set to be analyzed by PROC FREQ")
	     ("order=" "(data|formatted|freq|internal) Specifies the order in which the values of the frequency and crosstabulation table variables are to be reported")
	     ("formchar /**/ =" "('formchar-string') Defines the characters to be used for constructing the outlines and dividers for the cells of contingency tables")
	     ))
    ("import" (
	       ("datafile=" "(file) Specifies the complete path and filename or a fileref for the input PC file, spreadsheet, or delimited external file.")
	       ("table=" "('tablename') Specifies the table name of the input DBMS table.")
	       ("out=" "(output-data) Identifies the output SAS data set with either a one- or two-level SAS name.")
	       ("dbms=" "(access|access97|access2000|access2002|accesscs|csv|dbf|dlm|dta|excel|excel4|excel5|excel97|excel2000|excel2002|excelcs|jmp|pcfs|sav|tab|wk1|wk3|wk4|xls) Specifies the type of data to import.")
	       ("replace" "Overwrites an existing SAS data set.")
	       ))
    ("migrate" (
		("in=" "(library) Names the source SAS data library from which to migrate members.")
		("out=" "(library) Names the target SAS data library to contain the migrated members.")
		("bufsize=" "[n|nK|nM|nG|hexX|MAX] Determines the buffer page size.")
		("slibref=" "(library) Specifies a libref that is assigned through a SAS/SHARE or SAS/CONNECT server to use for migrating catalogs.")
		("move" "Moves SAS members from the source library to the target library and deletes the original members from the source library.")
		("keepnodupkey" "Specifies to retain the NODUPKEY sort assertion.")
		))
    ("options" (
		("define" "Displays the short description of the option, the option group, and the option type.")
		("value" "Displays the option value and scope, as well as how the value was set.")
		("host" "Displays only host options.")
		("nohost" "Displays only portable options.")
		("long" "Specifies the format for displaying the settings of the SAS system options")
		("short" "Specifies the format for displaying the settings of the SAS system options")
		("group=" "(communications|graphics|macro|dataquality|help|memory|email|inputcontrol|meta|envdisplay|install|odsprint|envfiles|languagecontrol|performance|errorhandling|listcontrol|sasfiles|execmodes|log|_listcontrol|sort|extfiles|logcontrol|adabas|idms|oracle|datacom|ims|rexx|db2|ispf) Displays the options in the group specified by group-name.")
		("option=" "(appletloc|noasynchio|noautosignon|nobatch|binding|bottommargin|bufno|bufsize|byerr|byline|nocaps|nocardimage|catcache|cbufno|center|nocharcode|cleanup|nocmdmac|cmpopt|nocollate|colorprinting|compress|connectremote|connectstatus|connectwait|consolelog|copies|cpuid|datastmtchk|date|dbsrvtp|nodetails|device|dflang|dkricond|dkrocond|dldmgaction|nodmr|nodms|nodmsexp|docloc|dsnferr|noduplex|noechoauto|emailhost|emailport|engine|noerrorabend|errorcheck|errors|noexplorer|firstobs|fmterr|fmtsearch|formchar|formdlim|forms|gismaps|gwindow|helploc|noimplmac|initcmd|initstmt|invaliddata|label|leftmargin|linesize|macro|maps|mautosource|mergenoby|merror|nomfile|missing|nomlogic|nomprint|nomrecall|msglevel|nomstored|msymtabmax|nomultenvappl|mvarsize|nonetencrypt|netencryptalgorithm|netencryptkeylen|netmac|news|notes|number|noobjectserver|obs|orientation|noovp|pageno|pagesize|paperdest|papersize|papersource|papertype|parm|parmcards|printerpath|noprintinit|printmsglist|probsig|replace|reuse|rightmargin|norsasuser|s|s2|sasautos|sascmd|sasfrscr|sashelp|sasmstore|sasscript|sasuser|seq|serror|nosetinit|skip|solutions|sortdup|sortseq|sortsize|source|nosource2|nospool|nostartlib|sumsize|nosymbolgen|synchio|sysparm|sysprintfont|tbufsize|tcpportfirst|tcpportlast|noterminal|topmargin|trainloc|trantab|universalprint|user|uuidcount|uuidgendhost|validvarname|vnferr|work|workinit|workterm|yearcutoff|_last_|host|altlog|altprint|autoexec|blksize|comamid|comaux1|comaux2|config|nodbcs|dbcslang|dbcstype|editcmd|emailsys|encoding|filelocks|fsdbtype| fsdevice|fsimm|fsimmopt|nofullstimer|ingopts|loadmemsize|locale|log|lptype|maxmemquery|memsize|msg|nomsgcase|nlscompatmode|nooplist|path|print|printcmd|procleave|realmemsize|rtrace|rtraceloc|seqengine|set|sortanom|sortcut|sortcutp|sortdev|sortlib|sortname|sortparm|sortpgm|nostdio|stimefmt|stimer|sysin|sysleave|sysprint|tapeclose|nounbuflog|noverbose|xcmd|xprintnm) Displays a short description and the value (if any) of the option specified by option-name.")
		))
    ("plot" (
	     ("data=" "(data) Specifies the input SAS data set.")
	     ("hpercent=" "(%) Specifies one or more percentages of the available horizontal space to use for each plot.")
	     ("vpercent=" "(%) Specifies one or more percentages of the available vertical space to use for each plot.")
	     ("vtoh=" "(#) Specifies the aspect ratio (vertical to horizontal) of the characters on the output device.")
	     ("missing" "Includes missing character variable values in the construction of the axes.")
	     ("nolegend" "Suppresses the legend at the top of each plot.")
	     ("nomiss" "Excludes observations for which either variable is missing from the calculation of the axes.")
	     ("uniform" "Uniformly scales axes across BY groups.)")
	     ("formchar /**/ =" "('formatting-character(s)') Defines the characters to use for constructing the borders of the plot")
	     ))
    ("print" (
	      ("contents=" "(link-text) Specifies the text for the links in the HTML contents file to the output produced by the PROC PRINT statement.")
	      ("data=" "(data) Specifies the SAS data set to print.")
	      ("heading=" "(h|v) Controls the orientation of the column headings, where direction is one of the following.")
	      ("n=" "(#) Prints the number of observations in the data set, in BY groups, or both and specifies explanatory text to print with the number.")
	      ("n" "Prints the number of observations in the data set, in BY groups, or both and specifies explanatory text to print with the number.")
	      ("obs=" "(column-header) Specifies a column header for the column that identifies each observation by number.")
	      ("rows=" "(page-format) Formats rows on a page.")
	      ("split=" "('split-character') Specifies the split character, which controls line breaks in column headers.")
	      ("width=" "(uniform|full|minimum|uniformby) Determines the column width for each variable.")
	      ("double" "Writes a blank line between observations.")
	      ("label" "Uses variables' labels as column headings.")
	      ("noobs" "Suppresses the observation number in the output.")
	      ("round" "Rounds unformatted numeric values to two decimal places.")
	      ("uniform" "Alias of WIDTH=UNIFORM, specifying uniform width")
	      ("style /**/ = ()" "Specifies the style.")
	      ))
    ("printto" (
		("label=" "('description') Provides a description for a catalog entry that contains a SAS log or procedure output.")
		("log=" "(log|[file]|[catalog]) Routes the SAS log to one of three locations.")
		("print=" "(print|[file]|[catalog]) Routes procedure output to one of three locations.")
		("unit=" "(#) Routes the output to the file identified by the fileref FTnnF001, where nn is an integer between 1 and 99.")
		("new" "Clears any information that exists in a file and prepares the file to receive the SAS log or procedure output.")
		))
    ("rank" (
	     ("data=" "(data) Specifies the input SAS data set.")
	     ("groups=" "(#) Assigns group values ranging from 0 to number-of-groups minus 1.")
	     ("normal=" "(blom|tukey|vw) Computes normal scores from the ranks.")
	     ("out=" "(output-data) Names the output data set.")
	     ("ties=" "(high|low|mean) Specifies how to compute normal scores or ranks for tied data values.")
	     ("descending" "Reverses the direction of the ranks.")
	     ("fraction" "Computes fractional ranks by dividing each rank by the number of observations having nonmissing values of the ranking variable.")
	     ("nplus1" "Computes fractional ranks by dividing each rank by the denominator n+1.")
	     ("percent" "Divides each rank by the number of observations that have nonmissing values of the variable and multiplies the result by 100 to get a percentage.")
	     ("savage" "Computes Savage (or exponential) scores from the ranks.")
	     ))
    ("sort" (
	     ("ascii" "Sorts character variables using the ASCII collating sequence.")
	     ("ebcdic" "Sorts character variables using the EBCDIC collating sequence.")
	     ("national" "Sorts character variables using an alternate collating sequence.")
	     ("datecopy" "Copies the SAS internal date and time.")
	     ("force" "Sorts and replaces an indexed data set when the OUT= option is not specified.")
	     ("nodupkey" "Checks for and eliminates observations with duplicate BY values.")
	     ("noduprecs" "Checks for and eliminates duplicate observations.")
	     ("overwrite" "Enables the input data set to be deleted before the replacement output data set is populated with observations.")
	     ("reverse" "Sorts character variables using a collating sequence that is reversed from the normal collating sequence.")
	     ("tagsort" "Stores only the BY variables and the observation numbers in temporary files.")
	     ("danish" "Sorts characters according to the Danish and Norwegian national standard")
	     ("norwegian" "Sorts characters according to the Danish and Norwegian national standard")
	     ("finnish" "Sorts characters according to the Finnish and Swedish national standard")
	     ("swedish" "Sorts characters according to the Finnish and Swedish national standard")
	     ("equals" "Specifies the order of the observations in the output data set")
	     ("noequals" "Specifies the order of the observations in the output data set")
	     ("threads" "Enables or prevents the activation of multi-threaded sorting")
	     ("nothreads" "Enables or prevents the activation of multi-threaded sorting")
	     ("sortseq=" "(ascii|ebcdic|danish|finnish|italian|norwegian|spanish|swedish) Specifies the collating sequence.")
	     ("data=" "(data) Identifies the input SAS data set.")
	     ("dupout=" "(output-data) Specifies the output data set to which duplicate observations are writte.")
	     ("out=" "(output-data) Names the output data set. If SAS-data-set does not exist, then PROC SORT creates it.")
	     ("sortsize=" "(memory-specification) Specifies the maximum amount of memory that is available to PROC SORT.")
	     ))
    ("standard" (
		 ("data=" "(data) Identifies the input SAS data set.")
		 ("mean=" "(#) Standardizes variables to a mean of mean-value.")
		 ("out=" "(output-data) Identifies the output data set.")
		 ("std=" "(#) Standardizes variables to a standard deviation of std-value.")
		 ("vardef=" "(df|n|wdf|weight|wgt) Specifies the divisor to use in the calculation of variances and standard deviation.")
		 ("exclnpwgt" "Excludes observations with nonpositive weight values (zero or negative).")
		 ("print" "Prints the original frequency, mean, and standard deviation for each variable to standardize.")
		 ("replace" "Replaces missing values with the variable mean.")
		 ))
    ("summary" (
		("alpha=" "(#) Specifies the confidence level to compute the confidence limits for the mean.")
		("classdata=" "(data) Specifies a data set that contains the combinations of values of the class variables that must be present in the output.")
		("data=" "(data) Identifies the input SAS data set.")
		("fw=" "(#) Specifies the field width to display the statistics in printed or displayed outpu.")
		("maxdec=" "(#) Specifies the maximum number of decimal places to display the statistics in the printed or displayed output.")
		("order=" "(data|formatted|freq|unformatted) Specifies the sort order to create the unique combinations for the values of the class variables in the output.")
		("qntldef=" "(1|2|3|4|5) Specifies the mathematical definition that PROC MEANS uses to calculate quantiles.")
		("pctldef=" "(1|2|3|4|5) Specifies the mathematical definition that PROC MEANS uses to calculate quantiles.")
		("qmarkers=" "(#) Specifies the default number of markers to use for the P² quantile estimation method.")
		("qmethod=" "(os|p2|hist) Specifies the method that PROC MEANS uses to process the input data when it computes quantiles.")
		("sumsize=" "(#) Specifies the amount of memory that is available for data summarization when you use class variables.")
		("vardef=" "(df|n|wdf|weight|wgt) Specifies the divisor to use in the calculation of the variance and standard deviation.")
		("chartype" "Specifies that the _TYPE_ variable in the output data set is a character representation of the binary value of _TYPE_.")
		("completetypes" "Creates all possible combinations of class variables even if the combination does not occur in the input data set.")
		("descendtypes" "Orders observations in the output data set by descending _TYPE_ value.")
		("exclnpwgts" "Excludes observations with nonpositive weight values (zero or negative) from the analysis.")
		("exclusive" "Excludes from the analysis all combinations of the class variables that are not found in the CLASSDATA= data set.")
		("idmin" "Specifies that the output data set contain the minimum value of the ID variables.")
		("missing" "Considers missing values as valid values to create the combinations of class variables.")
		("nonobs" "Suppresses the column that displays the total number of observations for each unique combination of the values of the class variables.")
		("notrap" "Disables floating point exception (FPE) recovery during data processing.")
		("nway" "Specifies that the output data set contain only statistics for the observations with the highest _TYPE_ and _WAY_ values.")
		("printalltypes" "Displays all requested combinations of class variables (all _TYPE_ values) in the printed or displayed output.")
		("printidvars" "Displays the values of the ID variables in printed or displayed output.")
		("print" "Specifies whether PROC MEANS displays the statistical analysis")
		("noprint" "Specifies whether PROC MEANS displays the statistical analysis")
		("threads" "Enables or disables parallel processing of the input data set")
		("nothreads" "Enables or disables parallel processing of the input data set")

;; descriptive statistics
		("css" "Sum of squares corrected for the mean.")
		("cv" "Is the percent coefficient of variation.")
		("max" "Is the maximum value.")
		("mean" "Is the arithmetic mean.")
		("min" "Is the minimum value.")
;;		("mode" "Is the most frequent value.")
		("n" "Is the number of [equation] values that are not missing.")
		("nmiss" "Is the number of [equation] values that are missing.")
		("nobs" "Is the total number of observations and is calculated as the sum of N and NMISS.")
		("range" "Is the range and is calculated as the difference between maximum value and minimum value.")
		("sum" "Is the sum.")
		("sumwgt" "Is the sum of the weights.")
		("uss" "Is the uncorrected sum of squares.")
		("var" "Is the variance.")
		("kurtosis" "Is the kurtosis, which measures heaviness of tails")
		("kurt" "Is the kurtosis, which measures heaviness of tails")
		("skewness" "Is skewness, which measures the tendency of the deviations to be larger in one direction than in the other")
		("skew" "Is skewness, which measures the tendency of the deviations to be larger in one direction than in the other")
		("stddev" "is the standard deviation")
		("std" "is the standard deviation")
		("stderr" "Is the standard error of the mean")
		("stdmean" "Is the standard error of the mean")
;; Quantile Stats
		("median" "Is the middle value.")
		("p1" "Is the 1st percentile.")
		("p5" "Is the 5th percentile.")
		("p10" "Is the 10th percentile.")
		("p90" "Is the 90th percentile.")
		("p95" "Is the 95th percentile.")
		("p99" "Is the 99th percentile.")
		("q1" "Is the lower quartile (25th percentile).")
		("q3" "Is the upper quartile (75th percentile).")
		("qrange" "Is interquartile range.")
;; Hypothesis testing stats
		("t" "Is the Student's t statistic.")
		("probt" "Is the two-tailed p-value for Student's t statistic.")
;; Confidence Limits for the mean
		("clm" "Is the two-sided confidence limit for the mean.")
		("lclm" "Is the one-sided confidence limit below the mean.")
		("uclm" "Is the one-sided confidence limit above the mean.")
;; End Stats
		))
    ("means" (
		("alpha=" "(#) Specifies the confidence level to compute the confidence limits for the mean.")
		("classdata=" "(data) Specifies a data set that contains the combinations of values of the class variables that must be present in the output.")
		("data=" "(data) Identifies the input SAS data set.")
		("fw=" "(#) Specifies the field width to display the statistics in printed or displayed output.")
		("maxdec=" "(#) Specifies the maximum number of decimal places to display the statistics in the printed or displayed output.")
		("order=" "(data|formatted|freq|unformatted) Specifies the sort order to create the unique combinations for the values of the class variables in the output.")
		("qntldef=" "(1|2|3|4|5) Specifies the mathematical definition that PROC MEANS uses to calculate quantiles.")
		("pctldef=" "(1|2|3|4|5) Specifies the mathematical definition that PROC MEANS uses to calculate quantiles.")
		("qmarkers=" "(#) Specifies the default number of markers to use for the P² quantile estimation method.")
		("qmethod=" "(os|p2|hist) Specifies the method that PROC MEANS uses to process the input data when it computes quantiles.")
		("sumsize=" "(#) Specifies the amount of memory that is available for data summarization when you use class variables.")
		("vardef=" "(df|n|wdf|weight|wgt) Specifies the divisor to use in the calculation of the variance and standard deviation.")
		("chartype" "Specifies that the _TYPE_ variable in the output data set is a character representation of the binary value of _TYPE_.")
		("completetypes" "Creates all possible combinations of class variables even if the combination does not occur in the input data set.")
		("descendtypes" "Orders observations in the output data set by descending _TYPE_ value.")
		("exclnpwgts" "Excludes observations with nonpositive weight values (zero or negative) from the analysis.")
		("exclusive" "Excludes from the analysis all combinations of the class variables that are not found in the CLASSDATA= data set.")
		("idmin" "Specifies that the output data set contain the minimum value of the ID variables.")
		("missing" "Considers missing values as valid values to create the combinations of class variables.")
		("nonobs" "Suppresses the column that displays the total number of observations for each unique combination of the values of the class variables.")
		("notrap" "Disables floating point exception (FPE) recovery during data processing.")
		("nway" "Specifies that the output data set contain only statistics for the observations with the highest _TYPE_ and _WAY_ values.")
		("printalltypes" "Displays all requested combinations of class variables (all _TYPE_ values) in the printed or displayed output.")
		("printidvars" "Displays the values of the ID variables in printed or displayed output.")
		("print" "Specifies whether PROC MEANS displays the statistical analysis")
		("noprint" "Specifies whether PROC MEANS displays the statistical analysis")
		("threads" "Enables or disables parallel processing of the input data set")
		("nothreads" "Enables or disables parallel processing of the input data set")

;; descriptive statistics
		("css" "Sum of squares corrected for the mean.")
		("cv" "Is the percent coefficient of variation.")
		("max" "Is the maximum value.")
		("mean" "Is the arithmetic mean.")
		("min" "Is the minimum value.")
;;		("mode" "Is the most frequent value.")
		("n" "Is the number of [equation] values that are not missing.")
		("nmiss" "Is the number of [equation] values that are missing.")
		("nobs" "Is the total number of observations and is calculated as the sum of N and NMISS.")
		("range" "Is the range and is calculated as the difference between maximum value and minimum value.")
		("sum" "Is the sum.")
		("sumwgt" "Is the sum of the weights.")
		("uss" "Is the uncorrected sum of squares.")
		("var" "Is the variance.")
		("kurtosis" "Is the kurtosis, which measures heaviness of tails")
		("kurt" "Is the kurtosis, which measures heaviness of tails")
		("skewness" "Is skewness, which measures the tendency of the deviations to be larger in one direction than in the other")
		("skew" "Is skewness, which measures the tendency of the deviations to be larger in one direction than in the other")
		("stddev" "is the standard deviation")
		("std" "is the standard deviation")
		("stderr" "Is the standard error of the mean")
		("stdmean" "Is the standard error of the mean")
;; Quantile Stats
		("median" "Is the middle value.")
		("p1" "Is the 1st percentile.")
		("p5" "Is the 5th percentile.")
		("p10" "Is the 10th percentile.")
		("p90" "Is the 90th percentile.")
		("p95" "Is the 95th percentile.")
		("p99" "Is the 99th percentile.")
		("q1" "Is the lower quartile (25th percentile).")
		("q3" "Is the upper quartile (75th percentile).")
		("qrange" "Is interquartile range.")
;; Hypothesis testing stats
		("t" "Is the Student's t statistic.")
		("probt" "Is the two-tailed p-value for Student's t statistic.")
;; Confidence Limits for the mean
		("clm" "Is the two-sided confidence limit for the mean.")
		("lclm" "Is the one-sided confidence limit below the mean.")
		("uclm" "Is the one-sided confidence limit above the mean.")
;; End Stats
		))
    ("tabulate" (
		 ("alpha=" "(#) Specifies the confidence level to compute the confidence limits for the mean.")
		 ("classdata=" "(data) Specifies a data set that contains the combinations of values of the class variables that must be present in the output.")
		 ("contents=" "(link-name) Enables you to name the link in the HTML table of contents.")
		 ("data=" "(data) Specifies the input data set.")
		 ("format=" "(format) Specifies a default format for the value in each table cell.")
		 ("order=" "(data|formatted|freq|unformatted) Specifies the sort order to create the unique combinations of the values of the class variables.")
		 ("out=" "(output-data) Names the output data set.")
		 ("pctldef=" "(1|2|3|4|5) Specifies the mathematical definition that the procedure uses to calculate quantiles .")
		 ("qmarkers=" "(#) Specifies the default number of markers to use for the P2 quantile estimation.")
		 ("qmethod=" "(os|p2|hist) Specifies the method PROC TABULATE uses to process the input data when it computes quantiles.")		 
		 ("qntldef=" "(1|2|3|4|5) Specifies the mathematical definition that the procedure uses to calculate quantiles .")
		 ("style=" "Specifies the style element to use for the data cells.")
		 ("vardef=" "(df|n|wdf|weight|wgt) Specifies the divisor to use in the calculation of the variance and standard deviation.")
		 ("exclnpwgts" "Excludes observations with nonpositive weight values (zero or negative) from the analysis.")
		 ("exclusive" "Excludes from the tables and the output data sets all combinations of the class variable that are not found in the CLASSDATA= data set.")
		 ("missing" "Considers missing values as valid values to create the combinations of class variables.")
		 ("noseps" "Eliminates horizontal separator lines from the row titles and the body of the table.")
		 ("threads" "Enables parallel processing of the input data set")
		 ("nothreads" "Disables parallel processing of the input data set")
		 ("trap" "Enables floating point exception (FPE) recovery during data processing beyond that provided by normal SAS FPE handling")
		 ("notrap" "Disables floating point exception (FPE) recovery during data processing beyond that provided by normal SAS FPE handling")
		 ("formchar /**/ =" "Defines the characters to use for constructing the table outlines and dividers.")
		 ))
    ("timeplot" (
		 ("data=" "(data) Identifies the input data set.")
		 ("maxdec=" "(#) Specifies the maximum number of decimal places to print in the listing.")
		 ("split=" "Specifies a split character, which controls line breaks in column headings.")
		 ("uniform" "Uniformly scales the horizontal axis across all BY groups.")
		 ))
    ("transpose" (
		  ("data=" "(data) Names the SAS data set to transpose.")
		  ("label=" "(name) Specifies a name for the variable in the output data set that contains the label of the variable that is being transposed.")
		  ("name=" "(name) Specifies the name for the variable in the output data set that contains the name of the variable that is being transposed to create the current observation.")
		  ("out=" "(output-data) Names the output data set.")
		  ("prefix=" "(prefix) Specifies a prefix to use in constructing names for transposed variables in the output data set.")
		  ("let" "Allows duplicate values of an ID variable.")
		  ))
    ("univariate" (
		   ("all" "Requests all statistics and tables.")
		   ("exclnpwgt" "Excludes observations with nonpositive weight values.")
		   ("freq" "Requests a frequency table.")
		   ("loccount" "Requests a table that shows the # of observations >, ^=, and < the MU0.")
		   ("nobyplot" "Suppresses side-by-side box plots.")
		   ("noprint" "Suppresses all the tables of descriptive statistics.")
		   ("robustscale" "Produces a table with robust estimates of scale.")
		   ("alpha=" "(#) Specifies the significance level for (1-alpha) confidence intervals.")
		   ("annotate=" "(data) Specifies an input data set that contains annotate variables")
		   ("anno=" "(data) Specifies an input data set that contains annotate variables")
		   ("mu0=" "(#) Specifies the value of the mean or location parameter")
		   ("location=" "(#) Specifies the value of the mean or location parameter")
		   ("pctldef=" "(1|2|3|4|5) Specifies the definition that PROC UNIVARIATE uses to calculate quantiles. (default 5)")
		   ("def=" "(1|2|3|4|5) Specifies the definition that PROC UNIVARIATE uses to calculate quantiles. (default 5)")
		   ("cibasic(type=/**/ alpha=)" "<(<TYPE=keyword> <ALPHA=alpha>)> Requests confidence limits for the mean, standard deviation, and variance based on the assumption that the data are normally distributed.")
		   ("cipctldf(type=/**/ alpha=)" "<(<TYPE=keyword> <ALPHA=alpha>)> Requests confidence limits for quantiles based on a method that is distribution-free")
		   ("ciquantdf(type=/**/ alpha=)" "<(<TYPE=keyword> <ALPHA=alpha>)> Requests confidence limits for quantiles based on a method that is distribution-free")
		   ("cipctlnormal(type=/**/ alpha=)" "<(<TYPE=keyword> <ALPHA=alpha>)> Requests confidence limits for quantiles based on the assumption that the data are normally distributed")
		   ("ciquantnormal(type=/**/ alpha=)" "<(<TYPE=keyword> <ALPHA=alpha>)> Requests confidence limits for quantiles based on the assumption that the data are normally distributed")
		   ("data=" "(data) Specifies the input SAS data set to be analyzed")
		   ("gout=" "(gout) Specifies the SAS catalog that PROC UNIVARIATE uses to save high-resolution graphics output")
		   ("nextrobs=" "(#) Specifies the number of extreme observations that PROC UNIVARIATE lists in the table of extreme observations")
		   ("nextrval=" "(#) Specifies the number of extreme values that PROC UNIVARIATE lists in the table of extreme values")
		   ("plotsize=" "(#) Specifies the approximate number of rows used in line-printer plots requested with the PLOTS option")
		   ("round=" "(units) Specifies the units to use to round the analysis variables prior to computing statistics")
		   ("vardef=" "(df|n|wdf|weight|wgt) Specifies the divisor to use in the calculation of variances and standard deviation")
		   ("modes" "Requests a table of all possible modes")
		   ("mode" "Requests a table of all possible modes")
		   ("plots" "Produces a stem-and-leaf plot (or a horizontal bar chart), a box plot, and a normal probability plot in line printer output.")
		   ("plot" "Produces a stem-and-leaf plot (or a horizontal bar chart), a box plot, and a normal probability plot in line printer output.")
		   ("normal" "Requests tests for normality that include a series of goodness-of-fit tests based on the empirical distribution function")
		   ("normaltest" "Requests tests for normality that include a series of goodness-of-fit tests based on the empirical distribution function")
		   ("trimmed= (type= alpha=)" "values <(<TYPE=keyword> <ALPHA=alpha>)> Requests a table of trimmed means, where value specifies the number or the proportion of observations that PROC UNIVARIATE trims")
		   ("trim= /**/ (type= alpha=)" "values <(<TYPE=keyword> <ALPHA=alpha>)> Requests a table of trimmed means, where value specifies the number or the proportion of observations that PROC UNIVARIATE trims")
		   ("winsorized= /**/ (type= alpha=)" "values <(<TYPE=keyword> <ALPHA=alpha>)> Requests of a table of Winsorized means, where value is the number or the proportion of observations that PROC UNIVARIATE uses to compute the Winsorized mean")
		   ("winsor= /**/ (type= alpha=)" "values <(<TYPE=keyword> <ALPHA=alpha>)> Requests of a table of Winsorized means, where value is the number or the proportion of observations that PROC UNIVARIATE uses to compute the Winsorized mean")
		   ("type=" "(lower|upper|twosided|symmetric|asymmetric) Specifies the type of confidence limit.")
		   ))
    )
  )
;;
;; Individual procs options.
;;

;;
;;  procedure.statment is options for a statment after /.
;;
;;  proceudre-statment is options for a statment before /.
;;
(defvar proc-catalog-state-options
  '(
    ("catalog.change" (
		       ("entrytype=" "(etype) Restricts processing to one entry type.")
		       ))
    ("catalog.contents" (
			 ("catalog=" "(catalog) Specifies the SAS catalog to process.")
			 ("file=" "(fileref) Sends the contents to an external file, identified with a SAS fileref.")
			 ("out=" "(output-data) Sends the contents to a SAS data set.")
			 ))
    ("catalog-copy" (
		     ("out=" "(catalog) Names the catalog to which entries are copied.")
		     ("entrytype=" "(etype) Restricts processing to one entry type for the current COPY statement and any subsequent SELECT or EXCLUDE statements.")
		     ("in=" "(catalog) Specifies the catalog to copy.")
		     ("move" "Deletes the original catalog or entries after the new copy is made.")
		     ("new" "Overwrites the destination (specified by OUT=) if it already exists.")
		     ("noedit" "Prevents the copied version of the following SAS/AF entry types from being edited by the BUILD procedure.")
		     ("nosource" "Omits copying the source lines when you copy a SAS/AF PROGRAM, FRAME, or SCL entry.")
		     ))
    ("catalog.delete" (
		       ("entrytype=" "(etype) Restricts processing to one entry type.")
		       ))
    ("catalog.exchange" (
			 ("entrytype=" "(etype) Restricts processing to one entry type.")
			 ))
    ("catalog.exclude" (
			("entrytype=" "(etype) Restricts processing to one entry type.")
			))
    ("catalog.modify" (
		       ("entrytype=" "(etype) Restricts processing to one entry type.")
		       ))
    ("catalog-modify" (
		       ("description=" "Changes the description of a catalog entry by replacing it with a new description, up to 256 characters long, or by removing it altogether")
		       ))
    ("catalog.save" (
		     ("entrytype=" "(etype) Restricts processing to one entry type.")
		     ))
    ("catalog.select" (
		       ("entrytype=" "(etype) Restricts processing to one entry type.")
		       ))
    )
  )
(defvar proc-chart-state-options
  '(
    ("chart.block" (
		    ("ascending" "Prints the bars and any associated statistics in ascending order of size within groups.")
		    ("cfreq" "Prints the cumulative frequency.")
		    ("cpercent" "Prints the cumulative percentages.")
		    ("descending" "Prints the bars and any associated statistics in descending order of size within groups.")
		    ("discrete" "Specifies that a numeric chart variable is discrete rather than continuous.")
		    ("freq" "Prints the frequency of each bar to the side of the chart.")
		    ("g100" "Specifies that the sum of percentages for each group equals 100.")
		    ("mean" "Prints the mean of the observations represented by each bar.")
		    ("missing" "Specifies that missing values are valid levels for the chart variable.")
		    ("noheader" "Suppresses the default header line printed at the top of a chart.")
		    ("nostats" "Suppresses the statistics on a horizontal bar chart.")
		    ("nosymbol" "Suppresses printing of the subgroup symbol or legend table.")
		    ("nozeros" "Suppresses any bar with zero frequency.")
		    ("percent" "Prints the percentages of observations having a given value for the chart variable.")
		    ("sum" "Prints the total number of observations that each bar represents.")
		    ("axis=" "(axis-expression) Specifies the values for the response axis.")
		    ("freq=" "(variable) Specifies a data set variable that represents a frequency count for each observation.")
		    ("group=" "(variable) Produces side-by-side charts.")
		    ("gspace=" "(#) Specifies the amount of extra space between groups of bars.")
		    ("levels=" "(#) Specifies the number of bars that represent each chart variable when the variables are continuous.")
		    ("midpoints=" "[midpoint-specification|OLD] Defines the range of values that each bar, block, or section represents by specifying the range midpoints.")
		    ("ref=" "(value(s)) Draws reference lines on the response axis at the specified positions.")
		    ("space=" "(#) Specifies the amount of space between individual bars.")
		    ("subgroup=" "(variable) Subdivides each bar or block into characters that show the contribution of the values of variable to that bar or block.")
		    ("sumvar=" "(variable) Specifies the variable for which either values or means (depending on the value of TYPE=) PROC CHART displays in the chart.")
		    ("symbol=" "Specifies the character or characters that PROC CHART uses in the bars or blocks of the chart when you do not use the SUBGROUP= option.")
		    ("type=" "(cfreq|cpercent|freq|mean|percent|sum) Specifies what the bars or sections in the chart represent.")
		    ("width=" "(#) Specifies the width of the bars on bar charts.")
		    ))
    ("chart.hbar" (
		    ("ascending" "Prints the bars and any associated statistics in ascending order of size within groups.")
		    ("cfreq" "Prints the cumulative frequency.")
		    ("cpercent" "Prints the cumulative percentages.")
		    ("descending" "Prints the bars and any associated statistics in descending order of size within groups.")
		    ("discrete" "Specifies that a numeric chart variable is discrete rather than continuous.")
		    ("freq" "Prints the frequency of each bar to the side of the chart.")
		    ("g100" "Specifies that the sum of percentages for each group equals 100.")
		    ("mean" "Prints the mean of the observations represented by each bar.")
		    ("missing" "Specifies that missing values are valid levels for the chart variable.")
		    ("noheader" "Suppresses the default header line printed at the top of a chart.")
		    ("nostats" "Suppresses the statistics on a horizontal bar chart.")
		    ("nosymbol" "Suppresses printing of the subgroup symbol or legend table.")
		    ("nozeros" "Suppresses any bar with zero frequency.")
		    ("percent" "Prints the percentages of observations having a given value for the chart variable.")
		    ("sum" "Prints the total number of observations that each bar represents.")
		    ("axis=" "(value-expression) Specifies the values for the response axis.")
		    ("freq=" "(variable) Specifies a data set variable that represents a frequency count for each observatio.")
		    ("group=" "(variable) Produces side-by-side charts.")
		    ("gspace=" "(#) Specifies the amount of extra space between groups of bars.")
		    ("levels=" "(#) Specifies the number of bars that represent each chart variable when the variables are continuous.")
		    ("midpoints=" "[midpoint-specification|OLD] Defines the range of values that each bar, block, or section represents by specifying the range midpoints.")
		    ("ref=" "(value(s)) Draws reference lines on the response axis at the specified positions.")
		    ("space=" "(#) Specifies the amount of space between individual bars.")
		    ("subgroup=" "(variable) Subdivides each bar or block into characters that show the contribution of the values of variable to that bar or block.")
		    ("sumvar=" "(variable) Specifies the variable for which either values or means (depending on the value of TYPE=) PROC CHART displays in the chart.")
		    ("symbol=" "Specifies the character or characters that PROC CHART uses in the bars or blocks of the chart when you do not use the SUBGROUP= option.")
		    ("type=" "(cfreq|cpercent|freq|mean|percent|sum) Specifies what the bars or sections in the chart represent.")
		    ("width=" "(#) Specifies the width of the bars on bar charts.")
		   ))
    ("chart.pie" 
(		    ("ascending" "Prints the bars and any associated statistics in ascending order of size within groups.")
		    ("cfreq" "Prints the cumulative frequency.")
		    ("cpercent" "Prints the cumulative percentages.")
		    ("descending" "Prints the bars and any associated statistics in descending order of size within groups.")
		    ("discrete" "Specifies that a numeric chart variable is discrete rather than continuous.")
		    ("freq" "Prints the frequency of each bar to the side of the chart.")
		    ("g100" "Specifies that the sum of percentages for each group equals 100.")
		    ("mean" "Prints the mean of the observations represented by each bar.")
		    ("missing" "Specifies that missing values are valid levels for the chart variable.")
		    ("noheader" "Suppresses the default header line printed at the top of a chart.")
		    ("nostats" "Suppresses the statistics on a horizontal bar chart.")
		    ("nosymbol" "Suppresses printing of the subgroup symbol or legend table.")
		    ("nozeros" "Suppresses any bar with zero frequency.")
		    ("percent" "Prints the percentages of observations having a given value for the chart variable.")
		    ("sum" "Prints the total number of observations that each bar represents.")
		    ("axis=" "(axis-expression) Specifies the values for the response axis.")
		    ("freq=" "(variable) Specifies a data set variable that represents a frequency count for each observatio.")
		    ("group=" "(variable) Produces side-by-side charts.")
		    ("gspace=" "(#) Specifies the amount of extra space between groups of bars.")
		    ("levels=" "(#) Specifies the number of bars that represent each chart variable when the variables are continuous.")
		    ("midpoints=" "(midpoint-specification|OLD) Defines the range of values that each bar, block, or section represents by specifying the range midpoints.")
		    ("ref=" "(#) Draws reference lines on the response axis at the specified positions.")
		    ("space=" "(#) Specifies the amount of space between individual bars.")
		    ("subgroup=" "(variable) Subdivides each bar or block into characters that show the contribution of the values of variable to that bar or block.")
		    ("sumvar=" "(variable) Specifies the variable for which either values or means (depending on the value of TYPE=) PROC CHART displays in the chart.")
		    ("symbol=" "Specifies the character or characters that PROC CHART uses in the bars or blocks of the chart when you do not use the SUBGROUP= option.")
		    ("type=" "(cfreq|cpercent|freq|mean|percent|sum) Specifies what the bars or sections in the chart represent.")
		    ("width=" "(#) Specifies the width of the bars on bar charts.")
		  ))
    ("chart.star" (
		    ("ascending" "Prints the bars and any associated statistics in ascending order of size within groups.")
		    ("cfreq" "Prints the cumulative frequency.")
		    ("cpercent" "Prints the cumulative percentages.")
		    ("descending" "Prints the bars and any associated statistics in descending order of size within groups.")
		    ("discrete" "Specifies that a numeric chart variable is discrete rather than continuous.")
		    ("freq" "Prints the frequency of each bar to the side of the chart.")
		    ("g100" "Specifies that the sum of percentages for each group equals 100.")
		    ("mean" "Prints the mean of the observations represented by each bar.")
		    ("missing" "Specifies that missing values are valid levels for the chart variable.")
		    ("noheader" "Suppresses the default header line printed at the top of a chart.")
		    ("nostats" "Suppresses the statistics on a horizontal bar chart.")
		    ("nosymbol" "Suppresses printing of the subgroup symbol or legend table.")
		    ("nozeros" "Suppresses any bar with zero frequency.")
		    ("percent" "Prints the percentages of observations having a given value for the chart variable.")
		    ("sum" "Prints the total number of observations that each bar represents.")
		    ("axis=" "(value-expression) Specifies the values for the response axis.")
		    ("freq=" "(variable) Specifies a data set variable that represents a frequency count for each observatio.")
		    ("group=" "(variable) Produces side-by-side charts.")
		    ("gspace=" "(#) Specifies the amount of extra space between groups of bars.")
		    ("levels=" "(number-of-midpoints) Specifies the number of bars that represent each chart variable when the variables are continuous.")
		    ("midpoints=" "(midpoint-specification|OLD) Defines the range of values that each bar, block, or section represents by specifying the range midpoints.")
		    ("ref=" "(value(s)) Draws reference lines on the response axis at the specified positions.")
		    ("space=" "(#) Specifies the amount of space between individual bars.")
		    ("subgroup=" "(variable) Subdivides each bar or block into characters that show the contribution of the values of variable to that bar or block.")
		    ("sumvar=" "(variable) Specifies the variable for which either values or means (depending on the value of TYPE=) PROC CHART displays in the chart.")
		    ("symbol=" "(character(s)) Specifies the character or characters that PROC CHART uses in the bars or blocks of the chart when you do not use the SUBGROUP= option.")
		    ("type=" "(statistic) Specifies what the bars or sections in the chart represent.")
		    ("width=" "(#) Specifies the width of the bars on bar charts.")
		   ))
    ("chart.vbar" (
		    ("ascending" "Prints the bars and any associated statistics in ascending order of size within groups.")
		    ("cfreq" "Prints the cumulative frequency.")
		    ("cpercent" "Prints the cumulative percentages.")
		    ("descending" "Prints the bars and any associated statistics in descending order of size within groups.")
		    ("discrete" "Specifies that a numeric chart variable is discrete rather than continuous.")
		    ("freq" "Prints the frequency of each bar to the side of the chart.")
		    ("g100" "Specifies that the sum of percentages for each group equals 100.")
		    ("mean" "Prints the mean of the observations represented by each bar.")
		    ("missing" "Specifies that missing values are valid levels for the chart variable.")
		    ("noheader" "Suppresses the default header line printed at the top of a chart.")
		    ("nostats" "Suppresses the statistics on a horizontal bar chart.")
		    ("nosymbol" "Suppresses printing of the subgroup symbol or legend table.")
		    ("nozeros" "Suppresses any bar with zero frequency.")
		    ("percent" "Prints the percentages of observations having a given value for the chart variable.")
		    ("sum" "Prints the total number of observations that each bar represents.")
		    ("axis=" "(axis-expression) Specifies the values for the response axis.")
		    ("freq=" "(variable) Specifies a data set variable that represents a frequency count for each observatio.")
		    ("group=" "(variable) Produces side-by-side charts.")
		    ("gspace=" "(#) Specifies the amount of extra space between groups of bars.")
		    ("levels=" "(#) Specifies the number of bars that represent each chart variable when the variables are continuous.")
		    ("midpoints=" "[midpoint-specification|OLD] Defines the range of values that each bar, block, or section represents by specifying the range midpoints.")
		    ("ref=" "Draws reference lines on the response axis at the specified positions.")
		    ("space=" "(#) Specifies the amount of space between individual bars.")
		    ("subgroup=" "(variable) Subdivides each bar or block into characters that show the contribution of the values of variable to that bar or block.")
		    ("sumvar=" "(variable) Specifies the variable for which either values or means (depending on the value of TYPE=) PROC CHART displays in the chart.")
		    ("symbol=" "(character(s)) Specifies the character or characters that PROC CHART uses in the bars or blocks of the chart when you do not use the SUBGROUP= option.")
		    ("type=" "(statistic) Specifies what the bars or sections in the chart represent.")
		    ("width=" "(#) Specifies the width of the bars on bar charts.")
		   ))

    )
)

(defvar proc-cimport-state-options
  '(
    ("cimport.exclude" (
			("entrytype=" "(etype) Specifies a single entry type for the catalog entry(s) listed in the EXCLUDE statement.")
			("memtype=" "(all|catalog|data) Specifies a single member type for the SAS file(s) listed in the EXCLUDE statement.")
			))
    ("cimport.select" (
		       ("entrytype=" "(etype) Specifies a single entry type for the catalog entry(s) listed in the SELECT statement.")
		       ("memtype=" "(all|catalog|data) Specifies a single member type for the SAS file(s) listed in the SELECT statement.")
		       ))
    )
)
(defvar proc-compare-state-options
  '(
    ("compare-id" (
		   ("descending" "Specifies that the data set is sorted in descending order by the variable that immediately follows the word DESCENDING in the BY statement.")
		   ("notsorted" "Specifies that observations are not necessarily sorted in alphabetic or numeric order.")
		   ))
    )
  )

(defvar proc-copy-state-options
  '(
    ("copy.exclude" (
		     ("memtype=" "(access|all|catalog|data|fdb|mddb|program|view) Restricts processing to one member type")
		     ))
    ("copy.include" (
		     ("alter=" "(alter-password) Provides the alter password for any alter-protected SAS files that you are moving from one data library to another")
		     ("memtype=" "(access|all|catalog|data|fdb|mddb|program|view) Restricts processing to one member type")
		     ))
    )
)
(defvar proc-corr-state-options
  '(
    )
  )

(defvar proc-cport-state-options
  '(
    ("cport.exclude" (
		     ("entrytype=" "(etype) Specifies a single entry type for the catalog entries listed in the EXCLUDE statement.")
		     ("memtype=" "(catalog|cat|data|all) Specifies a single member type for the SAS file(s) listed in the EXCLUDE statement.")
		     ))
    ("cport.select" (
		     ("entrytype=" "(etype) Specifies a single entry type for the catalog entries listed in the SELECT statement.")
		     ("memtype=" "(mtype) Specifies a single member type for the SAS file(s) listed in the SELECT statement.")
		     ))
    ("cport-trantab" (
		      ("name=" "(translation-table-name) Specifies the name of the translation table to apply to the SAS catalog that you want to export.")
		      ("type=" "((etype-list)) Applies the translation table only to the entries with the type or types that you specify.")
		      ("opt=" "(disp|src|(disp src))")
		      ))
    )
  )

(defvar proc-document-state-options
  '(
    ("document.copy" (
		      ("after=" "(path) Inserts a copy of an entry after the specified path.")
		      ("before=" "(path) Inserts a copy of an entry before the specified path.")
		      ("levels=" "[ALL|value] Specifies the depth of the file location.")
		      ("first" "Inserts a copy of an entry at the beginning of the specified path.")
		      ("last" "Inserts a copy of an entry at the end of the specified path.")
		      ))
    ("document-copy" (
		      ("to" "Required to statement.")
		      ))
    ("document-doc" (
		     ("label=" "('label') Assigns a label to the document.")
		     ("library=" "(library) Specifies that only the documents in the specified library-name are listed.")
		     ("name=" "(libref.member-name <access-option(s)>) Specifies the name of a document and its access mode.")
		     ))
    ("document-import" (
			("data=" "(data-set-name) Specifies an existing SAS data set to import.")
			("grseg=" "(grseg) Stores a reference to a graph segment.")
			("to" "Required statement for importing")
			))
    ("document.import" (
			("after=" "(path) Imports the data set or graph segment into the file location after the specified path.")
			("before=" "(path) Imports the data set or graph segment into the file location before the specified path.")
			("first" "Imports the data set or graph segment at the beginning of the file location.")
			("last" "Imports the data set or graph segment at the end the file location.")
			))
    ("document-link" (
		      ("to" "Required to statement")
		      ))
    ("document.link" (
		      ("after=" "(path) Links to the entry that is after the specified path in the current file location.")
		      ("before=" "(path) Links to the entry that is before the specified path in the current file location.")
		      ("first" "Links to the first entry in the current file location.")
		      ("hard" "Specifies a type of link that refers to a copy of an output object within the ODS document.")
		      ("label" "Copies the source label to the link.")
		      ("last" "Links to the last entry in the current file location.")
		      ))
    ("document.list" (
		      ("details" "Specifies the properties of the entries.")
		      ("follow" "Resolves all links and lists the contents of the entries.")
		      ("levels=" "(value|ALL) Specifies the level of the path to list.")
		      ("order=" "(ALPHA|DATE|INSERT) Specifies the order in which the entries are listed.")
		      ))
    ("document.make" (
		      ("after=" "(path) Adds the newly created file location after the specified path in the current file location.")
		      ("before=" "(path) Adds the newly created file location before the specified path in the current file location.")
		      ("first" "Adds the newly created file location to the beginning of the current file location.")
		      ("last" "Adds the newly created file location to the end of the current file location.")
		      ))
    ("document-move" (
		      ("to" "Require statement")
		      ))
    ("document.move" (
		      ("after=" "(path) Moves the entry after the specified entry in the path.")
		      ("before=" "(path) Moves the entry before the specified entry in the path.")
		      ("levels=" "[value|ALL] Specifies the level in the file hierarchy.")
		      ("first" "Moves the entry to the beginning of the specified file location.")
		      ("last" "Moves the entry to the end of the specified file location.")
		      ))
    ("document.note" (
		      ("after=" "(path) Inserts the text string after the specified path.")
		      ("before=" "(path) Inserts the text string before the specified path.")
		      ("just=" "(left|center|right) Specifies the alignment of the text string.")
		      ("\"\"" "Insert a string.")
		      ("first" "Inserts the text string at the beginning of the path.")
		      ("last" "Inserts the text string at the end of the path.")
		      ))
    ("document.obanote" (
			 ("just=" "(left|center|right) Specifies the alignment of the object footer.")
			 ))
    ("document.obbnote" (
			 ("just=" "(left|center|right) Specifies the alignment of the object footer.")
			 ))
    ("document.obpage" (
			("after" "Inserts a page break after an output object.")
			("delete" "Removes the page break for an output object.")
			))
    ("document.obstitle" (
			("just=" "(left|center|right) Specifies the alignment of the subtitle.")
			))
    ("document.replay" (
			("activefootn" "Specifies that footnotes that are active in a SAS session will override the footnotes that are stored in an ODS document.")
			("activetitle" "Specifies that titles that are active in a SAS session will override the titles that are stored in an ODS document.")
			("dest=(/**/)" "(ods) Specifies one or more ODS destinations to display output objects.")
			("levels=" "[ALL|value] Specifies the depth of the path.")
			))
    )
  )

(defvar proc-export-state-options
  '(
    ("export- " (
		 ("delimiter=" "Specifies the delimiter to separate columns of data in the output file.")
		 ("sheet=" "(spreadsheet-name) Identifies a particular spreadsheet name to load into a workbook.")
		 ("database=" "(file) Specifies the complete path and filename of the database to contain the specified DBMS table.")
		 ("dbpwd=" "('database-password') Specifies a password that allows access to a database.")
		 ("pwd=" "('password') Specifies the user password used by the DBMS to validate a specific userid.")
		 ("uid=" "('userid') Identifies the user to the DBMS.")
		 ("wgdb=" "('workgroup-database-name') Specifies the workgroup (security) database name that contains the USERID and PWD data for the DBMS.")
		 ("server=" "('PC-server-name') Specifies the name of the PC server.")
		 ("service=" "('service-name') Specifies the service name that is defined on your service file for your client and server machines.")
		 ("port=" "(port-number) Specifies the number of the port that is listening on the PC server.")
		 ("version=" "('file-version') Specifies the version of the file that you want to create with if the file does not exist on your PC server yet.")
		 ))
    ))
(defvar proc-import-state-options
  '(
    ("import- " (
		 ("datarow=" "(#) Starts reading data from row number n in the external file.")
		 ("dbsaslabel=" "(compat|none)  DBSASLABEL=COMPAT, column names in SAS label names. Otherwise they are not saved.")
		 ("endcol=" "(#) For an XLS data source, specifies the last column of data to be read.")
		 ("endnamerow=" "(#) For an XLS data source, specifies the last row of data to read variable names.")
		 ("endrow=" "(#) For an XLS data source, specifies the last row of data to be read.")
		 ("getdeleted=" "(yes|no) For a dBASE file (DBF), indicates whether to write records to the SAS data set that are marked for deletion but have not been purged.")
		 ("getnames=" "(yes|no) For spreadsheets and delimited external files, determines whether to generate SAS variable names from the column names in the input file's first row of data.")
		 ("guessing rows=" "(1 to 3276) Scans data for its data type from row 1 to the row number that is specified.")
		 ("mixed=" "(yes|no) Converts numeric data values into character data values for a column that contains mixed data types.")
		 ("namerow=" "For an XLS data source, specifies the first row of data to read variable names.")
		 ("port=" "(1 to 32767) Scans data for its data type from row 1 to the row number that is specified.")
		 ("startrow=" "For an XLS data source, specifies the first row of data to be read.")
		 ("textsize=" "(1 to 32767) Specifies the field length that is allowed for importing Microsoft Excel 97, 2000, or 2002 Memo fields.")
		 ("range=" "['range-name'|'absolute-range'] Subsets a spreadsheet by identifying the rectangular set of cells to import from the specified spreadsheet.")
		 ("scantext=" "(yes|no) Scans the length of text data for a data source column and uses the length of the longest string data that it finds as the SAS column width.")
		 ("scantime=" "(yes|no) Scans all row values for a DATETIME data type field and automatically determines the TIME data type if only time values (that is, no date or datetime values) exist in the column.")
		 ("server=" "('PC-server-name') Specifies the name of the PC server.")
		 ("service=" "('service-name') Specifies the service name that is defined on your service file for your client and server machines.")
		 ("sheet=" "(spreadsheet-name) Identifies a particular spreadsheet in a group of spreadsheets.")
		 ("usedate=" "(yes|no) If USEDATE=YES, then DATE. format is used for date/time columns in the data source table while importing data from Excel workbook.")
		 ("version=" "('file-version') Specifies the version of file that you want to create with if the file does not exist on your PC server yet.")
		 ("database=" "('database') Specifies the complete path and filename of the database that contains the specified DBMS table.")
		 ("dbpwd=" "('database password') Specifies a password that allows access to a database.")
		 ("dbsaslabel=" "(compat|none) DBSASLABEL=COMPAT, column names are saved as SAS labels.  DBSASLABEL=NONE, column names are not saved.")
		 ("memosize=" "('field-length') Specifies the field length for importing Microsoft Access Memo fields.")
		 ("port=" "(1 to 3276) Scans data for its data type from row 1 to the row number that is specified.")
		 ("pwd=" "('password') Specifies the user password used by the DBMS to validate a specific userid.")
		 ("scanmemo=" "(yes|no) Scans the length of data for memo fields and uses the length of the longest string data that it finds as the SAS column width.")
		 ("scantime=" "(yes|no) Scans all row values for a DATETIME data type field and automatically determines the TIME data type if only time values.")
		 ("server=" "('PC-server-name') Specifies the name of the PC server.")
		 ("service=" "('service-name') Specifies the service name that is defined on your service file for your client and server machines.")
		 ("uid=" "('user-id') Identifies the user to the DBMS.")
		 ("wgdb=" "('workgroup-database-name') Specifies the workgroup (security) database name that contains the USERID and PWD data for the DBMS.")
		 ("usedate=" "(yes|no) If USEDATE=YES, then DATE. format is used for date/time columns in the data source table while importing data from Excel workbook.")
		 ("version=" "('file-version') Specifies the version of file that you want to create with if the file does not exist on your PC server yet.")
		 ))
    )
)

(defvar proc-format-state-options
  '(
    ("format-invalue" (
			("default=" "(#) Specify the default length of the informat")
			("fuzz=" "(#) Specify a fuzz factor for matching values to a range")
			("max=" "(#) Specify a maximum length for the informat")
			("min=" "(#) Specify a minimum length for the informat")
			("notsorted" "Store values or ranges in the order that you define them")
			("just" "Left-justify all input strings before they are compared to ranges")
			("upcase" "Uppercase all input strings before they are compared to ranges")
			("_error_" "Treats data values in the designated range as invalid data")
			("_same_" "Prevents the informat from converting the raw data as any other value")
			))
    ("format-picture" (
		       ("datatype=" "(date|time|datetime) Specify that you can use directives in the picture as a template to format date, time, or datetime values")

			))
    ("format-picture" (
		       ("datatype=" "(date|time|datetime) Specify that you can use directives in the picture as a template to format date, time, or datetime values")
		       ("default=" "(#) Specify the default length of the format")
		       ("decsep=" "Specify the separator character for the fractional part of a number")
		       ("dig3sep=" "Specify the three-digit separator character for a number")
		       ("fuzz=" "(#) Specify a fuzz factor for matching values to a range")
		       ("max=" "(#) Specify a maximum length for the format")
		       ("min=" "(#) Specify a minimum length for the format")
		       ("multilabel" "Specify multiple pictures for a given value or range and for overlapping ranges")
		       ("notsorted" "Store values or ranges in the order that you define them")
		       ("round" "Round the value to the nearest integer before formatting")
		       ("fill=" "Specify a character that completes the formatted value")
		       ("multiplier=" "(#) Specify a number to multiply the variable's value by before it is formatted")
		       ("noedit" "Specify that numbers are message characters rather than digit selectors")
		       ("prefix=" "Specify a character prefix for the formatted value")
		       ))
    ("format-value" (
		     ("default=" "(date|time|datetime) Specify the default length of the format")
		     ("fuzz=" "Specify a fuzz factor for matching values to a range")
		     ("max=" "Specify a maximum length for the format")
		     ("min=" "Specify a minimum length for the format")
		     ("multilabel" "Specify multiple values for a given range, or for overlapping ranges")
		     ("notsorted" "Store values or ranges in the order that you define them")
		     ))
    )
  )

(defvar proc-freq-state-options
'(
  ("freq.exact" (
		 ("alpha=" "(#) Specifies the level of the confidence limits for Monte Carlo p-value estimates. The value of the ALPHA= option must be between 0 and 1, and the default is 0.01")
		 ("maxtime=" "(#) Specifies the maximum clock time (in seconds) that PROC FREQ can use to compute an exact p-value")
		 ("n=" "(#) Specifies the number of samples for Monte Carlo estimation")
		 ("seed=" "(#) Specifies the initial seed for random number generation for Monte Carlo estimation")
		 ("mc" "Requests Monte Carlo estimation of exact p-values instead of direct exact p-value computation.")
		 ("point" "Requests exact point probabilities for the test statistics.")
		 ))
  ("freq-output" (
		  ("out=" "(output-data) Names the output data set.")
		  ("agree" "Mcnemar's test for 2 ×2 tables, simple kappa coefficient, and weighted kappa coefficient")
		  ("ajchi" "Continuity-adjusted chi-square for 2 ×2 tables")
		  ("all" "All statistics under CHISQ, MEASURES, and CMH, and the number of nonmissing subjects")
		  ("bdchi" "Breslow-Day test")
		  ("bin" "For one-way tables, binomial proportion statistics")
		  ("binomial" "For one-way tables, binomial proportion statistics")
		  ("chisq" "Chi-square goodness-of-fit test for one-way tables; for two-way tables")
		  ("cmh" "Cochran-Mantel-Haenszel correlation, row mean scores (ANOVA), and general association statistics")
		  ("cmh1" "Same as CMH, but excludes general association and row mean scores (ANOVA) statistics")
		  ("cmh2" "Same as CMH, but excludes the general association statistic")
		  ("cmhcor" "Cochran-Mantel-Haenszel correlation statistic")
		  ("cmhga" "Cochran-Mantel-Haenszel general association statistic")
		  ("cmhrms" "Cochran-Mantel-Haenszel row mean scores (ANOVA) statistic")
		  ("cochq" "Cochran's Q")
		  ("contgy" "Contingency coefficient")
		  ("cramv" "Cramer's V")
		  ("eqkap" "Test for equal simple kappas")
		  ("eqwkp" "Test for equal weighted kappas")
		  ("fisher" "Fisher's exact test")
		  ("exact"  "Fisher's exact test")
		  ("gamma" "Gamma")
		  ("jt" "Jonckheere-Terpstra test")
		  ("kappa" "Simple kappa coefficient")
		  ("kentb" "Kendall's tau-b")
		  ("lamcr" "Lambda asymmetric (C|R)")
		  ("lamdas" "Lambda symmetric")
		  ("lamrc" "Lambda asymmetric (R|C)")
		  ("lgor" "Adjusted logit odds ratio")
		  ("lgrrc1" "Adjusted column 1 logit relative risk")
		  ("lgrrc2" "Adjusted column 2 logit relative risk")
		  ("lrchi" "Likelihood-ratio chi-square")
		  ("mcnem" "Mcnemar's test")
		  ("measures" "Gamma, Kendall's tau-b, Stuart's tau-c, Somers' D (C|R), Somers' D (R|C), Pearson correlation coefficient, Spearman correlation coefficient, lambda asymmetric (C|R), lambda asymmetric (R|C), lambda symmetric, uncertainty coefficient (C|R), uncertainty coefficient (R|C), and symmetric uncertainty coefficient; for 2 ×2 tables, odds ratio and relative risks")
		  ("mhchi" "Mantel-Haenszel chi-square")
		  ("mhor" "Adjusted Mantel-Haenszel odds ratio")
		  ("mhrrc1" "Adjusted column 1 Mantel-Haenszel relative risk")
		  ("mhrrc2" "Adjusted column 2 Mantel-Haenszel relative risk")
		  ("n" "Number of nonmissing subjects for the stratum")
		  ("nmiss" "Number of missing subjects for the stratum")
		  ("or" "Odds ratio")
		  ("pchi" "Chi-square goodness-of-fit test for one-way tables; for two-way tables, Pearson chi-square")
		  ("pcorr" "Pearson correlation coefficient")
		  ("phi" "Phi coefficient")
		  ("plcorr" "Polychoric correlation coefficient")
		  ("rdif1" "Column 1 risk difference (row 1 - row 2)")
		  ("rdif2" "Column 2 risk difference (row 1 - row 2)")
		  ("relrisk" "Odds ratio and relative risks for 2 ×2 tables")
		  ("riskdiff" "Risks and risk differences")
		  ("riskdiff1" "Column 1 risks and risk difference")
		  ("riskdiff2" "Column 2 risks and risk difference")
		  ("rrc1" "Column 1 relative risk")
		  ("rrc2" "Column 2 relative risk")
		  ("rsk1" "Column 1 risk (overall)")
		  ("rsk11" "Column 1 risk, for row 1")
		  ("rsk12" "Column 2 risk, for row 1")
		  ("rsk2" "Column 2 risk (overall)")
		  ("rsk21" "Column 1 risk, for row 2")
		  ("rsk22" "Column 2 risk, for row 2")
		  ("scorr" "Spearman correlation coefficient")
		  ("smdcr" "Somers' D (C|R)")
		  ("smdrc" "Somers' D (R|C)")
		  ("stutc" "Stuart's tau-c")
		  ("trend" "Cochran-Armitage test for trend")
		  ("tsymm" "Bowker's test of symmetry")
		  ("u" "Symmetric uncertainty coefficient")
		  ("ucr" "Uncertainty coefficient (C|R")
		  ("urc" "Uncertainty coefficient (R|C)")
		  ("wtkap" "Weighted kappa coefficient")
		  ))
  ("freq.tables" (
		  ("agree" "Requests tests and measures of classification agreement")
		  ("all" "Requests tests and measures of association produced by CHISQ, MEASURES, and CMH")
		  ("alpha=" "(#) Sets the confidence level for confidence limits")
		  ("bdt" "Requests Tarone's adjustment for the Breslow-Day test")
		  ("binomial" "Requests binomial proportion, confidence limits and test for one-way tables")
		  ("binomialc" "Requests BINOMIAL statistics with a continuity correction")
		  ("chisq" "Requests chi-square tests and measures of association based on chi-square")
		  ("cl" "Requests confidence limits for the MEASURES statistics")
		  ("cmh" "Requests all Cochran-Mantel-Haenszel statistics")
		  ("cmh1" "Requests the CMH correlation statistic, and adjusted relative risks and odds ratios")
		  ("cmh2" "Requests CMH correlation and row mean scores (ANOVA) statistics, and adjusted relative risks and odds ratios")
		  ("converge=" "(#) Specifies convergence criterion to compute polychoric correlation")
		  ("fisher" "Requests Fisher's exact test for tables larger than 2 ×2")
		  ("jt" "Requests Jonckheere-Terpstra test")
		  ("maxiter=" "(#) Specifies maximum number of iterations to compute polychoric correlation")
		  ("measures" "Requests measures of association and their asymptotic standard errors")
		  ("missing" "Treats missing values as nonmissing")
		  ("plcorr" "Requests polychoric correlation")
		  ("relrisk" "Requests relative risk measures for 2 ×2 tables")
		  ("riskdiff" "Requests risks and risk differences for 2 ×2 tables")
		  ("riskdiffc" "Requests RISKDIFF statistics with a continuity correction")
		  ("scores=" "(modridit|rank|ridit|table) Specifies the type of row and column scores")
		  ("testf=(/**/)" "Specifies expected frequencies for a one-way table chi-square test")
		  ("testp=(/**/)" "Specifies expected proportions for a one-way table chi-square test")
		  ("trend" "Requests Cochran-Armitage test for trend")
		  ("cellchi2" "Displays each cell's contribution to the total Pearson chi-square statistic")
		  ("cumcol" "Displays the cumulative column percentage in each cell")
		  ("deviation" "Displays the deviation of the cell frequency from the expected value for each cell")
		  ("expected" "Displays the expected cell frequency for each cell")
		  ("missprint" "Displays missing value frequencies")
		  ("sparse" "Lists all possible combinations of variable levels even when a combination does not occur")
		  ("totpct" "Displays percentage of total frequency on n-way tables when n>2")
		  ("contents=" "Specifies the HTML contents link for crosstabulation tables")
		  ("crosslist" "Displays crosstabulation tables in ODS column format")
		  ("format=" "(format) Formats the frequencies in crosstabulation tables")
		  ("list" "Displays two-way to n-way tables in list format")
		  ("nocol" "Suppresses display of the column percentage for each cell")
		  ("nocum" "Suppresses display of cumulative frequencies and cumulative percentages in one-way frequency tables and in list format")
		  ("nofreq" "Suppresses display of the frequency count for each cell")
		  ("nopercent" "Suppresses display of the percentage, row percentage, and column percentage in crosstabulation tables, or percentages and cumulative percentages in one-way frequency tables and in list format")
		  ("noprint" "Suppresses display of tables but displays statistics")
		  ("norow" "Suppresses display of the row percentage for each cell")
		  ("nosparse" "Suppresses zero cell frequencies in the list display and in the OUT= data set when ZEROS is specified")
		  ("nowarn" "Suppresses log warning message for the chi-square test")
		  ("printkwt" "Displays kappa coefficient weights")
		  ("scorout" "Displays the row and the column scores")
		  ("out=" "(output-data) Specifies an output data set to contain variable values and frequency counts")
		  ("outcum" "Includes the cumulative frequency and cumulative percentage in the output data set for one-way tables")
		  ("outexpect" "Includes the expected frequency of each cell in the output data set")
		  ("outpct" "Includes the percentage of column frequency, row frequency, and two-way table frequency in the output data set")
		  ))
  ("freq-test" (
		("agree" "Simple kappa coefficient and weighted kappa coefficient")
		("gamma" "Gamma")
		("kappa" "Simple kappa coefficient")
		("kentb" "Kendall's tau-b")
		("measures" "Gamma, Kendall's tau-b, Stuart's tau-c, Somers' D (C|R), Somers' D (R|C), the Pearson correlation, and the Spearman correlation")
		("pcorr" "Pearson correlation coefficient")
		("scorr" "Spearman correlation coefficient")
		("smdcr" "Somers' D (C|R)")
		("smdrc" "Somers' D (R|C")
		("stutc" "Stuart's tau-c")
		("wtkap" "Weighted kappa coefficient")
		))
  ( "freq.weight" (
		   ("zeros" "Includes observations with zero weight values. By default, PROC FREQ ignores observations with zero weights")
		   ))
  )
)
(defvar proc-plot-state-options
  '(
    ("plot.plot" (
		  ("box" "Draws a border around the entire plot, rather than just on the left side and bottom.")
		  ("hexpand" "Expands the horizontal axis to minimize the margins at the sides of the plot and to maximize the distance between tick marks, if possible.")
		  ("hreverse" "Reverses the order of the values on the horizontal axis.")
		  ("hzero" "Assigns a value of zero to the first tick mark on the horizontal axis.")
		  ("overlay" "Overlays all plots that are specified in the PLOT statement on one set of axes.")
		  ("states" "Lists all the placement states in effect.")
		  ("vexpand" "Expands the vertical axis to minimize the margins above and below the plot and to maximize the space between vertical tick marks, if possible.")
		  ("vreverse" "Reverses the order of the values on the vertical axis.")
		  ("vzero" "Assigns a value of zero to the first tick mark on the vertical axis.")
		  ("contour" "Draws a contour plot using plotting symbols with varying degrees of shading where number-of-levels is the number of levels for dividing the range of variable")
		  ("contour=" "(#) Draws a contour plot using plotting symbols with varying degrees of shading where number-of-levels is the number of levels for dividing the range of variable")
		  ("haxis=" "(axis-expression) Specifies the tick-mark values for the horizontal axis.")
		  ("hpos=" "(#) Specifies the number of print positions on the horizontal axis.")
		  ("href=" "(value-specification) Draws lines on the plot perpendicular to the specified values on the horizontal axis.")
		  ("hrefchar=" "Specifies the character to use to draw the horizontal reference line.")
		  ("hspace=" "(#) Specifies that a tick mark will occur on the horizontal axis at every nth print position, where n is the value of HSPACE=.")
		  ("list" "Lists the horizontal and vertical axis values, the penalty, and the placement state of all points plotted with a penalty greater than or equal to penalty-value.")
		  ("list=" "(#) Lists the horizontal and vertical axis values, the penalty, and the placement state of all points plotted with a penalty greater than or equal to penalty-value.")
		  ("penalties /**/ =" "(penalty-list) Changes the default penalties. The index-list provides the positions of the penalties in the list of penalties.")
		  ("placement=(H=/**/ L= S= V=)" "((expression(s))) Controls the placement of labels by specifying possible locations of the labels relative to their coordinates.")
		  ("outward=" "('character') Tries to force the point labels outward, away from the origin of the plot, by protecting positions next to symbols that match character that are in the direction of the origin (0,0).")
		  ("split=" "('split-character') When labeling plot points, specifies where to split the label when the label spans two or more lines.")
		  ("vaxis=" "(axis-specification) Specifies tick mark values for the vertical axis.")w
		  ("vpos=" "(axis-length) Specifies the number of print positions on the vertical axis.")
		  ("vref=" "(value-specification) Draws lines on the plot perpendicular to the specified values on the vertical axis.")
		  ("vrefchar=" "('character') Specifies the character to use to draw the vertical reference lines.")
		  ("vspace=" "(#) Specifies that a tick mark will occur on the vertical axis at every nth print position, where n is the value of VSPACE=.")
		  ))
    )
)



(defvar proc-print-state-options
  '(
    ("print.id" (
		("style /**/ =" "Specifies the style element to use for ID columns created with the ID statement")
		))
    ("print.sum" (
		("style /**/ =" "Specifies the style element to use for ID columns created with the ID statement")
		))
    ("print.var" (
		("style /**/ =" "Specifies the style element to use for ID columns created with the ID statement")
		))
    )
  )
(defvar proc-rank-state-options
  '(
    )
  )

(defvar proc-sort-state-options
  '(
    )
  )


(defvar proc-standard-state-options
  '(
    )
  )

(defvar proc-summary-state-options
  '(
    ("summary.class" (
		      ("ascending" "Specifies to sort the class variable levels in ascending order.")
		      ("descending" "Specifies to sort the class variable levels in descending order.")
		      ("exclusive" "Excludes from the analysis all combinations of the class variables that are not found in the preloaded range of user-defined formats.")
		      ("groupinternal" "Specifies not to apply formats to the class variables when PROC MEANS groups the values to create combinations of class variables.")
		      ("missing" "Considers missing values as valid values for the class variable levels.")
		      ("mlf" "Enables PROC MEANS to use the primary and secondary format labels for a given range or overlapping ranges to create subgroup combinations when a multilabel format is assigned to a class variable.")
		      ("preloadfmt" "Specifies that all formats are preloaded for the class variables.")
		      ("order=" "(data|formatted|freq|unformatted) Specifies the order to group the levels of the class variables in the output.")
		      ))
    ("summary.output" (
		       ("autolabel" "Specifies that PROC MEANS appends the statistic name to the end of the variable label.")
		       ("autoname" "Specifies that PROC MEANS creates a unique variable name for an output statistic when you do not explicitly assign the variable name.")
		       ("keeplen" "Specifies that statistics in the output data set inherit the length of the analysis variable that PROC MEANS uses to derive them.")
		       ("levels" "Includes a variable named _LEVEL_ in the output data set.")
		       ("noinherit" "Specifies that the variables in the output data set that contain statistics do not inherit the attributes (label and format) of the analysis variables which are used to derive them.")
		       ("ways" "Includes a variable named _WAY_ in the output data set.")
		       ))
    ("summary-output" (
		       ("out=" "(output-data) Names the new output data set.")
;; descriptive statistics
		       ("css" "Sum of squares corrected for the mean.")
		       ("cv" "Is the percent coefficient of variation.")
		       ("max" "Is the maximum value.")
		       ("mean" "Is the arithmetic mean.")
		       ("min" "Is the minimum value.")
		       ;;		("mode" "Is the most frequent value.")
		       ("n" "Is the number of [equation] values that are not missing.")
		       ("nmiss" "Is the number of [equation] values that are missing.")
		       ("nobs" "Is the total number of observations and is calculated as the sum of N and NMISS.")
		       ("range" "Is the range and is calculated as the difference between maximum value and minimum value.")
		       ("sum" "Is the sum.")
		       ("sumwgt" "Is the sum of the weights.")
		       ("uss" "Is the uncorrected sum of squares.")
		       ("var" "Is the variance.")
		       ("kurtosis" "Is the kurtosis, which measures heaviness of tails")
		       ("kurt" "Is the kurtosis, which measures heaviness of tails")
		       ("skewness" "Is skewness, which measures the tendency of the deviations to be larger in one direction than in the other")
		       ("skew" "Is skewness, which measures the tendency of the deviations to be larger in one direction than in the other")
		       ("stddev" "is the standard deviation")
		       ("std" "is the standard deviation")
		       ("stderr" "Is the standard error of the mean")
		       ("stdmean" "Is the standard error of the mean")
		       ;; Quantile Stats
		       ("median" "Is the middle value.")
		       ("p1" "Is the 1st percentile.")
		       ("p5" "Is the 5th percentile.")
		       ("p10" "Is the 10th percentile.")
		       ("p90" "Is the 90th percentile.")
		       ("p95" "Is the 95th percentile.")
		       ("p99" "Is the 99th percentile.")
		       ("q1" "Is the lower quartile (25th percentile).")
		       ("q3" "Is the upper quartile (75th percentile).")
		       ("qrange" "Is interquartile range.")
		       ;; Hypothesis testing stats
		       ("t" "Is the Student's t statistic.")
		       ("probt" "Is the two-tailed p-value for Student's t statistic.")
		       ;; Confidence Limits for the mean
		       ("clm" "Is the two-sided confidence limit for the mean.")
		       ("lclm" "Is the one-sided confidence limit below the mean.")
		       ("uclm" "Is the one-sided confidence limit above the mean.")
		       ;; End Stats
		       ))
    ("summary.var" (
		    ("weight=" "(variable) Specifies a numeric variable whose values weight the values of the variables that are specified in the VAR statement.")
		    ))
    )
  )

(defvar proc-means-state-options
  '(
    ("means.class" (
		      ("ascending" "Specifies to sort the class variable levels in ascending order.")
		      ("descending" "Specifies to sort the class variable levels in descending order.")
		      ("exclusive" "Excludes from the analysis all combinations of the class variables that are not found in the preloaded range of user-defined formats.")
		      ("groupinternal" "Specifies not to apply formats to the class variables when PROC MEANS groups the values to create combinations of class variables.")
		      ("missing" "Considers missing values as valid values for the class variable levels.")
		      ("mlf" "Enables PROC MEANS to use the primary and secondary format labels for a given range or overlapping ranges to create subgroup combinations when a multilabel format is assigned to a class variable.")
		      ("preloadfmt" "Specifies that all formats are preloaded for the class variables.")
		      ("order=" "(data|formatted|freq|unformatted) Specifies the order to group the levels of the class variables in the output.")
		      ))
    ("means.output" (
		       ("autolabel" "Specifies that PROC MEANS appends the statistic name to the end of the variable label.")
		       ("autoname" "Specifies that PROC MEANS creates a unique variable name for an output statistic when you do not explicitly assign the variable name.")
		       ("keeplen" "Specifies that statistics in the output data set inherit the length of the analysis variable that PROC MEANS uses to derive them.")
		       ("levels" "Includes a variable named _LEVEL_ in the output data set.")
		       ("noinherit" "Specifies that the variables in the output data set that contain statistics do not inherit the attributes (label and format) of the analysis variables which are used to derive them.")
		       ("ways" "Includes a variable named _WAY_ in the output data set.")
		       ))
    ("means-output" (
		       ("out=" "(output-data) Names the new output data set.")
;; descriptive statistics
		       ("css" "Sum of squares corrected for the mean.")
		       ("cv" "Is the percent coefficient of variation.")
		       ("max" "Is the maximum value.")
		       ("mean" "Is the arithmetic mean.")
		       ("min" "Is the minimum value.")
		       ;;		("mode" "Is the most frequent value.")
		       ("n" "Is the number of [equation] values that are not missing.")
		       ("nmiss" "Is the number of [equation] values that are missing.")
		       ("nobs" "Is the total number of observations and is calculated as the sum of N and NMISS.")
		       ("range" "Is the range and is calculated as the difference between maximum value and minimum value.")
		       ("sum" "Is the sum.")
		       ("sumwgt" "Is the sum of the weights.")
		       ("uss" "Is the uncorrected sum of squares.")
		       ("var" "Is the variance.")
		       ("kurtosis" "Is the kurtosis, which measures heaviness of tails")
		       ("kurt" "Is the kurtosis, which measures heaviness of tails")
		       ("skewness" "Is skewness, which measures the tendency of the deviations to be larger in one direction than in the other")
		       ("skew" "Is skewness, which measures the tendency of the deviations to be larger in one direction than in the other")
		       ("stddev" "is the standard deviation")
		       ("std" "is the standard deviation")
		       ("stderr" "Is the standard error of the mean")
		       ("stdmean" "Is the standard error of the mean")
		       ;; Quantile Stats
		       ("median" "Is the middle value.")
		       ("p1" "Is the 1st percentile.")
		       ("p5" "Is the 5th percentile.")
		       ("p10" "Is the 10th percentile.")
		       ("p90" "Is the 90th percentile.")
		       ("p95" "Is the 95th percentile.")
		       ("p99" "Is the 99th percentile.")
		       ("q1" "Is the lower quartile (25th percentile).")
		       ("q3" "Is the upper quartile (75th percentile).")
		       ("qrange" "Is interquartile range.")
		       ;; Hypothesis testing stats
		       ("t" "Is the Student's t statistic.")
		       ("probt" "Is the two-tailed p-value for Student's t statistic.")
		       ;; Confidence Limits for the mean
		       ("clm" "Is the two-sided confidence limit for the mean.")
		       ("lclm" "Is the one-sided confidence limit below the mean.")
		       ("uclm" "Is the one-sided confidence limit above the mean.")
		       ;; End Stats
		       ))
    ("means.var" (
		    ("weight=" "(variable) Specifies a numeric variable whose values weight the values of the variables that are specified in the VAR statement.")
		    ))
    )
  )

(defvar proc-tabulate-state-options
  '(
     ("tabulate.class" (
			("ascending" "Specifies to sort the class variable values in ascending order.")
			("descending" "Specifies to sort the class variable values in descending order.")
			("exclusive" "Excludes from tables and output data sets all combinations of class variables that are not found in the preloaded range of user-defined formats.")
			("groupinternal" "Specifies not to apply formats to the class variables when PROC TABULATE groups the values to create combinations of class variables.")
			("missing" "Considers missing values as valid class variable levels.")
			("mlf" "Enables PROC TABULATE to use the format label or labels for a given range or overlapping ranges to create subgroup combinations when a multilabel format is assigned to a class variable.")
			("preloadfmt" "Specifies that all formats are preloaded for the class variable.")
			("order=" "(data|formatted|freq|unformatted) Specifies the order to group the levels of the class variables in the output.")
			("style=" "Specifies the style element to use for page dimension text and class variable name headings.")
			))
     ("tabulate.classlev" (
			   ("style=" "Specifies the style element to use for page dimension text and class variable name headings.")
			   ))
     ("tabulate.keyword" (
			   ("style=" "Specifies the style element to use for page dimension text and class variable name headings.")
			   ))
     ("tabulate.table" (
			("box=" "Specifies text and a style element for the empty box above the row titles")
			("condense" "Prints as many complete logical pages as possible on a single printed page or, if possible, prints multiple pages of tables that are too wide to fit on a page one below the other on a single page, instead of on separate pages.")
			("misstext=" "('text') Supplies up to 256 characters of text to print and specifies a style element for table cells that contain missing values")
			("nocontinued" "Suppresses the continuation message, continued , that is displayed at the bottom of tables that span multiple pages.")
			("printmiss" "Prints all values that occur for a class variable each time headings for that variable are printed, even if there are no data for some of the cells that these headings create.")
			("style=" "Specifies the style element to use for page dimension text and class variable name headings.")
			("contents=" "(link-name) Enables you to name the link in the HTML table of contents.")
			("fuzz=" "(#) Supplies a numeric value against which analysis variable values and table cell values other than frequency counts are compared to eliminate trivial values.")
			("indent=" "(#) Specifies the number of spaces to indent nested row headings, and suppresses the row headings for class variables.")
			("row=" "(constant|float) Specifies whether all title elements in a row crossing are allotted space even when they are blank.")
			("rtspace=" "(#) Specifies the number of print positions to allot to all of the headings in the row dimension, including spaces that are used to print outlining characters for the row headings.")
			("style_precedence=" "(page|row|column|col) Specifies whether the style that is specified for the page dimension.")
			))
     ("tabulate.var" (
		      ("weight=" "(variable) Specifies a numeric variable whose values weight the values of the variables that are specified in the VAR statement.")
		      ))
     )
)

(defvar proc-timeplot-state-options
  '(
    ("timeplot-plot" (
		      ("/**/" "([variable]|[variable='']|[variable=])")
		      ))
    ("timeplot-class" (
		       ("/**/" "(variable)")
		       ))
    ("timeplot.plot" (
		      ("axis=" "(axis-expression) Specifies the range of values to plot on the horizontal axis.")
		      ("ovpchar='/**/'" "('character') Specifies the character to print if multiple plotting symbols coincide.")
		      ("pos=" "(#) Specifies the number of print positions to use for the horizontal axis.")
		      ("ref=" "(reference-value(s)) Draws lines on the plot that are perpendicular to the specified values on the horizontal axis.")
		      ("refchar='/**/'" "('character') Specifies the character for drawing reference lines.")
		      ("hiloc" "Connects the leftmost plotting symbol to the rightmost plotting symbol with a line of hyphens.")
		      ("joinref" "Connects the leftmost and rightmost symbols on each line of the plot with a line of hyphens.")
		      ("nosymname" "Suppresses the name of the symbol variable in column headings when you use a CLASS statement.")
		      ("npp" "Suppresses the listing of the values of the variables that appear in the PLOT statement.")
		      ("overlay" "Plots all requests in one PLOT statement on one set of axes.")
		      ("reverse" "Orders the values on the horizontal axis with the largest value in the leftmost position.")
		      ))
    )
  )
(defvar proc-transpose-state-options
  '(
    ("transpose-copy" (
		       ("/**/" "(variable)")
		       ))
    ("transpose-idlabel" (
			  ("/**/" "(variable)")
			  ))
    )
)
(defvar proc-univariate-state-options
  '(
    ("univariate-class" (
			 ("missing" "Specifies that missing values for the CLASS variable are to be treated as valid classification levels")
			 ("order=" "(data|formatted|freq|internal) Specifies the display order for the class variable values")
			 ("/**/" "(variable) One or two variables that the procedure uses to group the data into classification levels")
			 ))
    ("univariate-freq" (
			("/**/" "(variable) Numeric variable whose value represents the frequency of the observation")
			 ))
    ("univariate-id" (
		      ("/**/" "(variable) One or more variables to include in the table of extreme observations")
		      ))
    ("univariate-inset" (
			 ("css" "Corrected sum of squares")
			 ("cv" "Coefficient of variation")
			 ("kurtosis" "Kurtosis")
			 ("max" "Largest value")
			 ("mean" "Sample mean")
			 ("min" "Smallest value")
			 ("mode" "Most frequent value")
			 ("n" "Sample size")
			 ("nmiss" "Number of missing values")
			 ("nobs" "Number of observations")
			 ("range" "Range")
			 ("skewness" "Skewness")
			 ("std" "Standard deviation")
			 ("stdmean" "Standard error of the mean")
			 ("sum" "Sum of the observations")
			 ("sumwgt" "Sum of the weights")
			 ("uss" "Uncorrected sum of squares")
			 ("var" "Variance")
			 ("p1" "1st percentile")
			 ("p5" "5th percentile")
			 ("p10" "10th percentile")
			 ("q1" "Lower quartile (25th percentile)")
			 ("median" "Median (50th percentile)")
			 ("q3" "Upper quartile (75th percentile)")
			 ("p90" "90th percentile")
			 ("p95" "95th percentile")
			 ("p99" "99th percentile")
			 ("qrange" "Interquartile range (Q3 - Q1)")
			 ("gini" "Gini's mean difference")
			 ("mad" "Median absolute difference about the median")
			 ("qn" "Qn, alternative to MAD")
			 ("sn" "Sn, alternative to MAD")
			 ("std_gini" "Gini's standard deviation")
			 ("std_mad" "MAD standard deviation")
			 ("std_qn" "Qn standard deviation")
			 ("std_qrange" "Interquartile range standard deviation")
			 ("std_sn" "Sn standard deviation")
			 ("msign" "Sign statistic")
			 ("normaltest" "Test statistic for normality")
			 ("pnormal" "Probability value for the test of normality")
			 ("signrank" "Signed rank statistic")
			 ("probm" "Probability of greater absolute value for the sign statistic")
			 ("probn" "Probability value for the test of normality")
			 ("probs" "Probability value for the signed rank test")
			 ("probt" "Probability value for the Student's t test")
			 ("t" "Statistics for Student's t test")
			 ("beta (alpha=/**/ beta= sigma= theta= mean= std=)" "Beta")
			 ("exponential (sigma=/**/ theta= mean= std=)" "Exponential")
			 ("gamma (alpha=/**/ sigma= theta= mean= std=)" "Gamma")
			 ("lognormal (sigma=/**/ theta= zeta= mean= std=)" "Lognormal")
			 ("normal (mean=/**/ std=)" "Normal")
			 ("weibull (c=/**/ sigma= theta= mean= std=)" "Weibull(3-parameter)")
			 ("weibull2 (c=/**/ sigma= theta= mean= std=)" "Weibull(2-parameter)")
			 ("kernel (type=/**/ bandwidth= c= amise=)" "Displays statistics for all kernel estimates")
			 ("kernel1 (type=/**/ bandwidth= c= amise=)" "Displays statistics for only the 1st kernel density estimate")
			 ("kernel2 (type=/**/ bandwidth= c= amise=)" "Displays statistics for only the 2nd kernel density estimate")
			 ("kernel3 (type=/**/ bandwidth= c= amise=)" "Displays statistics for only the 3rd kernel density estimate")
			 ("kernel4 (type=/**/ bandwidth= c= amise=)" "Displays statistics for only the 4th kernel density estimate")
			 ("kernel5 (type=/**/ bandwidth= c= amise=)" "Displays statistics for only the 5th kernel density estimate")
			 ("alpha=" "First shape parameter alpha")
			 ("shape1=" "First shape parameter")
			 ("beta=" "Second shape parameter beta")
			 ("shape2=" "Second shape parameter")
			 ("sigma=" "Scale parameter sigma")
			 ("scale=" "Scale parameter")
			 ("theta=" "Lower threshold parameter theta")
			 ("threshold=" "Lower threshold parameter")
			 ("mean=" "Mean of the fitted distribution")
			 ("std=" "Standard deviation of the fitted distribution")
			 ("zeta" "Scale parameter zeta")
			 ("type=" "(normal|quadratic|triangular) Kernel type")
			 ("bandwidth=" "Bandwidth lambda for the density estimate")
			 ("bwidth=" "Alias for BANDWIDTH")
			 ("c=" "Standardized bandwidth c / shape parameter")
			 ("amise=" "Approximate mean integrated square error (MISE) for the kernel density")
			 ("ad" "Anderson-Darling EDF test statistic")
			 ("adpval" "Anderson-Darling EDF test p-value")
			 ("cvm" "Cramér-von Mises EDF test statistic")
			 ("cvmpval" "Cramér-von Mises EDF test p-value")
			 ("ksd" "Kolmogorov-Smirnov EDF test statistic")
			 ("ksdpval" "Kolmogorov-Smirnov EDF test p-value")
			 ))
    ("univariate.class" (
			 ("keylevel=" "[value1|( value1 value2 )] Specifies the key cell in a comparative plot.")
			 )
     )
    ("univariate-histogram" (
			     ("/**/" "(variable) Variables for which histograms are to be created")
			     ))
    ("univariate.histogram" (
			     ("alpha=" "(#) Specifies the shape parameter alpha for fitted curves requested with the BETA and GAMMA options")
			     ("barwidth=" "(#) Specifies the width of the histogram bars in screen percent units")
			     ("c=" "(#) Specifies the shape parameter c for Weibull density curves requested with the WEIBULL option. Enclose the C= Weibull-option in parentheses after the WEIBULL option. ")
			     ("cbarline=" "(color) Specifies the color for the outline of the histogram bars. ")
			     ("cfill=" "(color) Specifies the color to fill the bars of the histogram ")
			     ("cframe=" "(color) Specifies the color for the area that is enclosed by the axes and frame.")
			     ("cframeside=" "(color) Specifies the color to fill the frame area for the row labels that display along the left side of the comparative histogram")
			     ("cframetop=" "(color) Specifies the color to fill the frame area for the column labels that display across the top of the comparative histogram")
			     ("cgrid=" "(color) Specifies the color for grid lines when a grid displays on the histogram")
			     ("color=" "(color) Specifies the color of the density curve. Enclose the COLOR= option in parentheses after the distribution option or the KERNEL option")
			     ("cprop=" "([color]|empty) Specifies the color for a horizontal bar whose length (relative to the width of the tile) indicates the proportion of the total frequency that is represented by the corresponding cell in a comparative histogram")
			     ("ctextside=" "(color) Specifies the color for the row labels that display along the left side of the comparative histogram")
			     ("ctexttop=" "(color) Specifies the color for the column labels that display along the left side of the comparative histogram.")
			     ("endpoints=" "[=values|KEY|UNIFORM] Uses the endpoints as the tick mark values for the horizontal axis and determines how to compute the bin width of the histogram bars")
			     ("font=" "(font) Specifies a software font for reference line and axis labels")
			     ("height=" "(#) Specifies the height, in percentage screen units, of text for axis labels, tick mark labels, and legends")
			     ("hoffset=" "(#) Specifies the offset, in percentage screen units, at both ends of the horizontal axis.")
			     ("href=" "(#) Draws reference lines that are perpendicular to the horizontal axis at the values that you specify")
			     ("hreflabpos=" "(1|2|3) Specifies the vertical position of HREFLABELS= labels")
			     ("infont=" "(font) Specifies a software font to use for text inside the framed areas of the histogram.")
			     ("inheight=" "(#) Specifies the height, in percentage screen units, of text used inside the framed areas of the histogram")
			     ("intertile=" "(#) Specifies the distance, in horizontal percentage screen units, between the framed areas, which are called tiles")
			     ("k=" "(normal|quadratic|triangular) Specifies the kernel function (normal, quadratic, or triangular) used to compute a kernel density estimate")
			     ("l=" "(linetype) Specifies the line type used for fitted density curves")
			     ("lgrid=" "(linetype) Specifies the line type for the grid when a grid displays on the histogram")
			     ("lower=" "(#) Specifies lower bounds for kernel density estimates requested with the KERNEL option. ")
			     ("maxnbin=" "(#) Specifies the maximum number of bins displayed in the comparative histogram")
			     ("maxsigmas=" "(#) Limits the number of bins displayed in the comparative histogram to a range of value standard deviations (of the data in the key cell) above and below the mean of the data in the key cell")
			     ("midpoints=" "[values|KEY|UNIFORM] Specifies how to determine the midpoints for the histogram intervals, where values determines the width of the histogram bars as the difference between consecutive midpoints")
			     ("mu=" "(#) Specifies the parameter mu for normal density curves requested with the NORMAL option.")
			     ("name=" "('string') Specifies a name for the plot, up to eight characters long,")
			     ("pfill=" "(pattern) Specifies a pattern used to fill the bars of the histograms")
			     ("scale=" "(#) Is an alias for the SIGMA= option for curves requested by the BETA, EXPONENTIAL, GAMMA, and WEIBULL options and an alias for the ZETA= option for curves requested by the LOGNORMAL option")
			     ("shape=" "(#) Is an alias for the ALPHA= option for curves requested with the GAMMA option, an alias for the SIGMA= option for curves requested with the LOGNORMAL option, and an alias for the C= option for curves requested with the WEIBULL option. ")
			     ("sigma=" "[value|EST] Specifies the parameter sigma for the fitted density curve when you request the BETA, EXPONENTIAL, GAMMA, LOGNORMAL, NORMAL, and WEIBULL options.")
			     ("theta=" "[value|EST] Specifies the lower threshold parameter theta for curves requested with the BETA, EXPONENTIAL, GAMMA, LOGNORMAL, and WEIBULL options.")
			     ("threshold=" "Is an alias for the THETA= option.")
			     ("upper=" "(#) Specifies upper bounds for kernel density estimates requested with the KERNEL option")
			     ("vaxis=" "[name|value-list] Specifies the name of an AXIS statement describing the vertical axis.")
			     ("vaxislabel=" "('label') Specifies a label for the vertical axis")
			     ("voffset=" "(#) Specifies the offset, in percentage screen units, at the upper end of the vertical axis. ")
			     ("vref=" "(value-list) Draws reference lines perpendicular to the vertical axis at the values specified. Also see the CVREF=, LVREF=, and VREFCHAR= options.")
			     ("vreflabpos=" "(#) Specifies the horizontal position of VREFLABELS= labels.")
			     ("vscale=" "(count|percent|proportion) Specifies the scale of the vertical axis for a histogram.")
			     ("w=" "(#) Specifies the width, in pixels, of the fitted density curve or the kernel density estimate curve.")
			     ("waxis=" "(#) Specifies the line thickness, in pixels, for the axes and frame")
			     ("wbarline=" "(#) Specifies the width of bar outlines.")
			     ("wgrid=" "(#) Specifies the line thickness for the grid.")
			     ("zeta=" "(#) Specifies a value for the scale parameter zeta for lognormal density curves requested with the LOGNORMAL option.")
			     ("annotate=" "(data) Specifies an input data set containing annotate variables")
			     ("anno=" "(data) Speifies an input data set containing annotate variables")
			     ("beta=" "(#) Specifies the second shape parameter beta for beta density curves requested with the BETA option")
			     ("b=" "(#) Specifies the second shape parameter beta for beta density curves requested with the BETA option")
			     ("ctext=" "(color) Specifies the color for tick mark values and axis labels")
			     ("ct=" "(color) Specifies the color for tick mark values and axis labels")
			     ("cvref=" "(color) Specifies the color for lines requested with the VREF= option.")
			     ("cv=" "(color) Specifies the color for lines requested with the VREF= option.")
			     ("description=" "('string') Specifies a description, up to 40 characters long, that appears in the PROC GREPLAY master menu.")
			     ("des=" "('string') Specifies a description, up to 40 characters long, that appears in the PROC GREPLAY master menu.")
			     ("lhref=" "(linetype) Specifies the line type for the reference lines that you request with the HREF= option")
			     ("lh=" "(linetype) Specifies the line type for the reference lines that you request with the HREF= option")
			     ("lvref=" "(linetype) Specifies the line type for lines requested with the VREF= option.")
			     ("lv=" "(linetype) Specifies the line type for lines requested with the VREF= option.")
			     ("ncols=" "(#) Specifies the number of columns in a comparative histogram")
			     ("ncol=" "(#) Specifies the number of columns in a comparative histogram")
			     ("nrows=" "(#) Specifies the number of rows in a comparative histogram")
			     ("nrow=" "(#) Specifies the number of rows in a comparative histogram")
			     ("outhistogram=" "(ouput-data) Creates a SAS data set that contains information about histogram intervals")
			     ("outhist=" "(output-data) Creates a SAS data set that contains information about histogram intervals")
			     ("percents=" "(#) Specifies a list of percents for which quantiles calculated from the data and quantiles estimated from the fitted curve are tabulated. ")
			     ("percent=" "(#) Specifies a list of percents for which quantiles calculated from the data and quantiles estimated from the fitted curve are tabulated. ")
			     ("vminor=" "(#) Specifies the number of minor tick marks between each major tick mark on the vertical axis.")
			     ("vm=" "(#) Specifies the number of minor tick marks between each major tick mark on the vertical axis.")
			     ("caxis=" "(color) Specifies the color for the axes and tick marks.")
			     ("caxes=" "(color) Specifies the color for the axes and tick marks.")
			     ("ca=" "(color) Specifies the color for the axes and tick marks.")
			     ("hreflabels=" "('label1' ... ' labeln') Specifies labels for the lines requested by the HREF= option.")
			     ("hreflabel=" "('label1' ... ' labeln') Specifies labels for the lines requested by the HREF= option.")
			     ("hreflab=" "('label1' ... ' labeln') Specifies labels for the lines requested by the HREF= option.")
			     ("vreflabels=" "('label1'... 'labeln') Specifies labels for the lines requested by the VREF= option. ")
			     ("vreflabel=" "('label1'... 'labeln') Specifies labels for the lines requested by the VREF= option. ")
			     ("vreflab=" "('label1'... 'labeln') Specifies labels for the lines requested by the VREF= option. ")
			     ("annokey" "Applies the annotation requested with the ANNOTATE= option to the key cell only.")
			     ("beta(/**/)" "Displays a fitted beta density curve on the histogram")
			     ("endpoints=" "[values|KEY|UNIFORM] Uses the endpoints as the tick mark values for the horizontal axis and determines how to compute the bin width of the histogram bars")
			     ("exp(/**/)" "(exponential-options) Displays a fitted exponential density curve on the histogram")
			     ("fill" "Fills areas under the fitted density curve or the kernel density estimate with colors and patterns. ")
			     ("forcehist" "Forces the creation of a histogram if there is only one unique observation")
			     ("frontref" "Draws reference lines requested with the HREF= and VREF= options in front of the histogram bars")
			     ("gamma()" "(gamma-options) Displays a fitted gamma density curve on the histogram")
			     ("grid" "Displays a grid on the histogram.")
			     ("kernel()" "(kernel-options) Superimposes up to five kernel density estimates on the histogram")
			     ("lognormal()" "(lognormal-options) Displays a fitted lognormal density curve on the histogram")
			     ("midpercents" "Requests a table listing the midpoints and percentage of observations in each histogram interval.")
			     ("nobars" "Suppresses drawing of histogram bars, which is useful for viewing fitted curves only. ")
			     ("noframe" "Suppresses the frame around the subplot area")
			     ("nohlabel" "Suppresses the label for the horizontal axis. You can use this option to reduce clutter")
			     ("noplot" "Suppresses the creation of a plot.")
			     ("noprint" "Suppresses tables summarizing the fitted curve")
			     ("nochart" "Suppresses the creation of a plot.")
			     ("normal()" "(normal-options) Displays a fitted normal density curve on the histogram")
			     ("novlabel" "Suppresses the label for the vertical axis.")
			     ("novtick" "Suppresses the tick marks and tick mark labels for the vertical axis")
			     ("rtinclude" "Includes the right endpoint of each histogram interval in that interval.")
			     ("turnvlabels" "Turns the characters in the vertical axis labels so that they display vertically")
			     ("turnvlabel" "Turns the characters in the vertical axis labels so that they display vertically")
			     )
     )
    ("univariate.inset" (
			 ("cfill=" "([color]|blank) Specifies the color of the background")
			 ("cfillh=" "(color) Specifies the color of the header background")
			 ("cframe=" "(color) Specifies the color of the frame")
			 ("cheader=" "(color) Specifies the color of the header text.")
			 ("cshadow=" "(color) Specifies the color of the drop shadow")
			 ("ctext=" "(color) Specifies the color of the text.")
			 ("data=" "(data) Requests that PROC UNIVARIATE display customized statistics from a SAS data set in the inset table")
			 ("font=" "(font) Specifies the font of the text")
			 ("format=" "(format) Specifies a format for all the values in the inset.")
			 ("header=" "(string) Specifies the header text. ")
			 ("height=" "(value) Specifies the height")
			 ("refpoint=" "(br|bl|tr|tl) Specifies the reference point for an inset that PROC UNIVARIATE positions by a pair of coordinates with the POSITION= option")
			 ("position=" "Determines the position of the inset")
			 ("pos=" "Determines the position of the inset")
			 ("data" "Specifies that data coordinates are to be used in positioning the inset with the POSITION= option")
			 ("noframe" "Suppresses the frame drawn around the text")
			 )
     )
    ("univariate-output" (
			  ("out=" "(output-data) Identifies the output data set")
			  ("css=" "(new-variable) Corrected sum of squares")
			  ("cv=" "(new-variable) Coefficient of variation")
			  ("kurtosis=" "(new-variable) Kurtosis")
			  ("max=" "(new-variable) Largest value")
			  ("mean=" "(new-variable) Sample mean")
			  ("min=" "(new-variable) Smallest value")
			  ("mode=" "(new-variable) Most frequent value")
			  ("n=" "(new-variable) Sample size")
			  ("nmiss=" "(new-variable) Number of missing values")
			  ("nobs=" "(new-variable) Number of observations")
			  ("range=" "(new-variable) Range")
			  ("skewness=" "(new-variable) Skewness")
			  ("std=" "(new-variable) Standard deviation")
			  ("stdmean=" "(new-variable) Standard error of the mean")
			  ("sum=" "(new-variable) Sum of the observations")
			  ("sumwgt=" "(new-variable) Sum of the weights")
			  ("uss=" "(new-variable) Uncorrected sum of squares")
			  ("var=" "(new-variable) Variance")
			  ("p1=" "(new-variable) 1st percentile")
			  ("p5=" "(new-variable) 5th percentile")
			  ("p10=" "(new-variable) 10th percentile")
			  ("q1=" "(new-variable) Lower quartile (25th percentile)")
			  ("median=" "(new-variable) Median (50th percentile)")
			  ("q3=" "(new-variable) Upper quartile (75th percentile)")
			  ("p90=" "(new-variable) 90th percentile")
			  ("p95=" "(new-variable) 95th percentile")
			  ("p99=" "(new-variable) 99th percentile")
			  ("qrange=" "(new-variable) Interquartile range (Q3 - Q1)")
			  ("gini=" "(new-variable) Gini's mean difference")
			  ("mad=" "(new-variable) Median absolute difference about the median")
			  ("qn=" "(new-variable) Qn, alternative to MAD")
			  ("sn=" "(new-variable) Sn, alternative to MAD")
			  ("std_gini=" "(new-variable) Gini's standard deviation")
			  ("std_mad=" "(new-variable) MAD standard deviation")
			  ("std_qn=" "(new-variable) Qn standard deviation")
			  ("std_qrange=" "(new-variable) Interquartile range standard deviation")
			  ("std_sn=" "(new-variable) Sn standard deviation")
			  ("msign=" "(new-variable) Sign statistic")
			  ("normaltest=" "(new-variable) Test statistic for normality")
			  ("signrank=" "(new-variable) Signed rank statistic")
			  ("probm=" "(new-variable) Probability of a greater absolute value for the sign statistic")
			  ("probn=" "(new-variable) Probability value for the test of normality")
			  ("probs=" "(new-variable) Probability value for the signed rank test")
			  ("probt=" "(new-variable) Probability value for the Student's t test")
			  ("t=" "(new-variable) Statistic for the Student's t test")
			  ("pctlpts=" "(#) Specifies one or more percentiles that are not automatically computed by the UNIVARIATE procedure")
			  ("pctlpre=" "(prefixes) Specifies one or more prefixes to create the variable names for the variables that contain the PCTLPTS= percentiles")
			  ("pctlname=" "(suffixes) Specifies one or more suffixes to create the names for the variables that contain the PCTLPTS= percentiles")
			  ))
    ("univariate-probplot" (
			    ("/**/" "(variable)")
			    ))
    ("univariate.probplot" (
			    ("alpha=" "[value|EST] Specifies the mandatory shape parameter alpha for probability plots requested with the BETA and GAMMA options")
			    ("c=" "[value|EST] Specifies the shape parameter c for probability plots requested with the WEIBULL and WEIBULL2 options.")
			    ("cframe=" "(color) Specifies the color for the area that is enclosed by the axes and frame.")
			    ("cframeside=" "(color) Specifies the color to fill the frame area for the row labels that display along the left side of a comparative probability plot.")
			    ("cframetop=" "(color) Specifies the color to fill the frame area for the column labels that display across the top of a comparative probability plot.")
			    ("cgrid=" "(color) Specifies the color for grid lines when a grid displays on the plot")
			    ("color=" "(color) Specifies the color of the diagonal distribution reference line")
			    ("ctext=" "(color) Specifies the color for tick mark values and axis labels.")
			    ("font=" "(font) Specifies a software font for the reference lines and axis labels")
			    ("height=" "(#) Specifies the height, in percentage screen units, of text for axis labels, tick mark labels, and legends.")
			    ("href=" "(#) Draws reference lines that are perpendicular to the horizontal axis at the values you specify")
			    ("hreflabpos=" "(#) Specifies the vertical position of HREFLABELS= labels.")
			    ("infont=" "(font) Specifies a software font to use for text inside the framed areas of the plot")
			    ("inheight=" "(#) Specifies the height, in percentage screen units, of text used inside the framed areas of the plot")
			    ("intertile=" "(#) Specifies the distance, in horizontal percentage screen units, between the framed areas, which are called tiles")
			    ("l=" "(linetype) Specifies the line type for a diagonal distribution reference line")
			    ("lgrid=" "(linetype) Specifies the line type for the grid requested by the GRID= option")
			    ("lvref=" "(linetype) Specifies the line type for the reference lines requested with the VREF= option.")
			    ("mu=" "[value|EST] Specifies the mean mu_0 for a normal probability plot requested with the NORMAL option.")
			    ("nadj=" "(value) Specifies the adjustment value added to the sample size in the calculation of theoretical percentiles. By default, NADJ=(1/4).")
			    ("name=" "('string') Specifies a name for the plot, up to eight characters long")
			    ("pctlorder=" "(values) Specifies the tick marks that are labeled on the theoretical percentile axis")
			    ("rankadj=" "(value) Specifies the adjustment value added to the ranks in the calculation of theoretical percentiles")
			    ("scale=" "[value|EST] Is an alias for the SIGMA= option for plots requested by the BETA, EXPONENTIAL, GAMMA, and WEIBULL options and for the ZETA= option when you request the LOGNORMAL option")
			    ("shape=" "[value|EST] Is an alias for the ALPHA= option with the GAMMA option, for the SIGMA= option with the LOGNORMAL option, and for the C= option with the WEIBULL and WEIBULL2 options.")
			    ("sigma=" "[value|EST] Specifies the parameter sigma, where sigma>. ")
			    ("slope=" "[value|EST] Specifies the slope for a distribution reference line requested with the LOGNORMAL and WEIBULL2 options.")
			    ("theta=" "[value|EST] Specifies the lower threshold parameter theta for plots requested with the BETA, EXPONENTIAL, GAMMA, LOGNORMAL, WEIBULL, and WEIBULL2 options")
			    ("threshold=" "[value|EST] Is an alias for the THETA= option")
			    ("vaxislabel=" "('label') Specifies a label for the vertical axis. Labels can have up to 40 characters")
			    ("vref=" "(values) Draws reference lines perpendicular to the vertical axis at the values specified.")
			    ("vreflabpos=" "(#) Specifies the horizontal position of VREFLABELS= labels. If you specify VREFLABPOS=1, the labels are positioned at the left of the histogram. If you specify VREFLABPOS=2, the labels are positioned at the right of the histogram. By default, VREFLABPOS=1. ")
			    ("w=" "(#) Specifies the width, in pixels, for a diagonal distribution line.")
			    ("waxis=" "(#) Specifies the line thickness, in pixels, for the axes and frame")
			    ("zeta=" "[value|EST] Specifies a value for the scale parameter zeta for the lognormal probability plots requested with the LOGNORMAL option")
			    ("annotate=" "(data) Specifies an input data set containing annotate variables")
			    ("anno=" "(data) Specifies an input data set containing annotate variables")
			    ("beta=" "[value|EST] Specifies the mandatory shape parameter beta for probability plots requested with the BETA option")
			    ("b=" "[value|EST] Specifies the mandatory shape parameter beta for probability plots requested with the BETA option")
			    ("caxis=" "(color) Specifies the color for the axes")
			    ("caxes=" "(color) Specifies the color for the axes")
			    ("description=" "('string') Specifies a description")
			    ("des=" "('string') Specifies a description")
			    ("hminor=" "(#) Specifies the number of minor tick marks between each major tick mark on the horizontal axis")
			    ("hm=" "(#) Specifies the number of minor tick marks between each major tick mark on the horizontal axis")
			    ("lhref=" "(linetype) Specifies the line type for the reference lines that you request")
			    ("lh=" "(linetype) Specifies the line type for the reference lines that you request")
			    ("ncols=" "(#) Specifies the number of columns in a comparative probability plot")
			    ("ncol=" "(#) Specifies the number of columns in a comparative probability plot")
			    ("nrows=" "(#) Specifies the number of rows in a comparative probability plot")
			    ("nrow=" "(#) Specifies the number of rows in a comparative probability plot")
			    ("vminor=" "(#) Specifies the number of minor tick marks between each major tick mark on the vertical axis")
			    ("vm=" "(#) Specifies the number of minor tick marks between each major tick mark on the vertical axis")
			    ("hreflabels=" "('label1' ... ' labeln') Specifies labels for the reference lines requested by the HREF= option")
			    ("hreflabel=" "('label1' ... ' labeln') Specifies labels for the reference lines requested by the HREF= option")
			    ("hreflab=" "('label1' ... ' labeln') Specifies labels for the reference lines requested by the HREF= option")
			    ("vreflabels=" "('label1'... 'labeln') Specifies labels for the reference lines requested by the VREF= option")
			    ("vreflabel=" "('label1'... 'labeln') Specifies labels for the reference lines requested by the VREF= option")
			    ("vreflab=" "('label1'... 'labeln') Specifies labels for the reference lines requested by the VREF= option")
			    ("annokey" "Applies the annotation requested with the ANNOTATE= option to the key cell only.")
			    ("grid" "Displays a grid. ")
			    ("noframe" "Suppresses the frame around the subplot area")
			    ("nohlabel" "Suppresses the label for the horizontal axis")
			    ("novlabel" "Suppresses the label for the vertical axis")
			    ("novtick" "Suppresses the tick marks and tick mark labels for the vertical axis")
			    ("pctlminor" "Requests minor tick marks for the percentile axis.")
			    ("square" "Displays the probability plot in a square frame")
			    ("beta(alpha=/**/ beta=)" "(ALPHA=value|EST BETA=value|EST <beta-options>) Creates a beta probability plot for each combination of the required shape parameters alpha and beta specified by the required ALPHA= and BETA=")
			    ("exponential(/**/)" "(exponential-options) Creates an exponential probability plot")
			    ("exp(/**/)" "(exponential-options) Creates an exponential probability plot")
			    ("gamma(alpha=/**/)" "(ALPHA=value|EST <gamma-options>) Creates a gamma probability plot for each value of the shape parameter alpha given by the mandatory ALPHA= gamma-option.")
			    ("lognormal(sigma=/**/)" "(SIGMA=value|EST <lognormal-options>) Creates a lognormal probability plot for each value of the shape parameter sigma given by the mandatory SIGMA= lognormal-option")
			    ("lnorm(sigma/**/)" "(SIGMA=value or EST <lognormal-options>) Creates a lognormal probability plot for each value of the shape parameter sigma given by the mandatory SIGMA= lognormal-option")
			    ("normal(/**/)" "(normal-options) Creates a normal probability plot (default).")
			    ("weibull(c=/**/)" "(C=value or EST <Weibull-options>) Creates a three-parameter Weibull probability plot for each value of the required shape parameter c specified by the mandatory C= Weibull-option")
			    ("weib(c=/**/)" "(C=value or EST <Weibull-options>) Creates a three-parameter Weibull probability plot for each value of the required shape parameter c specified by the mandatory C= Weibull-option")
			    ("weibull2(/**/)" "<(Weibull2-options)> Creates a two-parameter Weibull probability plot. You should use the WEIBULL2 option when your data have a known lower threshold theta_0, which is 0 by default")
			    ("w2(/**/)" "<(Weibull2-options)> Creates a two-parameter Weibull probability plot. You should use the WEIBULL2 option when your data have a known lower threshold theta_0, which is 0 by default")

			    )
     )
    ("univariate-qqplot" (
			    ("/**/" "(variable)")
			    ))
    ("univariate.qqplot"  (
			   ("alpha=" "[value|EST] Specifies the mandatory shape parameter alpha for quantile plots requested with the BETA and GAMMA options")
			   ("c=" "[value|EST] Specifies the shape parameter c for quantile plots requested with the WEIBULL and WEIBULL2 options")
			   ("cframe=" "(color) Specifies the color for the area that is enclosed by the axes and frame")
			   ("cframeside=" "(color) Specifies the color to fill the frame area for the row labels that display along the left side of a comparative quantile plot")
			   ("cframetop=" "(color) Specifies the color to fill the frame area for the column labels that display across the top of a comparative quantile plot")
			   ("cgrid=" "(color) Specifies the color for grid lines when a grid displays on the plo")
			   ("color=" "(color) Specifies the color of the diagonal distribution reference line.")
			   ("ctext=" "(color) Specifies the color for tick mark values and axis labels")
			   ("font=" "(font) Specifies a software font for the reference lines and axis labels")
			   ("height=" "(value) Specifies the height, in percentage screen units, of text for axis labels, tick mark labels, and legends")
			   ("href=" "(#) Draws reference lines that are perpendicular to the horizontal axis at specified values")
			   ("hreflabpos=" "(#) Specifies the vertical position of HREFLABELS= labels")
			   ("infont=" "(font) Specifies a software font to use for text inside the framed areas of the plot")
			   ("inheight=" "(#) Specifies the height, in percentage screen units, of text used inside the framed areas of the plot")
			   ("intertile=" "(#) Specifies the distance, in horizontal percentage screen units, between the framed areas, which are called tiles")
			   ("l=" "(linetype) Specifies the line type for a diagonal distribution reference line")
			   ("lgrid=" "(linetype) Specifies the line type for the grid requested by the GRID option")
			   ("lvref=" "(linetype) Specifies the line type for the reference lines requested with the VREF= option")
			   ("mu=" "[value|EST] Specifies the mean mu_0 for a normal quantile plot requested with the NORMAL option.")
			   ("nadj=" "(#) Specifies the adjustment value added to the sample size in the calculation of theoretical percentiles. By default, NADJ=(1/4). ")
			   ("name=" "('string') Specifies a name for the plot, up to eight characters long")
			   ("rankadj=" "(#) Specifies the adjustment value added to the ranks in the calculation of theoretical percentiles.")
			   ("scale=" "[value|EST] Is an alias for the SIGMA= option for plots requested by the BETA, EXPONENTIAL, GAMMA, WEIBULL, and WEIBULL2 options and for the ZETA= option with the LOGNORMAL option")
			   ("shape=" "[value|EST] Is an alias for the ALPHA= option with the GAMMA option, for the SIGMA= option with the LOGNORMAL option, and for the C= option with the WEIBULL and WEIBULL2 options")

			   ("sigma=" "[value|EST] Specifies the parameter sigma, where sigma>0. Alternatively, you can specify SIGMA=EST to request a maximum likelihood estimate for sigma_0.")
			   ("slope=" "[value|EST] Specifies the slope for a distribution reference line requested with the LOGNORMAL and WEIBULL2 options.")
			   ("theta=" "[value|EST] Specifies the lower threshold parameter theta for plots requested with the BETA, EXPONENTIAL, GAMMA, LOGNORMAL, WEIBULL, and WEIBULL2 options")
			   ("threshold=" "[value|EST] Is an alias for the THETA= option")
			   ("vaxislabel=" "('label') Specifies a label for the vertical axis")
			   ("vref=" "(#) Draws reference lines perpendicular to the vertical axis at the values specified. Also see the CVREF=, LVREF=, and VREFCHAR= options")
			   ("vreflabpos=" "(#) Specifies the horizontal position of VREFLABELS= labels.")
			   ("w=" "(#) Specifies the width, in pixels, for a diagonal distribution line")
			   ("waxis=" "(#) Specifies the line thickness, in pixels.")
			   ("zeta=" "[value|EST] Specifies a value for the scale parameter zeta for the lognormal quantile plots requested with the LOGNORMAL option")
			   ("annotate=" "(data) Specifies an input data set containing annotate variables")
			   ("anno=" "(data) Specifies an input data set containing annotate variables")
			   ("beta=" "[value|EST] Specifies the mandatory shape parameter beta for quantile plots requested with the BETA option")
			   ("b=" "[value|EST] Specifies the mandatory shape parameter beta for quantile plots requested with the BETA option")
			   ("caxis=" "(color) Specifies the color for the axes")
			   ("caxes=" "(color) Specifies the color for the axes")
			   ("chref=" "(color) Specifies the color for horizontal axis reference lines requested by the HREF= option")
			   ("ch=" "(color) Specifies the color for horizontal axis reference lines requested by the HREF= option")
			   ("cvref=" "(color) Specifies the color for the reference lines requested by the VREF= option")
			   ("cv=" "(color) Specifies the color for the reference lines requested by the VREF= option")
			   ("description=" "('string') Specifies a description, up to 40 characters long")
			   ("des=" "('string') Specifies a description, up to 40 characters long")
			   ("hminor=" "(#) Specifies the number of minor tick marks between each major tick mark on the horizontal axis")
			   ("hm=" "(#) Specifies the number of minor tick marks between each major tick mark on the horizontal axis")
			   ("hreflabels=" "('label1' ... ' labeln') Specifies labels for the reference lines requested by the HREF= option")
			   ("hreflabel=" "('label1' ... ' labeln') Specifies labels for the reference lines requested by the HREF= option")
			   ("hreflab=" "('label1' ... ' labeln') Specifies labels for the reference lines requested by the HREF= option")
			   ("vreflabels=" "('label1'... 'labeln') Specifies labels for the reference lines requested by the VREF= option")
			   ("vreflabel=" "('label1'... 'labeln') Specifies labels for the reference lines requested by the VREF= option")
			   ("vreflab=" "('label1'... 'labeln') Specifies labels for the reference lines requested by the VREF= option")
			   ("annokey" "Applies the annotation requested with the ANNOTATE= option to the key cell only")
			   ("grid" "Displays a grid of horizontal lines positioned at major tick marks on the vertical axis")
			   ("noframe" "Suppresses the frame around the subplot area.")
			   ("nohlabel" "Suppresses the label for the horizontal axis")
			   ("novlabel" "Suppresses the label for the vertical axis")
			   ("novtick" "Suppresses the tick marks and tick mark labels for the vertical axis")
			   ("pctlminor" "Requests minor tick marks for the percentile axis")
			   ("pctlscale" "Requests scale labels for the theoretical quantile axis in percentile units, resulting in a nonlinear axis scale")
			   ("square" "Displays the quantile plot in a square frame")
			   ("beta(alpha=/**/ beta=)" "(ALPHA=value or EST  BETA=value or EST <beta-options>) Creates a beta quantile plot")
			   ("gamma(alpha=/**/)" "(ALPHA=value or EST <gamma-options>) Creates a gamma quantile plot for each value of the shape parameter alpha given by the mandatory ALPHA= gamma-option")
			   ("normal(/**/)" "<(normal-options)> Creates a normal quantile plot.")
			   ("exponential(/**/)" "(exponential-options) Creates an exponential quantile plot.")
			   ("exp(/**/)" "(exponential-options) Creates an exponential quantile plot.")
			   ("lognormal(sigma=/**/)" "(SIGMA=value or EST <lognormal-options>) Creates a lognormal quantile plot for each value of the shape parameter sigma given by the mandatory SIGMA= lognormal-option")
			   ("lnorm(sigma=/**/)" "(SIGMA=value or EST <lognormal-options>) Creates a lognormal quantile plot for each value of the shape parameter sigma given by the mandatory SIGMA= lognormal-option")
			   ("weibul(c=/**/)" "(C=value or EST <Weibull-options>) Creates a three-parameter Weibull quantile plot for each value of the required shape parameter c specified by the mandatory C= Weibull-option")
			   ("weib(c=/**/)" "(C=value or EST <Weibull-options>) Creates a three-parameter Weibull quantile plot for each value of the required shape parameter c specified by the mandatory C= Weibull-option")
			   ("weibull2(/**/)" "<(Weibull2-options)> Creates a two-parameter Weibull quantile plot")
			   ("w2(/**/)" "<(Weibull2-options)> Creates a two-parameter Weibull quantile plot")
			   ))
    )
)
(defvar sas-base-state-options
  '(
    ("-by" (
	   ("/**/" "(variable)")
	   ("descending" "Specifies that the data set is sorted in descending order by the variable that immediately follows the word DESCENDING in the BY statement.")
	   ("notsorted" "Specifies that observations are not necessarily sorted in alphabetic or numeric order.")
	   ))
    ("-var" (
	    ("/**/" "(variable)")
	    ))
    ("-weight" (
	       ("/**/" "(variable)")
	       ))
    ("-id" (
	   ("/**/" "(variable)")
	   ))
    ("-freq" (
	      ("/**/" "(variable)")
	      ))
    ("-format" (
		("/**/" "([variable]|[format])")
		))
    ("-label" (
	       ("/**/" "(variable='')")
	       ))
    ("-where" (
	       ("/**/" "(where)")
		))
    ("-attrib" (
		("/**/" "(variable)")
		("format=" "(format) Associates a format with variables in variable-list")
		("informat=" "(informat) Associates an informat with variables in variable-list")
		("label=" "('label') Associates a label with variables in variable-list")
		("length=" "(<$>length) Specifies the length of variables in variable-list")
		("transcode=" "(yes|no) Specifies whether character variables can be transcoded")
		))
    ("-title# \"/**/\";" (
		("bold" "Specifies that the title text is bold font weight")
		("italic" "Specifies that the title text is in italic style")
		("color=" "(color) Specifies the title text color")
		("bcolor=" "(color) Specifies the background color of the title block")
		("font=" "(font-face) Specifies the font to use")
		("height=" "(#) Specifies the point size")
		("justify=" "(center|left|right) Specifies justification")
		("link=" "('url') Specifies a hyperlink")
		("underlin=" "(0|1|2|3) Specifies whether the subsequent text is underlined. 0 indicates no underlining. 1, 2, and 3 indicate underlining")
		("#byvar(/**/)" "Substitutes the name of the BY variable or label that is associated with the variable")
		("#byline" "Substitutes the entire BY line without leading or trailing blanks for #BYLINE in the text string and displays the BY line in the title")
		))
    ("-footnote# \"/**/\";" (
		("bold" "Specifies that the title text is bold font weight")
		("italic" "Specifies that the title text is in italic style")
		("color=" "(color) Specifies the title text color")
		("bcolor=" "(color) Specifies the background color of the title block")
		("font=" "(font-face) Specifies the font to use")
		("height=" "(#) Specifies the point size")
		("justify=" "(center|left|right) Specifies justification")
		("link=" "('url') Specifies a hyperlink")
		("underlin=" "(0|1|2|3) Specifies whether the subsequent text is underlined. 0 indicates no underlining. 1, 2, and 3 indicate underlining")
		("#byvar(/**/)" "Substitutes the name of the BY variable or label that is associated with the variable")
		("#byline" "Substitutes the entire BY line without leading or trailing blanks for #BYLINE in the text string and displays the BY line in the title")
		))
    )
  "Proc State Options"
  )

(setq sas-base-state-options (append sas-base-state-options 
				     proc-univariate-state-options
				     proc-transpose-state-options
				     proc-timeplot-state-options
				     proc-tabulate-state-options
				     proc-summary-state-options
				     proc-means-state-options
				     proc-standard-state-options
				     proc-sort-state-options
				     proc-rank-state-options
				     proc-print-state-options
				     proc-plot-state-options
				     proc-freq-state-options
				     proc-format-state-options
				     proc-import-state-options
				     proc-export-state-options
				     proc-document-state-options
				     proc-cport-state-options
				     proc-corr-state-options
				     proc-copy-state-options
				     proc-compare-state-options
				     proc-cimport-state-options
				     proc-chart-state-options))

(defvar sas-base-procs
  '(
("proc univariate data= gout= alpha= anno= mu0= nextrobs= nextrval= pctldef= plotsize= round= trim= vardef= winsor=;
    by ;
    class /;
    freq ;
    histogram /;
    id ;
    inset /;
    output ;
    probplot /;
    qqplot /;
    var ;
    weight ;
run;" -236)
("proc transpose data= label= name= out= prefix=;
    by ;
    copy ;
    id ;
    idlabel ;
    var ;
    attrib ;
    format ;
    label ;
run;" -123
    )
("proc timeplot data= maxdec= split=;
    by ;
    class ;
    id ;
    plot /;
    attrib ;
    format ;
    label ;
    where ;
run;" -113)
("proc tabulate data= contents= out= classdata= alpha= qmarkers= qmethod= qntldef= vardef= format= formchar= order= style=;
     by ;
     class /;
     classlev /;
     freq ;
     keylabel ; 
     keyword /;
     table /;
     var /;
     weight ;
     attrib ;
     format ;
     label ;
     where ;
run;" -287)
("proc summary data= sumsize= classdata= alpha= qmarkers= qmethod= qntldef= vardef= fw= maxdec= order=;
     by ;
     class /;
     freq ;
     id ;
     output /;
     types ;
     var /;
     ways ;
     weight ;
     attrib ;
     format ;
     label ;
     where ;
run;" -254)
("proc means data= sumsize= classdata= alpha= qmarkers= qmethod= qntldef= vardef= fw= maxdec= order=;
     by ;
     class /;
     freq ;
     id ;
     output /;
     types ;
     var /;
     ways ;
     weight ;
     attrib ;
     format ;
     label ;
     where ;
run;" -254)
("proc standard data= out= mean= std= vardef=;
     by ;
     freq ; 
     var ;
     weight ;
     attrib ;
     format ;
     label ;
     where ;
run;" -132)
("proc sql;
     create table 
     as select 
     from 
     where 
     group by 
     order by 
     ;
quit;" -82)
("proc sort data= sortseq= out= dupout= sortsize=;
     by ;
     attrib ;
     format ;
     label ;
     where ;
run;" -102)
("proc rank data= out= groups= normal= ties=;
     by ;
     var ;
     ranks ;
     attrib ;
     format ;
     label ;
     where ;
run;" -121)
("proc printto label= log=  print=;
run;" -19)
("proc print data= contents= n= obs= rows= heading= split= width=;
     by ;
     pageby ;
     sumby ;
     id /;
     sum /; 
     var /;
run;" -126)
("proc plot data= formchar= vtoh= hpercent= vpercent=;
     by ;
     plot /;
     attrib ;
     format ;
     label ;
     where ;
run;" -119)
("proc options group= option=;
run;"  -14)
("proc migrate in= out= bufsize= slibref=;
run;" -29)
("proc import datafile= table= out=;
     ;
run;" -25)
("proc freq data= formchar= order=;
     by ;
     exact /;
     output ;
     tables /;
     test ;
     weight /;
run;" -103)
("proc format cntlin= cntlout= library= maxlablen= maxselen=;
     exclude ;
     invalue ;
     picture ;
     select ;
     value ;
run;" -117)
("proc fontreg mode= msglevel=;
     fontfile ;
     fontpath ;
     truetype ;
     type1 ;
run;" -77)
("proc export data= outfile= outtable= dbms=;
    ;
run;" -37)
("proc document name= label=;
     copy /;
     delete ;
     dir ;
     doc ;
     doc close;
     hide ;
     import /;
     link /;
     list /;
     make /; 
     move /;
     note /; 
     obanote /;
     obbnote /;
     obfootn ;
     obpage /;
     obstitle /;
     obtitle ;
     rename ;
     replay /;
     setlabel ;
     unhide ;
quit;" -326)
("proc cport source-type= file= after= eet= et= generation= memtype= outtype= outlib=;
	exclude /;
	select /;
	trantab ;
run;" -100)
("proc corr data= outh= outk= outp= outs= singular= vardef= best=;
    by ;
    freq ;
    partial ;
    var ;
    weight ;
    with ;
run;" -122)
("proc copy out= in= constraint= index= memtype= alter=;
     exclude /;
     select /;
run;" -76)
("proc contents data= memtype= order= out= out2=;
run;" -33)
("proc compare base= compare= out= outstats= criterion= method= fuzz= maxprint=;
     by ;
     id ;
     var ;
     with ;
     label ;
     attrib ;
     format ;
     where ;
run;" -162)
("proc cimport destination= infile= eet= et= extendsn= memtype=;
     exclude /;
     select /;
run;" -73)
("proc chart data= formchar= lpi=;
     block /;
     by ;
     hbar /;
     pie /;
     star /;
     vbar /;
run;" -96)
("proc catalog catalog= entrytype=;
	contents ;
	copy;
	select /;
	exclude /;
	change /;
	exchange /;
	delete /;
	modify /;
	save /;
run;" -114)
("proc append base= data= appendver=;
run;" -23)
)
  "Alist of sas procs tags for use with lightning completion"
)

(provide 'sasmod-cookies-base)
