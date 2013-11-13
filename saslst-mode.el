(defvar saslst-mode-hook nil)
(require 'autorevertro)

(define-derived-mode saslst-mode sas-listing-mode "SAS Lst(MLF)"
  "Major mode for visiting SAS lists"
  (auto-revertro-mode)
  (setq buffer-read-only t)
  (if sasmod-play-with-cua
      (use-local-map saslst-mode-map-cua)
    (use-local-map saslst-mode-map)
    )
  (run-hooks 'saslst-mode-hook)
)

(defun saslst-sas-file()
  "Open the current SAS file."
  ;;
  ;; Get Log File Name.
  ;;
  (interactive)
  (setq fn (buffer-file-name))
  (string-match "\\.lst" fn)
  (setq fn (replace-match ".sas" nil nil fn))
  (switch-to-buffer (find-file-noselect fn))
;;  (display-buffer (find-file-noselect fn))
  (message fn)
)

(defun saslst-log-file()
  "Open the current SAS files' log."
  (interactive)
  (setq fn (buffer-file-name))
  (string-match "\\.lst" fn)
  (setq fn (replace-match ".log" nil nil fn))
  (switch-to-buffer (find-file-noselect fn))
)


(add-to-list 'auto-mode-alist '(".lst\\'" . saslst-mode))
(provide 'saslst-mode)
