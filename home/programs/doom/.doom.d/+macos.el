;; (load! "+animations")

;; disable option
(setq mac-option-modifier nil)

;; increase fringe to see diff
;; while using window border
(setq +vc-gutter-in-margin t)

(defun set-fringe ()
  "Set fringe."
  (fringe-mode '(15 . 10)))

(add-hook 'prog-mode-hook 'set-fringe)
