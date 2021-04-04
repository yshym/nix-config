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
  (+vterm/toggle t)
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
(add-load-path! "~/.nix-profile/share/emacs/site-lisp/mu4e")
(after! mu4e
  ;; (defvar mu4e-reindex-request-file "/tmp/mu_reindex_now"
;;     "Location of the reindex request, signaled by existance")
;;   (defvar mu4e-reindex-request-min-seperation 5.0
;;     "Don't refresh again until this many second have elapsed.
;; Prevents a series of redisplays from being called (when set to an appropriate value)")

;;   (defvar mu4e-reindex-request--file-watcher nil)
;;   (defvar mu4e-reindex-request--file-just-deleted nil)
;;   (defvar mu4e-reindex-request--last-time 0)

;;   (defun mu4e-reindex-request--add-watcher ()
;;     (setq mu4e-reindex-request--file-just-deleted nil)
;;     (setq mu4e-reindex-request--file-watcher
;;           (file-notify-add-watch mu4e-reindex-request-file
;;                                  '(change)
;;                                  #'mu4e-file-reindex-request)))

;;   (defadvice! mu4e-stop-watching-for-reindex-request ()
;;     :after #'mu4e~proc-kill
;;     (if mu4e-reindex-request--file-watcher
;;         (file-notify-rm-watch mu4e-reindex-request--file-watcher)))

;;   (defadvice! mu4e-watch-for-reindex-request ()
;;     :after #'mu4e~proc-start
;;     (mu4e-stop-watching-for-reindex-request)
;;     (when (file-exists-p mu4e-reindex-request-file)
;;       (delete-file mu4e-reindex-request-file))
;;     (mu4e-reindex-request--add-watcher))

;;   (defun mu4e-file-reindex-request (event)
;;     "Act based on the existance of `mu4e-reindex-request-file'"
;;     (print "Hook called")
;;     (if mu4e-reindex-request--file-just-deleted
;;         (mu4e-reindex-request--add-watcher)
;;       (when (equal (nth 1 event) 'created)
;;         (delete-file mu4e-reindex-request-file)
;;         (setq mu4e-reindex-request--file-just-deleted t)
;;         (mu4e-reindex-maybe t))))

;;   (defun mu4e-reindex-maybe (&optional new-request)
;;     "Run `mu4e~proc-index' if it's been more than
;; `mu4e-reindex-request-min-seperation'seconds since the last request,"
;;     (let ((time-since-last-request (- (float-time)
;;                                       mu4e-reindex-request--last-time)))
;;       (when new-request
;;         (setq mu4e-reindex-request--last-time (float-time)))
;;       (if (> time-since-last-request mu4e-reindex-request-min-seperation)
;;           (mu4e~proc-index nil t)
;;         (when new-request
;;           (run-at-time (* 1.1 mu4e-reindex-request-min-seperation) nil
;;                        #'mu4e-reindex-maybe)))))
  (setq send-mail-function 'smtpmail-send-it
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

(use-package! mu4e-alert
  :after mu4e
  :config
  (mu4e-alert-set-default-style 'notifier)
  (mu4e-alert-enable-mode-line-display)
  (mu4e-alert-enable-notifications))
