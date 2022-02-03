;;; +text.el --- Text

;;; Commentary:

;;; Code:

(setq org-directory "~/dev/org")


;; org-latex
(setq org-latex-packages-alist
      '(("AUTO" "babel" t)
        ("T2A" "fontenc" t)))


;; ligatures
(when (featurep! :ui ligatures)
  (after! org
    (set-ligatures! 'org-mode
      :name "#+NAME:"
      :src_block "#+BEGIN_SRC"
      :src_block_end "#+END_SRC"
      :alist '(("[ ]" . "")
               ("[X]" . "")
               ("[-]" . "")
               ("SCHEDULED:" . "")
               ("DEADLINE:" . "")
               ("#+begin_src" . "«")
               ("#+end_src" . "»")))))

;; Local Variables:
;; byte-compile-warnings: (not free-vars unresolved)
;; End:
(provide '+text)
;;; +text.el ends here
