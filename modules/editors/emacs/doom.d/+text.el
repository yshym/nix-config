;;; +text.el --- Text -*- lexical-binding: t -*-

;;; Commentary:

;;; Code:

;; org
(after! org
  (setq org-directory "~/dev/org"
        org-latex-packages-alist '(("AUTO" "babel" t)
                                   ("T2A" "fontenc" t))
        +org-msg-accent-color "#282a36"
        org-lowest-priority ?D)

  (after! org-modern
    (setq org-modern-star 'replace
          org-modern-table nil)))


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
