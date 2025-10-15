;;; +ui.el --- UI

;;; Commentary:

;;; Code:

;; Font
(setq doom-font (font-spec
                 :family "JetBrains Mono"
                 ;; :size (if IS-MAC 15 12)
                 :size 15
                 :weight 'normal))
(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :config
  (set-face-attribute 'mode-line nil
                      :family "JetBrains Mono"
                      :height (if IS-MAC 150 100))
  (set-face-attribute 'mode-line-inactive nil
                      :family "JetBrains Mono"
                      :height (if IS-MAC 150 100)))

;; Theme
(setq doom-theme 'doom-dracula)

(after! doom-themes
  (setq doom-modeline-major-mode-icon t))


;; Cursor
(setq evil-default-cursor '(t "DarkGoldenrod1")
      evil-normal-state-cursor '(box "DarkGoldenrod1")
      evil-insert-state-cursor '(bar "DarkGoldenrod1")
      evil-visual-state-cursor '(hollow "DarkGoldenrod1")
      evil-operator-state-cursor '(evil-half-cursor "DarkGoldenrod1"))

;; Local Variables:
;; byte-compile-warnings: (not free-vars unresolved)
;; End:
(provide '+ui)
;;; +ui.el ends here
