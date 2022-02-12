;;; +text.el --- Text

;;; Commentary:

;;; Code:

;; org
(setq org-directory "~/dev/org"
      org-latex-packages-alist '(("AUTO" "babel" t)
                                 ("T2A" "fontenc" t)))

(after! org-superstar
  (setq org-superstar-headline-bullets-list '(?◉ ?○ ?✸ ?✿ ?✤ ?✜ ?◆)
        org-superstar-item-bullet-alist '((42 . ?⌬) (43 . ?◐) (45 . ?➜))
        org-superstar-prettify-item-bullets t))


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
