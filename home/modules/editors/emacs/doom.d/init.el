;;; init.el --- Init -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(doom! :input
       ;; chinese
       ;; japanese

       :completion
       company             ; the ultimate code completion backend
       ;; helm             ; the *other* search engine for love and life
       ;; ido              ; the other *other* search engine...
       ivy                 ; a search engine for love and life

       :ui
       ;; deft             ; notational velocity for Emacs
       doom                ; what makes DOOM look the way it does
       doom-dashboard      ; a nifty splash screen for Emacs
       doom-quit           ; DOOM quit-message prompts when you quit Emacs
       (emoji +unicode)    ; 🙂
       ;; fill-column      ; a `fill-column' indicator
       hl-todo             ; highlight TODO/FIXME/NOTE tags
       ;; indent-guides    ; highlighted indent columns
       ;; ligatures        ; ligatures and symbols to make your code pretty again
       modeline            ; snazzy, Atom-inspired modeline, plus API
       nav-flash           ; blink the current line after jumping
       ;; neotree          ; a project drawer, like NERDTree for vim
       ophints             ; highlight the region an operation acts on
       (popup              ; tame sudden yet inevitable temporary windows
        +all               ; catch all popups that start with an asterix
        +defaults)         ; default popup rules
       ;; tabs             ; a tab bar for Emacs
       treemacs            ; a project drawer, like neotree but cooler
       unicode             ; extended unicode support for various languages
       vc-gutter           ; vcs diff in the fringe
       vi-tilde-fringe     ; fringe tildes to mark beyond EOB
       window-select       ; visually switch windows
       workspaces          ; tab emulation, persistence & separate workspaces

       :editor
       (evil +everywhere)  ; come to the dark side, we have cookies
       file-templates      ; auto-snippets for empty files
       fold                ; (nigh) universal code folding
       ;; (format +onsave) ; automated prettiness
       ;; lispy            ; vim for lisp, for people who dont like vim
       multiple-cursors    ; editing in many places at once
       ;; parinfer         ; turn lisp into python, sort of
       rotate-text         ; cycle region at point between text candidates
       snippets            ; my elves. They type so I don't have to

       :emacs
       dired               ; making dired pretty [functional]
       electric            ; smarter, keyword-based electric-indent
       imenu               ; an imenu sidebar and searchable code index
       (undo +tree)        ; persistent, smarter undo for your inevitable mistakes
       vc                  ; version-control and Emacs, sitting in a tree

       :term
       eshell              ; the elisp shell that works everywhere
       ;; shell            ; simple shell REPL for Emacs
       term                ; basic terminal emulator for Emacs
       ;; vterm               ; the best terminal emulation in Emacs

       :checkers
       syntax              ; tasing you for every semicolon you forget
       ;; (spell +flyspell); tasing you for misspelling mispelling
       ;; grammar          ; tasing grammar mistake every you make

       :tools
       ansible
       ;; debugger         ; FIXME stepping through code, to help you add bugs
       direnv
       docker
       ;; editorconfig     ; let someone else argue about tabs vs spaces
       ;; ein              ; tame Jupyter notebooks with emacs
       eval                ; run code, run (also, repls)
       ;; gist             ; interacting with github gists
       (lookup             ; helps you navigate your code and documentation
        +docsets)          ; ...or in Dash docsets locally
       lsp
       magit               ; a git porcelain for Emacs
       ;; make             ; run make tasks from Emacs
       pass                ; password manager for nerds
       pdf                 ; pdf enhancements
       ;; prodigy          ; FIXME managing external services & code builders
       rgb                 ; creating color strings
       ;; terraform        ; infrastructure as code
       tmux                ; an API for interacting with tmux
       upload              ; map local to remote projects via ssh/ftp
       ;; wakatime

       :os
       (:if IS-MAC macos)  ; improve compatibility with macOS
       tty                 ; improve the terminal Emacs experience

       :lang
       ;; agda             ; types of types of types of types...
       assembly            ; assembly for fun or debugging
       (cc +lsp)           ; C > C++ == 1
       ;; clojure          ; java with a lisp
       ;; common-lisp      ; if you've seen one lisp, you've seen them all
       ;; coq              ; proofs-as-programs
       ;; crystal          ; ruby at the speed of c
       ;; csharp           ; unity, .NET, and mono shenanigans
       data                ; config/data formats
       ;; (dart
       ;;  +lsp
       ;;  +flutter)       ; paint ui and not much else
       ;; erlang           ; an elegant language for a more civilized age
       (elixir +lsp)       ; erlang done right
       ;; (elm +lsp)       ; care for a cup of TEA?
       emacs-lisp          ; drown in parentheses
       ;; ess              ; emacs speaks statistics
       (go +lsp)           ; the hipster dialect
       ;; (haskell +dante) ; a language that's lazier than I am
       ;; hy               ; readability of scheme w/ speed of python
       ;; idris
       ;; (java +meghanada); the poster child for carpal tunnel syndrome
       (javascript +lsp)   ; all(hope(abandon(ye(who(enter(here))))))
       ;; julia            ; a better, faster MATLAB
       ;; kotlin           ; a better, slicker Java(Script)
       latex               ; writing papers in Emacs has never been so fun
       ;; ledger           ; an accounting system in Emacs
       (lua +lsp)          ; one-based indices? one-based indices
       markdown            ; writing docs for people to ignore
       ;; nim              ; python + lisp at the speed of c
       (nix +lsp)          ; I hereby declare "nix geht mehr!"
       ;; ocaml            ; an objective camel
       (org                ; organize your plain life in plain text
        +pretty            ; yessss my pretties! (nice unicode symbols)
        +attach            ; custom attachment system
        +babel             ; running code in org
        +capture           ; org-capture in and outside of Emacs
        +export            ; Exporting org to whatever you want
        +habit             ; Keep track of your habits
        +present           ; Emacs for presentations
        +protocol)         ; Support for org-protocol:// links
       ;; perl             ; write code no one else can comprehend
       ;; php              ; perl's insecure younger brother
       plantuml            ; diagrams for confusing people more
       ;; purescript       ; javascript, but functional
       (python +lsp)       ; beautiful is better than ugly
       ;; qt               ; the 'cutest' gui framework ever
       ;; racket           ; a DSL for DSLs
       rest                ; Emacs as a REST client
       ;; ruby             ; 1.step {|i| p "Ruby is #{i.even? ? 'love' : 'life'}"}
       (rust +lsp)         ; Fe2O3.unwrap().unwrap().unwrap().unwrap()
       ;; scala            ; java, but good
       sh                  ; she sells (ba|z|fi)sh shells on the C xor
       ;; solidity         ; do you need a blockchain? No.
       ;; swift            ; who asked for emoji variables?
       ;; terra            ; Earth and Moon in alignment for performance.
       web                 ; the tubes
       ;; vala             ; GObjective-C

       :email
       (:if (executable-find "mu") (mu4e +org +gmail))
       ;; notmuch
       ;; (wanderlust +gmail)

       :app
       ;; calendar
       everywhere          ; *leave* Emacs!? You must be joking
       ;; irc              ; how neckbeards socialize
       (rss +org)          ; emacs as an RSS reader
       twitter             ; twitter client https://twitter.com/vnought
       ;; (write           ; emacs as a word processor (latex + org + markdown)
       ;;  +wordnut        ; wordnet (wn) search
       ;;  +langtool)      ; a proofreader (grammar/style check) for Emacs

       :config
       ;; literate
       (default +bindings +smartparens))

;; Local Variables:
;; byte-compile-warnings: (not free-vars unresolved)
;; End:
(provide 'init.el)
;;; init.el ends here
