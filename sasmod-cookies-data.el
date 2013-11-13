;;
;; This is the file for sasmod's handling of data steps and dataset processing.
;;
(defvar sas-data-help
  '(
    ("data" (
	     ("input" "Describes the arrangement of values in the input data record from a raw data source")
	     ("set" "Reads an observation from one or more SAS data sets")
	     ("merge" "bservations from two or more SAS data sets into a single observation")
	     ("modify" "deletes, or appends observations in an existing SAS data set in place")
	     ("update" " master file by applying transactions")
	     ))
    )
  "* Defines known options for data."
  )

(defvar sas-data-options
  '(
    ("data(" (
	       ("alter=" "(alter-password) Must be a valid SAS name")
	       ("bufno=" "Specifies the number of buffers to be allocated for processing a SAS data set")
	       ("bufsize=" "Specifies the permanent buffer page size for an output SAS data set")
	       ("cntllev=" "(lib|mem|rec) Specifies the level of shared access to a SAS data set lib=library mem=memory rec=record")
	       ("compress=" "(no|yes|char|binary) Controls the compression of observations in an output SAS data set")
	       ("dldmgaction=" "(fail|abort|repair|prompt)  Specifies what type of action to take when a SAS data set in a SAS data library is detected as damaged")
	       ("drop=" "(variable) Excludes variables from processing or from output SAS data sets")
	       ("encoding=" "(any|asciiany|ebcdicany|arabic_algeria|ar_dz|arabic_bahrain|ar_bh|arabic_egypt|ar_eg|arabic_jordan|ar_jo|arabic_kuwait|ar_kw|arabic_lebanon|ar_lb|arabic_morocco|ar_ma|arabic_oman|ar_om|arabic_qatar|ar_qa|arabic_saudiarabia|ar_sa|arabic_tunisia|ar_tn|arabic_unitedarabemirates|ar_ae|bulgarian_bulgaria|bg_bg|byelorussian_belarus|be_by|chinese_china|zh_cn|chinese_hongkong|zh_hk|chinese_macau|zh_mo|chinese_singapore|zh_sg|chinese_taiwan|zh_tw|croatian_croatia|hr_hr|czech_czechrepublic|cs_cz|danish_denmark|da_dk|dutch_belgium|nl_be|dutch_netherlands|nl_nl|english_australia|en_au|english_canada|en_ca|english_hongkong|en_hk|english_india|en_in|english_ireland|en_ie|english_jamaica|en_jm|english_newzealand|en_nz|english_singapore|en_sg|english_southafrica|en_za|english_unitedkingdom|en_gb|english_unitedstates|en_us|estonian_estonia|et_ee|finnish_finland|fi_fi|french_belgium|fr_be|french_canada|fr_ca|french_france|fr_fr|french_luxembourg|fr_lu|french_switzerland|fr_ch|german_austria|de_at|german_germany|de_de|german_liechtenstein|de_li|german_luxembourg|de_lu|german_switzerland|de_ch|greek_greece|el_gr|hebrew_israel|he_il|hungarian_hungary|hu_hu|icelandic_iceland|is_is|italian_italy|it_it|italian_switzerland|it_ch|japanese_japan|ja_jp|korean_korea|ko_kr|latvian_latvia|lv_lv|lithuanian_lithuania|lt_lt|norwegian_norway|no_no|polish_poland|pl_pl|portuguese_brazil|pt_br|portuguese_portugal|pt_pt|romanian_romania|ro_ro|russian_russia|ru_ru|serbian_yugoslavia|sr_yu|slovak_slovakia|sk_sk|slovenian_slovenia|sl_sl|spanish_argentina|es_ar|spanish_bolivia|es_bo|spanish_chile|es_cl|spanish_colombia|es_co|spanish_costarica|es_cr|spanish_dominicanrepublic|es_do|spanish_ecuador|es_ec|spanish_elsalvador|es_sv|spanish_guatemala|es_gt|spanish_honduras|es_hn|spanish_mexico|es_mx|spanish_nicaragua|es_ni|spanish_panama|es_pa|spanish_paraguay|es_py|spanish_peru|es_pe|spanish_puertorico|es_pr|spanish_spain|es_es|spanish_unitedstates|es_us|spanish_uruguay|es_uy|spanish_venezuela|es_ve|swedish_sweden|sv_se|thai_thailand|th_th|turkish_turkey|tr_tr|ukrainian_ukraine|uk_ua|vietnamese_vietnam|vi_vn) Overrides the encoding to use for reading or writing a SAS data set")
	       ("encrypt=" "(yes|no) Encrypts SAS data files")
	       ("fileclose=" "(disp|leave|reread|rewind) Specifies how a tape is positioned when a SAS file on the tape is closed")
	       ("firstobs=" "(#) Specifies which observation SAS processes first")
	       ("genmax=" "(#) Requests generations for a data set and specifies the maximum number of versions")
	       ("gennum=" "(#) References a specific number of a generation.")
	       ("idxname=" "Directs SAS to use a specific index to satisfy the conditions of a WHERE expression")
	       ("idxwhere=" "(yes|no) Overrides the SAS decision about whether to use an index to satisfy the conditions of a WHERE expression")
	       ("in=" "(new-variable) Creates a variable that indicates whether the data set contributed data to the current observation")
	       ("index=" "Defines indexes when a SAS data set is created")
	       ("keep=" "(variable) Specifies variables for processing or for writing to output SAS data sets")
	       ("label='/**/'" "Specifies a label for the SAS data set")
	       ("obs=" "(#) Specifies when to stop processing observations")
	       ("obsbuf=" "(#) Determines the size of the view buffer for processing a DATA step view")
	       ("outrep=" "(alpha_tru64|alpha_osf|alpha_vms_32|alpha_vms|alpha_vms_64|hp_ia64|hp_itanium|hp_ux_32|hp_ux|hp_ux_64|intel_abi|linux_32|linux_ia64|mips_abi|mvs_32|mvs|os2|rs_6000_aix_32|rs_6000_aix|rs_6000_aix_64|solaris_32|solaris|solaris_64|vax_vms|windows_32|windows|windows_64) Specifies the data representation for the output SAS data set")
	       ("pointobs=" "(yes|no) Controls whether a compressed data set can be processed with random access (by observation number) rather than with sequential access only")
	       ("pw=" "(password) Assigns a read, write, or alter password to a SAS file and enables access to a password-protected SAS file")
	       ("pwreq=" "(yes|no) Controls the pop up of a requestor window for a data set password")
	       ("read=" "(password) Assigns a read password to a SAS file and enables access to a read-protected SAS file")
	       ("rename=(/**/)" "(variable=) Changes the name of a variable")
	       ("repempty=" "(yes|no) Controls replacement of like-named temporary or permanent SAS data sets when the new one is empty")
	       ("replace=" "(yes|no) Controls replacement of like-named temporary or permanent SAS data sets")
	       ("reuse=" "(yes|no) Specifies whether new observations are written to free space in compressed SAS data sets")
	       ("sortedby=" "([-by]|_NULL_) Specifies how the data set is currently sorted")
	       ("sortseq=" "(ascii|danish|norwegian|ebcdic|finnish|italian|national|polish|reverse|spanish|swedish) Specifies a language-specific collation sequence for the SORT procedure to use for the specified SAS data set")
	       ("spill=" "(yes|no) Specifies whether to create a spill file for non-sequential processing of a DATA step view")
	       ("tobsno=" "(#) Specifies the number of observations to be transmitted in each multi-observation exchange with a SAS server")
	       ("type=" "Specifies the data set type for a specially structured SAS data set")
	       ("where=(/**/)" "(where) Where expression.")
	       ("whereup=" "(yes|no) Specifies whether to evaluate added observations and modified observations against a WHERE expression")
	       ("write=" "(password) Assigns a write password to a SAS file and enables access to a write-protected SAS file")
	       ))
    ("data-input" (
		   ("/**/" "(variable) Describes the arrangement of values in the input data record from a raw data source")
		   ))
    ("data-set" (
		 ("/**/" "(data) Reads an observation from one or more SAS data sets")
		 ))
    ("data-merge" (
		   ("/**/" "Joins observations from two or more SAS data sets into a single observation")
		   ))
    ("data-modify" (
		    ("/**/" "Replaces, deletes, or appends observations in an existing SAS data set in place")
		    ))
    
    ("data-update" (
		    ("/**/" "Updates a master file by applying transactions")
		    ))
    )
  "Defines the options for any dataset."
  )

(provide 'sasmod-cookies-data)