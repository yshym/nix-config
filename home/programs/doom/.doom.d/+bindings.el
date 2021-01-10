;; evil-escape-key-sequence
(setq evil-escape-key-sequence "fd")

;; web
(map! (:after web-mode
        (:map web-mode-map
          "TAB" nil
          "TAB" 'emmet-expand-yas)))


;; company
(map! (:after company
        (:map company-active-map
          "<tab>" nil
          "TAB" 'company-complete-selection)))


;; <leader>
(map! :leader
      :desc "Open swiper" "S" 'swiper
      :desc "Toggle terminal in popup" "o t" 'open-popup-terminal
      :desc "Open mu4e" "m" 'mu4e
      :desc "Kill buffer" "b k" 'kill-this-buffer)
