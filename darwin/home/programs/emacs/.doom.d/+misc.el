;; evil
(global-undo-tree-mode)
(evil-set-undo-system 'undo-tree)
;; Switch to the new window after splitting
(setq evil-split-window-below t
      evil-vsplit-window-right t)

;; direnv
(use-package! direnv
 :config
 (direnv-mode))


;; terminal
(setq evil-escape-excluded-major-modes (delete 'vterm-mode evil-escape-excluded-major-modes))

(defun open-popup-terminal ()
  "Toggle a terminal popup window."
  (interactive)
  (select-window (split-window-vertically))
  (+vterm/here t)
  (+popup--init (selected-window))
  (evil-window-set-height 15))


;; trello
(defun org-trello-sync-buffer-from-trello ()
  "Sync Trello buffer."
  (interactive)
  (org-trello-sync-buffer t))


;; agenda
(setq org-agenda-files '("~/dev/org/"))

(setq org-agenda-custom-commands
      '(("c" "Custom agenda view"
         ((agenda ""
                  ((org-agenda-overriding-header "Today's agenda")
                   (org-agenda-start-day "4d")
                   (org-agenda-span 1)))
          (agenda "" ((org-agenda-overriding-header "10 days' agenda")))
          (alltodo "" ((org-agenda-overriding-header "All tasks")))))))



;; plantuml
(setq org-plantuml-jar-path
      (expand-file-name "/Users/yevhenshymotiuk/dev/plantuml/plantuml.jar"))


;; alert
(setq alert-default-style 'notifier)

;; mu4e
(setq user-mail-address "yevhenshymotiuk@gmail.com")
(after! mu4e
  (setq mu4e-get-mail-command "/Users/yevhenshymotiuk/.local/bin/offlineimap.sh"
        mu4e-update-interval 300
        send-mail-function 'smtpmail-send-it
        smtpmail-smtp-server "smtp.gmail.com"
        smtpmail-smtp-service 587
        mu4e-headers-fields '((:flags . 6)
                              ;; (:account . 2)
                              (:from-or-to . 25)
                              ;; (:folder . 10)
                              ;; (:recipnum . 2)
                              (:subject . 80)
                              (:human-date . 8))
        +mu4e-min-header-frame-width 142
        mu4e-headers-date-format "%d/%m/%y"
        mu4e-headers-time-format "⧖ %H:%M"
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

(mu4e-alert-set-default-style 'notifier)
(add-hook 'after-init-hook #'mu4e-alert-enable-notifications)
(add-hook 'after-init-hook #'mu4e-alert-enable-mode-line-display)

;; emacs-everywhere
(when (daemonp)
  (use-package! emacs-everywhere))
