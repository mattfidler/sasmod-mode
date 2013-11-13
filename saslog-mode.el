(defvar saslog-mode-hook nil)
(require 'autorevertro)

(define-derived-mode saslog-mode sas-log-mode "SAS Log(MLF)"
  "Major mode for visiting SAS logs"
  (if sasmod-play-with-cua
      (use-local-map saslog-mode-map-cua)
    (use-local-map saslog-mode-map)
    )
  (auto-revertro-mode)
  (setq buffer-read-only t)
  (run-hooks 'saslog-mode-hook)
)

(defun saslog-sas-file()
  "Open the current SAS file"
  ;;
  ;; Get Log File Name.
  ;;
  (interactive)
  (setq fn (buffer-file-name))
  (string-match "\\.log" fn)
  (setq fn (replace-match ".sas" nil nil fn))
  (switch-to-buffer (find-file-noselect fn))
;;  (display-buffer (find-file-noselect fn))
  (message fn)
)


(defun saslog-lst-file()
  "Open the current SAS file's lst."
  ;;
  ;; Get Log File Name.
  ;;
  (interactive)
  (setq fn (buffer-file-name))
  (string-match "\\.log" fn)
  (setq fn (replace-match ".lst" nil nil fn))
  (switch-to-buffer (find-file-noselect fn))
;;  (display-buffer (find-file-noselect fn))
  (message fn)
)

(defun saslog-error()
  "Find Next Error."
  (interactive)
  
  (if (not (re-search-forward "^ERROR" nil t))
      (message "No More Errors Found.")
    )
)

(defun saslog-error-p()
  "Find Previous Error."
  (interactive)
  
  (if (not (re-search-backward "^ERROR" nil t))
      (message "No More Errors Found.")
    )
)


(defun saslog-warning()
  "Find Next Warning."
  (interactive)
  
  (if (not (re-search-forward "^WARNING" nil t))
      (message "No More Warnings Found.")
    )
)

(defun saslog-warning-p()
  "Find Previous Warning."
  (interactive)
  
  (if (not (re-search-backward "^WARNING" nil t))
      (message "No More Warnings Found.")
    )
)

(defun saslog-work()
  "Find Next Number of observations read into SAS."
  (interactive)
  
  (if (not (re-search-forward "^NOTE\: There were [0-9]+  *observations read from the data set [A-Za-z.]+$" nil t))
      (message "No more data read into SAS (forward search)")
    )
)
(defun saslog-work-p()
  "Find Last Number of observations read into SAS."
  (interactive)
  
  (if (not (re-search-backward "^NOTE\: There were [0-9]+  *observations read from the data set [A-Za-z.]+$" nil t))
      (message "No more data read into SAS.")
    )
)



(add-to-list 'auto-mode-alist '(".log\\'" . saslog-mode))
(provide 'saslog-mode)