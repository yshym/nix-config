;;; +prog.el --- Prog -*- lexical-binding: t -*-

;;; Commentary:

;;; Code:

;; magit
(add-hook! 'magit-mode-hook 'magit-todos-mode)
(setq magit-todos-exclude-globs '(".git/" "*.html" "*.json"))


;; company
;; (add-hook 'text-mode-hook 'global-company-mode)

;; (setq company-idle-delay 0.2
;;       company-minimum-prefix-length 2)


;; flycheck
(setq-default flycheck-disabled-checkers
              '(python-flake8
                python-pycompile))


;; lsp
;; (use-package! lsp-mode
;;   :commands lsp
;;   :diminish lsp-mode
;;   :config
;;   (setq lsp-dart-sdk-dir (getenv "DARTPATH")
;;         lsp-gopls-codelens nil
;;         lsp-pylsp-plugins-flake8-enabled nil
;;         lsp-pylsp-plugins-pylint-enabled t
;;         lsp-pylsp-plugins-pylint-args ["--rcfile ~/.config/pylint/config"]
;;         lsp-pylsp-plugins-pydocstyle-enabled nil)
;;   :hook
;;   (elixir-mode . 'lsp)
;;   :init
;;   (add-to-list
;;    'exec-path
;;    (concat (getenv "HOME") "/dev/elixir/elixir-ls/release")))

(add-hook 'eglot-managed-mode-hook
          (lambda ()
            (eglot-inlay-hints-mode -1)
            (setq eglot-semantic-token-types nil)))


;; snippets
(require 'yasnippet)
(doom-snippets-initialize)


;; prog
(add-hook 'prog-mode-hook 'smartparens-mode)


;; web-mode
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))

(after! web-mode
  (setq web-mode-enable-auto-pairing nil))

(sp-with-modes '(web-mode)
  (sp-local-pair "%" "%" :post-handlers '(("| " "SPC")))
  (sp-local-pair "=" "" :post-handlers '(("| " "SPC"))))

(sp-with-modes '(python-mode)
  (sp-local-pair "f\"" "\"" :post-handlers '(("| " "SPC")))
  (sp-local-pair "b\"" "\"" :post-handlers '(("| " "SPC"))))

(sp-local-pair 'web-mode "<" ">" :actions nil)

(add-hook 'web-mode-hook 'emmet-mode)


;; c
(setq flycheck-gcc-include-path '("/usr/local/include"))
(defun c-flycheck-setup ()
  "Setup Flycheck checkers for C."
  (flycheck-select-checker 'c/c++-gcc))
(add-hook 'c-mode-hook 'c-flycheck-setup)


;; python
(defun black-format ()
  "Format current file using Black formatter."
  (interactive)
  (print
   (shell-command-to-string
    (concat
     "black.sh "
     (store-substring
      (projectile-project-root)
      (- (length (projectile-project-root)) 1)
      " ")
     (buffer-file-name)))))

(defun set-pylint-executable ()
  "Set pylint executable based on venv path."
  (setq venv-path (getenv "VIRTUAL_ENV"))
  (setq flycheck-python-pylint-executable
        (if venv-path
            (concat venv-path "/bin/pylint")
            "pylint")))

(add-hook 'python-mode-hook (λ! (electric-indent-local-mode -1)))
(add-hook 'python-mode-hook 'set-pylint-executable)


;; go
(add-to-list
   'exec-path
   (concat (getenv "HOME") "/go/bin"))

(defun gofmt ()
  "Format current file using golines and gofumpt formatters."
  (interactive)
  (shell-command-to-string
   (concat
    "golines -w -m 80 "
    (buffer-file-name)
    "&& gofumpt -w "
    (buffer-file-name))))

(defun gomodifytags ()
  "Add tags for all structs of the current buffer."
  (interactive)
  (shell-command-to-string
    (concat
      "gomodifytags -add-tags json -all -w -file "
      (buffer-file-name)))
  (revert-buffer))


;; protobuf
(add-hook 'protobuf-mode-hook 'display-line-numbers-mode)
(add-hook 'protobuf-mode-hook 'hl-line-mode)


;; nix
(after! nix-mode
  (setq nix-nixfmt-bin "nixpkgs-fmt"))

;; Local Variables:
;; byte-compile-warnings: (not free-vars unresolved)
;; End:
(provide 'prog)
;;; +prog.el ends here
