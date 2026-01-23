;;; +ui.el --- UI -*- lexical-binding: t -*-

;;; Commentary:

;;; Code:

;; Font
(setq doom-font (font-spec
                 :family "JetBrains Mono"
                 ;; :size (if IS-MAC 15 12)
                 :size 15
                 :weight 'normal))

(set-face-attribute 'mode-line nil
                    :family "JetBrains Mono"
                    :height (if IS-MAC 150 100))
(set-face-attribute 'mode-line-inactive nil
                    :family "JetBrains Mono"
                    :height (if IS-MAC 150 100))


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
    `(corfu-current
      :background ,(doom-color 'base3)
      :extend t)))


;; Local Variables:
;; byte-compile-warnings: (not free-vars unresolved)
;; End:
(provide '+ui)
;;; +ui.el ends here
