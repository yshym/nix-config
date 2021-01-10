;; evil
(global-undo-tree-mode)
(evil-set-undo-system 'undo-tree)

;; direnv
(use-package! direnv
 :config
 (direnv-mode))


;; term
(defun current-directory()
  "Return current directory."
  (file-name-directory (buffer-file-name)))

(defun term-send-cd()
  "Change directory in the terminal."
  (term-send-string
    (get-buffer-process "*terminal*")
    (format "cd %s\n%s\n" (current-directory) "clear")))

(defun open-terminal()
  "Open terminal in a new window."
  (interactive)
  (cond
   ((not (get-buffer-window "*terminal*"))
    (progn
      (pop-to-buffer (save-window-excursion (+term/here))
                     (evil-window-set-height 15)))

    (t (progn
         (term-send-cd)
         (select-window (get-buffer-window "*terminal*")))))))

(defun open-popup-terminal()
  "Open terminal in popup buffer."
  (interactive)
  (+term/toggle t)
  (evil-window-set-height 15))


;; trello
(defun org-trello-sync-buffer-from-trello()
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


;; mu4e
;; (after! mu4e
;;   (setq mu4e-get-mail-command "/home/yevhens/.local/bin/offlineimap.sh"
;;         mu4e-update-interval 300
;;         send-mail-function (quote smtpmail-send-it)
;;         smtpmail-smtp-server "smtp.gmail.com"
;;         smtpmail-smtp-service 587))

;; (mu4e-alert-set-default-style 'libnotify)
;; (add-hook 'after-init-hook #'mu4e-alert-enable-notifications)
;; (add-hook 'after-init-hook #'mu4e-alert-enable-mode-line-display)
