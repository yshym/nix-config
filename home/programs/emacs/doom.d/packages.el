;; -*- no-byte-compile: t; -*-
;;; ~/.doom.d/packages.el

(package! ansi-color)
(package! atomic-chrome)
(package! direnv)
(package! elisp-format)
(package! org-trello)
;; TODO Remove when relevant PR is merged
(unpin! pdf-tools)
(package! pdf-tools :recipe
  (:host github
   :repo "yevhenshymotiuk/pdf-tools"
   :branch "nixos-without-nix-path"))
(package! poetry)
(package! protobuf-mode)
(package! undo-tree)
(package! verb)
