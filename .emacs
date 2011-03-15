;; === ELPA ===
(when
    (load
     (expand-file-name "~/.emacs.d/elpa/package.el"))
  (package-initialize))

;; === Menu bar should not appear ===
(menu-bar-mode nil)

;; === Definitely wanting .emacs.d on the load path ===
(setq load-path (cons "~/.emacs.d/" load-path))

;; === Make sure the file ends with a goddamn fucking newline. stupid editor.
(setq require-final-newline t)

;; === Stop at the end of the file, not just add lines ===
(setq next-line-add-newlines nil)

;; === No back up files ==
(setq make-backup-files nil)
(setq auto-save-default nil)

;; === No splash screen, please ==
(setq inhibit-splash-screen t) ; 22
(setq inhibit-startup-screen t) ; 23
(setq initial-scratch-message nil) ; 23

;; === Default color theme ==
(setq frame-background-mode 'dark)
(require 'color-theme)
(color-theme-initialize)
(color-theme-arjen)

;; === indent whole buffer ==
(defun iwb ()
  "indent whole buffer"
  (interactive)
  (delete-trailing-whitespace)
  (indent-region (point-min) (point-max) nil)
  (untabify (point-min) (point-max)))

;; == ido mode is awesome
(require 'ido)
(ido-mode t)

;; == qrr is better than query-replace-regexp
(defalias 'qrr 'query-replace-regexp)

;; == pretty parens
(show-paren-mode 1)

;; == Highlight the region when you have one
(transient-mark-mode)

;; == Jabber
(add-to-list 'load-path "~/.emacs.d/jabber/")
(require 'jabber-autoloads)
(setq jabber-account-list
      '(("nbowser@gmail.com"
	 (:password . nil)
	 (:network-server . "talk.google.com")
	 (:port . 443)
	 (:connection-type . ssl))))

(defvar growl-program "/usr/local/bin/growlnotify")

(defun growl (title message &optional id)
  (if (eq id nil)
      (start-process "growl" " growl"
                     growl-program title "-w")
    (start-process "growl" " growl"
                   growl-program title "-w" "-d" id))
  (process-send-string " growl" message)
  (process-send-string " growl" "\n")
  (process-send-eof " growl"))

;; == Make jabber.el notify through growl when I get a new message
(setq jabber-message-alert-same-buffer nil)
(defun pg-jabber-growl-notify (from buf text proposed-alert)
  "(jabber.el hook) Notify of new Jabber chat messages via Growl"
  (when (or jabber-message-alert-same-buffer
            (not (memq (selected-window) (get-buffer-window-list buf))))
    (if (jabber-muc-sender-p from)
        (growl (format "(PM) %s" 
                      (jabber-jid-displayname (jabber-jid-user from))) 
              ;;  (format "%s: %s" (jabber-jid-resource from) text) 
	       "Message received."
               (format "jabber-from-%s" (jabber-jid-resource from)))
      (growl (format "%s" (jabber-jid-displayname from)) 
             ;;text 
	     "Message received."
	     "jabber-from-unknown"))))
(add-hook 'jabber-alert-message-hooks 'pg-jabber-growl-notify)
