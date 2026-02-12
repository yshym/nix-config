;;; +ui.el --- UI -*- lexical-binding: t -*-

;;; Commentary:

;;; Code:

;; Frame
(if (featurep :system 'macos)
    (progn
      (setq default-frame-alist '((undecorated-round . t)))
      (menu-bar-mode -1)))


;; Font
(setq doom-font (font-spec
                 :family "JetBrains Mono"
                 ;; :size (if (featurep :system 'macos) 15 12)
                 :size 15
                 :weight 'normal))

(custom-set-faces!
  `(mode-line          :family "JetBrains Mono" :height ,(if (featurep :system 'macos) 150 100))
  `(mode-line-inactive :family "JetBrains Mono" :height ,(if (featurep :system 'macos) 150 100)))


;; Theme
(setq doom-theme 'doom-dracula)
(after! doom-themes
  (setq doom-modeline-major-mode-icon t)

  ;; Customize cursor shape and color
  ;; (setq evil-default-cursor `(t ,cursor-color)
  ;;       evil-normal-state-cursor `(box ,cursor-color)
  ;;       evil-insert-state-cursor `(bar ,cursor-color)
  ;;       evil-visual-state-cursor `(hollow ,cursor-color)
  ;;       evil-operator-state-cursor `(evil-half-cursor ,cursor-color))

  (custom-set-faces!
    ;; Cursor
    `(cursor :background ,(doom-color 'orange))
    ;; Corfu
    `(corfu-current :background ,(doom-color 'base3) :extend t)))


;; consult
(custom-set-faces!
  `(consult-file :foreground ,(doom-color `base5))
  `(consult-highlight-match :foreground ,(doom-color `violet) :background ,(doom-color `base3)))

;; Modeline
;; Override modeline buffer id behaviour
(def-modeline-var! +modeline-buffer-identification ; slightly more informative buffer id
                   '((:eval
                      (propertize
                       (or +modeline--buffer-id-cache "%b")
                       'face (cond ((buffer-modified-p) '(warning bold mode-line-buffer-id))
                                   ((+modeline-active)  'mode-line-buffer-id))
                       'help-echo (or +modeline--buffer-id-cache (buffer-name))))
                     (buffer-read-only (:propertize " RO" face warning))))

;; Local Variables:
;; byte-compile-warnings: (not free-vars unresolved)
;; End:
(provide '+ui)
;;; +ui.el ends here
