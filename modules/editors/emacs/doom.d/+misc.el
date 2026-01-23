;;; +misc.el --- Miscellaneous -*- lexical-binding: t -*-

;;; Commentary:

;;; Code:

;; user
(setq user-full-name "Yevhen Shymotiuk")


;; general
(global-subword-mode 1)
(setq truncate-string-ellipsis "…")


;; evil
(setq evil-split-window-below t
      evil-vsplit-window-right t
      evil-want-fine-undo t)


;; dired
(when (string= system-type "darwin")
  (setq dired-use-ls-dired nil))


;; terminal
(setq evil-escape-excluded-major-modes
      (delete 'vterm-mode evil-escape-excluded-major-modes))

(defun open-popup-terminal ()
  "Toggle a terminal popup window."
  (interactive)
  (+term/toggle t)
  (evil-window-set-height 10))


;; agenda
(setq org-agenda-files '("~/dev/org/" "~/dev/org/google-calendar/" "~/dev/org/brave/"))

(setq org-agenda-custom-commands
      '(("c" "Custom agenda view"
         ((agenda "" ((org-agenda-overriding-header "Today's agenda")
                      (org-agenda-start-day "4d")
                      (org-agenda-span 1)))
          (agenda "" ((org-agenda-overriding-header "10 days' agenda")))
          (alltodo "" ((org-agenda-overriding-header "All tasks")))))
        ("t" "Today's agenda view"
         ((agenda "" ((org-agenda-overriding-header "Today's agenda")
                      (org-agenda-start-day "4d")
                      (org-agenda-span 1)))))))


;; plantuml
(setq org-plantuml-jar-path plantuml-jar-path)


;; alert
(setq alert-default-style 'libnotify)


;; mu4e
(after! mu4e
  (defvar mu4e-reindex-request-file "/tmp/mu_reindex_now"
    "Location of the reindex request, signaled by existance")
  (defvar mu4e-reindex-request-min-seperation 5.0
    "Don't refresh again until this many second have elapsed.
Prevents a series of redisplays from being called (when set
to an appropriate value)")

  (defvar mu4e-reindex-request--file-watcher nil)
  (defvar mu4e-reindex-request--file-just-deleted nil)
  (defvar mu4e-reindex-request--last-time 0)

  (defun mu4e-reindex-request--add-watcher ()
    (setq mu4e-reindex-request--file-just-deleted nil)
    (setq mu4e-reindex-request--file-watcher
          (file-notify-add-watch mu4e-reindex-request-file
                                 '(change)
                                 #'mu4e-file-reindex-request)))

  (defadvice! mu4e-stop-watching-for-reindex-request ()
    :after #'mu4e~proc-kill
    (if mu4e-reindex-request--file-watcher
        (file-notify-rm-watch mu4e-reindex-request--file-watcher)))

  (defadvice! mu4e-watch-for-reindex-request ()
    :after #'mu4e~proc-start
    (mu4e-stop-watching-for-reindex-request)
    (when (file-exists-p mu4e-reindex-request-file)
      (delete-file mu4e-reindex-request-file))
    (mu4e-reindex-request--add-watcher))

  (defun mu4e-file-reindex-request (event)
    "Act based on the existance of `mu4e-reindex-request-file'"
    (if mu4e-reindex-request--file-just-deleted
        (mu4e-reindex-request--add-watcher)
      (when (equal (nth 1 event) 'created)
        (delete-file mu4e-reindex-request-file)
        (setq mu4e-reindex-request--file-just-deleted t)
        (mu4e-reindex-maybe t))))

  (defun mu4e-reindex-maybe (&optional new-request)
    "Run `mu4e~proc-index' if it's been more than
`mu4e-reindex-request-min-seperation'seconds since the last request,"
    (let ((time-since-last-request (- (float-time)
                                      mu4e-reindex-request--last-time)))
      (when new-request
        (setq mu4e-reindex-request--last-time (float-time)))
      (if (> time-since-last-request mu4e-reindex-request-min-seperation)
          (mu4e~proc-index nil t)
        (when new-request
          (run-at-time (* 1.1 mu4e-reindex-request-min-seperation) nil
                       #'mu4e-reindex-maybe)))))
  (set-email-account! "gmail-personal"
                      '((mu4e-sent-folder       . "/gmail-personal/sent")
                        (mu4e-drafts-folder     . "/gmail-personal/drafts")
                        (mu4e-trash-folder      . "/gmail-personal/trash")
                        (mu4e-refile-folder     . "/gmail-personal/all")
                        (smtpmail-smtp-user     . "yevhenshymotiuk@gmail.com")
                        (smtpmail-smtp-server   . "smtp.gmail.com")
                        (smtpmail-smtp-service  . 587)
                        (user-mail-address      . "yevhenshymotiuk@gmail.com"))
                      t)
  (set-email-account! "gmail-work"
                      '((mu4e-sent-folder       . "/gmail-work/sent")
                        (mu4e-drafts-folder     . "/gmail-work/drafts")
                        (mu4e-trash-folder      . "/gmail-work/trash")
                        (mu4e-refile-folder     . "/gmail-work/all")
                        (smtpmail-smtp-user     . "yshymotiuk@brave.com")
                        (smtpmail-smtp-server   . "smtp.gmail.com")
                        (smtpmail-smtp-service  . 587)
                        (user-mail-address      . "yshymotiuk@brave.com"))
                      t)
  (set-email-account! "protonmail"
                      '((mu4e-sent-folder       . "/protonmail/sent")
                        (mu4e-drafts-folder     . "/protonmail/drafts")
                        (mu4e-trash-folder      . "/protonmail/trash")
                        (mu4e-refile-folder     . "/protonmail/all")
                        (smtpmail-smtp-user     . "yshym@pm.me")
                        (smtpmail-smtp-server   . "127.0.0.1")
                        (smtpmail-smtp-service  . 1025)
                        (user-mail-address      . "yshym@pm.me"))
                      t)
  (let ((proton-bridge-cert "~/.config/protonmail/bridge/cert.pem"))
    (if (boundp 'gnutls-trustfiles)
        (add-to-list 'gnutls-trustfiles proton-bridge-cert)
      (setq gnutls-trustfiles (list proton-bridge-cert))))
  (setq send-mail-function 'smtpmail-send-it
        mu4e-headers-fields '((:flags . 6)
                              (:account-stripe . 2)
                              (:from-or-to . 25)
                              (:folder . 10)
                              (:subject . 80)
                              (:human-date . 10))
        +mu4e-min-header-frame-width 142
        mu4e-headers-date-format " %d/%m/%y"
        mu4e-headers-time-format " %H:%M"
        mu4e-headers-results-limit 1000
        mu4e-index-cleanup t)
  (defvar +mu4e-header--folder-colors nil)
  (appendq! mu4e-header-info-custom
            '((:folder .
               (:name "Folder" :shortname "Folder" :help "Lowest level folder" :function
                (lambda (msg)
                  (+mu4e-colorize-str
                   (replace-regexp-in-string "\\`.*/" "" (mu4e-message-field msg :maildir))
                   '+mu4e-header--folder-colors)))))))


;; twitter
(setq twittering-allow-insecure-server-cert t)


;; fix ripgrep search
(after! counsel
  (setq counsel-rg-base-command "rg -M 240 --with-filename --no-heading --line-number --color never --smart-case %s || true"))


;; eshell
(defun eshell-handle-ansi-color ()
  "Apply ansi escape sequences to an eshell output buffer."
  (ansi-color-apply-on-region eshell-last-output-start eshell-last-output-end))
(add-hook 'eshell-output-filter-functions 'eshell-handle-ansi-color)

(set-popup-rule! "^\\*Eshell Command Output*" :side 'bottom :size 0.3)

;; FIXME This varible is never set to `t`
;; NOTE Common history traversal currently
;; TODO Improve it so the current manual input is considered
(defvar-local my-eshell--input-manual nil)

(defun my-eshell--on-input-change ()
  "Mark input as manually typed."
  (setq my-eshell--input-manual t))

(defun my-eshell-previous-input ()
  "Get previout input using matching history if input was typed.
Otherwise use plain history."
  (interactive)
  ;; (if (and my-eshell--input-manual (> (point) eshell-last-output-end))
  ;;     (eshell-previous-matching-input-from-input 1)
  ;;   (eshell-previous-input 1))
  (eshell-previous-input 1))

(defun my-eshell-next-input ()
  "Get next input using matching history if input was typed.
Otherwise use plain history."
  (interactive)
  ;; (if (and my-eshell--input-manual (> (point) eshell-last-output-end))
  ;;     (eshell-next-matching-input-from-input 1)
  ;;   (eshell-next-input 1))
  (eshell-next-input 1))

;; Reset flag after command is sent
(defun my-eshell-reset-flag-hook ()
  "Mark input as not manually typed."
  (setq my-eshell--input-manual nil))

(add-hook 'eshell-input-filter-functions #'my-eshell--on-input-change nil t)
(add-hook 'eshell-post-command-hook #'my-eshell-reset-flag-hook)


;; Local Variables:
;; byte-compile-warnings: (not free-vars unresolved)
;; End:
(provide '+misc)
;;; +misc.el ends here
