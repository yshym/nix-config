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


;; verb
(map! (:after verb
        (:map verb-mode-map
          "C-c v" 'verb-send-request-on-point)))


;; <leader>
(map! :leader
      :desc "Open swiper" "S" 'swiper
      :desc "Open terminal in popup" "o t" 'toggle-popup-terminal
      :desc "Open mu4e" "M" 'mu4e
      :desc "Kill buffer" "b k" 'kill-this-buffer)
