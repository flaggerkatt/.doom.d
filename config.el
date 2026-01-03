;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Per-Karsten Nordhaug"
      user-mail-address "flaggerkatt@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
(setq doom-font (font-spec :family "Roboto Mono" :size 12)
      doom-variable-pitch-font (font-spec :family "Overpass" :size 12)
      doom-big-font (font-spec :family "Roboto Mono" :size 15))
;;
;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'nano-dark)
(setq doom-theme 'nano-dark)

(use-package! catppuccin-theme
  )

(use-package! ef-themes)

;; (setq catppuccin-flavor 'mocha) ;; or 'latte, 'macchiato, or 'mocha
;; (catppuccin-reload)

;; numbers are disabled. For relative line numbers, set this to `relative'.
;; This determines the style of line numbers in effect. If set to `nil', line
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")
(setq org-default-notes-file (concat org-directory "~/org/"))

;; Some visuals
;; Doom buffer and frame titles
(setq doom-fallback-buffer-name "► Doom Emacs"
      +doom-dashboard-name "► Doom Emacs")

(add-load-path! "~/.config/doom/misc")

;; Dashboard config
(map! :leader :desc "Dashboard" "d" #'+doom-dashboard/open)
;; Strip unnecessary stuff (comment out first line to actually show menu)
;; (remove-hook '+doom-dashboard-functions #'doom-dashboard-widget-shortmenu)
;; (add-hook! '+doom-dashboard-mode-hook (hide-mode-line-mode 1) (hl-line-mode -1))
;; (setq-hook! '+doom-dashboard-mode-hook evil-normal-state-cursor (list nil))
(setq fancy-splash-image "~/.config/doom/splash/doomguy.png")
;; (add-hook! '+doom-dashboard-functions :append
;;   (insert "\n" (+doom-dashboard--center +doom-dashboard--width "All hail Discordia!")))

;; Global mapped shortcuts
(map! :leader :desc "Elfeed" "o e" #'elfeed)
(map! :leader :desc "Switch buffer" "b b" #'consult-buffer)

;; Zetteldeft mapping
(map!
 :leader
 :desc "Launch Zetteldeft" :gn "n SPC" #'zetteldeft-deft-new-search
 :desc "New File" :gn "z n" #'zetteldeft-new-file
 :desc "New File and Link" :gn "z N" #'zetteldeft-deft-new-search-and-link
 )

;; Mappings for consult/embark
(global-set-key (kbd "C-s") 'consult-line)
(global-set-key (kbd "C-x b") 'consult-buffer)
(global-set-key (kbd "C-.") 'embark-act)

;; Buffer movement
;; Moving about the buffer
(global-set-key (kbd "<next>") 'forward-paragraph)
(global-set-key (kbd "<prior>") 'backward-paragraph)
(global-set-key (kbd "<home>") 'doom/backward-to-bol-or-indent)
(global-set-key (kbd "<end>") 'doom/forward-to-last-non-comment-or-eol)
(global-set-key (kbd "C-<home>") 'beginning-of-buffer)
(global-set-key (kbd "C-<prior>") 'beginning-of-buffer)
(global-set-key (kbd "C-<end>") 'end-of-buffer)
(global-set-key (kbd "C-<next>") 'end-of-buffer)


;; Make doom look nice(r?) on mac
(add-to-list 'default-frame-alist '(inhibit-double-buffering . t))
(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
(add-to-list 'default-frame-alist '(ns-appearance . dark))
(setq ns-use-proxy-icon nil)

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.


;; Elfeed - Newsfeeds and other rss'es in emacs. What's not to love?

;; Load elfeed-goodies
(use-package! elfeed-goodies
  :config
  (elfeed-goodies/setup)
  :init
  (setq elfeed-goodies/entry-pane-size 0.7))

;; Load elfeed-org
(use-package! elfeed-org
  :init
  (setq rmh-elfeed-org-files '("~/org/elfeed.org"))
  :config
  (elfeed-org))

(after! elfeed

  (setq elfeed-search-filter "@2-week-ago +unread"
        elfeed-search-title-min-width 80
        elfeed-sort-order 'ascending
        shr-max-image-proportion 0.6)

  ;; Map keys in elfeed search-mode-map
  (map! :map elfeed-search-mode-map
        :after elfeed-search
        :n doom-leader-key nil
        :n "e" #'elfeed-update
        :n "r" #'elfeed-search-untag-all-unread
        :n "u" #'elfeed-search-tag-all-unread
        :n "s" #'elfeed-search-live-filter
        :n "RET" #'elfeed-search-show-entry
        :n "+" #'elfeed-search-tag-all
        :n "-" #'elfeed-search-untag-all
        :n "S" #'elfeed-search-set-filter
        :n "b" #'elfeed-search-browse-url
        :n "y" #'elfeed-search-yank
        :n "a" #'elfeed-curate-edit-entry-annoation
        :n "x" #'elfeed-curate-export-entries
        :n "m" #'elfeed-curate-toggle-star)

  (map! :map elfeed-show-mode-map
        :after elfeed-show
        [remap kill-this-buffer] "q"
        [remap kill-buffer] "q"
        :n doom-leader-key nil
        :nm "q" #'+rss/delete-pane
        :nm "n" #'elfeed-show-next
        :nm "p" #'elfeed-show-prev
        :nm "+" #'elfeed-show-tag
        :nm "-" #'elfeed-show-untag
        :nm "s" #'elfeed-show-new-live-search
        :nm "y" #'elfeed-show-yank
        :n "a" #'elfeed-curate-edit-entry-annoation
        :n "m" #'elfeed-curate-toggle-star)
  )

;; Use minions to hide minor modes
(use-package! minions
  :config
  (setq minions-mode-line-lighter ""
        minions-mode-line-delimiters '("" . ""))
  (minions-mode 1))


;; GPG settings
;;
(setq epa-pinentry-mode 'loopback)

;; Mu4e settings
;; 

(set-email-account! "Gmail"
                    '((mu4e-sent-folder       . "/Gmail/Sent")
                      (mu4e-drafts-folder     . "/Gmail/Drafts")
                      (mu4e-trash-folder      . "/Gmail/Trash")
                      (mu4e-refile-folder     . "/Gmail/Archive")
                      (smtpmail-smtp-user     . "flaggerkatt@gmail.com")
                      (user-mail-address      . "flaggerkatt@gmail.com")    ;; only needed for mu < 1.4
                      (mu4e-compose-signature . "---\nPer-Karstem Nordhaug"))
                    t)

(setq +mu4e-gmail-accounts '(("flaggerkatt@gmail.com" . "/Gmail")
                             ))

;; don't need to run cleanup after indexing for gmail
(setq mu4e-index-cleanup nil
      ;; because gmail uses labels as folders we can use lazy check since
      ;; messages don't really "move"
      mu4e-index-lazy-check t)

(setq mu4e-maildir-shortcuts
      '((:maildir "/Gmail/Inbox"    :key ?i)
        (:maildir "/Gmail/Sent"         :key ?s)
        (:maildir "/Gmail/Trash"     :key ?t)
        (:maildir "/Gmail/Drafts"    :key ?d)
        (:maildir "/Gmail/Archive"  :key ?a)))

(setq mu4e-compose-in-new-frame t)
(setq mu4e-change-filenames-when-moving t)
(setq mu4e-attachment-dir  "~/Downloads")
(setq message-kill-buffer-on-exit t)
(setq mu4e-compose-dont-reply-to-self t)
(setq mu4e-view-show-addresses 't)

(after! mu4e
  (setq sendmail-program (executable-find "msmtp")
	send-mail-function #'smtpmail-send-it
	message-sendmail-f-is-evil t
	message-sendmail-extra-arguments '("--read-envelope-from")
	message-send-mail-function #'message-send-mail-with-sendmail))



;; Consult, Vertico, Corfu, Cape, Orderless, Embark
;; Completion and such!
;; fun fun fun!

(use-package! consult
  )

;; Vertico
;;
(use-package! vertico
  :init
  (vertico-mode)

  :config
  ;; Different scroll margin
  (setq vertico-scroll-margin 0)

  ;; Show more candidates
  (setq vertico-count 10)

  ;; Grow and shrink the Vertico minibuffer
  ;; (setq vertico-resize t)

  ;; Optionally enable cycling for `vertico-next' and `vertico-previous'.
  (setq vertico-cycle t)

  )

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package! savehist
  :init
  (savehist-mode)
  )

;; Use the `orderless' completion style.
(use-package! orderless
  :init
  :config
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (setq orderless-style-dispatchers '(+orderless-dispatch)
  ;;       orderless-component-separator #'orderless-escapable-split-on-space)
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-ignore-case t
        completion-category-overrides '((file (styles . (partial-completion)))))
  )

;; Corfu - Completion Overlay Region FUnction
(use-package! corfu
  :init
  (global-corfu-mode)
  :config
  (setq corfu-auto t
        )
  ;;       corfu-cycle t
  ;;       corfu-auto-delay 60.0        ; Delay before auto-completion shows up
  ;;       corfu-separator ?\s          ; Orderless field separator
  ;;       corfu-quit-at-boundary nil   ; Never quit at completion boundary
  ;;       corfu-quit-no-match t        ; Quit when no match
  ;;       corfu-preview-current nil    ; Disable current candidate preview
  ;;       corfu-preselect-first nil    ; Disable candidate preselection
  ;;       corfu-on-exact-match nil     ; Configure handling of exact matches
  ;;       corfu-echo-documentation nil ; Disable documentation in the echo area
  ;;       corfu-scroll-margin 5)
  )

;; Cape
(use-package! cape
  :init
  :config
  )

;; Use Dabbrev with Corfu!
(use-package! dabbrev
  :init
  ;; Swap M-/ and C-M-/
  :bind (("M-/" . dabbrev-completion)
         ("C-M-/" . dabbrev-expand))
  ;; Other useful Dabbrev configurations.
  :custom
  (dabbrev-ignored-buffer-regexps '("\\.\\(?:pdf\\|jpe?g\\|png\\)\\'"))
  )

;; Enable rich annotations using the Marginalia package
(use-package marginalia
  :init
  (marginalia-mode)
  ;; Either bind `marginalia-cycle' globally or only in the minibuffer
  :bind (("M-A" . marginalia-cycle)
         :map minibuffer-local-map
         ("M-A" . marginalia-cycle))
  )

;; Consult-mu - consult-like search for mu4e
;; 
(use-package! consult-mu)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Other stuff
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Nyan-cat? Yes.
(use-package! nyan-mode
  :config
  (nyan-mode 1))

;; Miscellenea
;;
(setq display-time-default-load-average nil)

;; Deadgrep for ripgrepping through space and time.
(use-package! deadgrep)

(use-package! grip-mode)

;; Path for PDFLatex

(getenv "PATH")
(setenv "PATH"
        (concat
         "/Library/TeX/texbin/" ":"
         (getenv "PATH")))

;; Beframe
(use-package! beframe)

;; Calibre

(use-package! calibredb
  :init
  :config
  (setq calibredb-root-dir "~/Dropbox/Documents/Calibre")
  (setq calibredb-db-dir (expand-file-name "metadata.db" calibredb-root-dir))
  )

(after! calibredb
  (map! :map calibredb-search-mode-map
        :after calibredb-search
        :n doom-leader-key nil)
  )

(use-package! gptel
  :init
  :config
  (auth-source-pass-enable)
  )

(use-package! auth-source-pass
  :init
  :config (auth-source-pass-enable))

;; Hercules
(use-package! hercules
  :init
  :config)

;; Denote
(use-package! denote
  :init
  :config
  (setq denote-directory "~/Dropbox/Documents/Notes")
  )

;; Logos
(use-package! logos
  :init
  :config
  )

;; Zetteldeft
(use-package! zetteldeft
  :config
  (setq deft-directory "~/Dropbox/Documents/Zettel")
  )

;; Set default directory
(setq default-directory "~/")
