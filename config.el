;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Per-Karsten Nordhaug"
      user-mail-address "flaggerkatt@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "Menlo" :size 12))

(setq doom-font (font-spec :family "JetBrains Mono" :size 12)
      doom-variable-pitch-font (font-spec :family "Overpass" :size 12)
      doom-big-font (font-spec :family "JetBrains Mono" :size 14))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-wilmersdorf)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Dropbox/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

(setq fancy-splash-image (concat doom-private-dir "splash/doom-emacs-color.png"))

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.

;; Clearing some unwanted keybindigs
;;
(global-set-key (kbd "C-z") nil)
(global-set-key (kbd "M-z") nil)
(global-set-key (kbd "M-/") nil)


;; Standard placement
(add-to-list 'default-frame-alist '(top . 12))
(add-to-list 'default-frame-alist '(left . 1))
(add-to-list 'default-frame-alist '(width . 148))
(add-to-list 'default-frame-alist '(height . 47))
(add-to-list 'default-frame-alist '(inhibit-double-buffering . t))
(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
(add-to-list 'default-frame-alist '(ns-appearance . dark))


;; Basic settings for swiper/counsel: search with C-s, buffer-switching with C-x b
(global-set-key (kbd "C-s") 'swiper)
(global-set-key (kbd "C-z s") 'counsel-rg)
(global-set-key (kbd "C-z b") 'counsel-buffer-or-recentf)
(global-set-key (kbd "C-x b") 'counsel-switch-buffer)
(global-set-key (kbd "<next>") 'forward-paragraph)
(global-set-key (kbd "<prior>") 'backward-paragraph)
; (global-set-key (kbd "C-c C-e") 'elfeed)
(global-set-key (kbd "s-b") 'switch-to-buffer)

;; YASnippets
;; Develop in ~/doom.d/snippets, but also try out snippets in ~/Dropbox/emacs/snippets
;;
(setq yas-snippet-dirs '("~/doom.d/snippets"
                         "~/Dropbox/emacs/snippets"))

;; Elfeed Configuration
;; An Emacs web feeds client
;;
;; functions to support .elfeed

(defun pkn/elfeed-load-db-and-open ()
  "Wrapper to load the elfeed db from disk before opening"
  (interactive)
  (elfeed)
  (elfeed-search-update--force))

;; write to disk when quiting
(defun pkn/elfeed-save-db-and-bury ()
  "Wrapper to save the elfeed db to disk before burying buffer"
  (interactive)
  (elfeed-db-save)
  (quit-window))

(defun elfeed-eww-open (&optional use-generic-p)
  "open with eww"
  (interactive "P")
  (let ((entries (elfeed-search-selected)))
    (cl-loop for entry in entries
             do (elfeed-untag entry 'unread)
             when (elfeed-entry-link entry)
             do (eww-browse-url it))
    (mapc #'elfeed-search-update-entry entries)
    (unless (use-region-p) (forward-line))))


(use-package! elfeed
  :bind (:map elfeed-search-mode-map
          ("q" . pkn/elfeed-save-db-and-bury)
		      ("Q" . pkn/elfeed-save-db-and-bury)
		      ("m" . elfeed-toggle-star)
		      ("M" . elfeed-toggle-star)
          ("j" . pkn/make-and-run-elfeed-hydra)
		      ("J" . pkn/make-and-run-elfeed-hydra)
          ("w" . elfeed-eww-open)
          ("W" . elfeed-eww-open)
          )
  :config
  (defalias 'elfeed-toggle-star
    (elfeed-expose #'elfeed-search-toggle-all 'star))
  )

(use-package! elfeed-goodies
  :config
  (elfeed-goodies/setup))

(use-package! elfeed-org
  :init
  (setq rmh-elfeed-org-files '("~/Dropbox/org/elfeed.org"))
  :config
  (elfeed-org))


;; Set deft directory and sorting
;;
;;

(use-package! deft
  :bind (("C-c C-d" . deft)
         ("C-x C-g" . deft-find-file))
  :commands (deft)
  :config (setq deft-directory "~/Dropbox/deft/"
                deft-extensions '("md" "org" "txt")
                deft-current-sort-method 'title
                deft-recursive t
                ))

;(global-set-key (kbd "C-x C-g") 'deft-find-file)

;;advise deft to save window config
(defun pkn-deft-save-windows (orig-fun &rest args)
  (setq pkn-pre-deft-window-config (current-window-configuration))
  (apply orig-fun args)
  )

(advice-add 'deft :around #'pkn-deft-save-windows)

;;function to quit a deft edit cleanly back to pre deft window
(defun pkn-quit-deft ()
  "Save buffer, kill buffer, kill deft buffer, and restore window config to the way it was before deft was invoked"
  (interactive)
  (save-buffer)
  (kill-this-buffer)
  (switch-to-buffer "*Deft*")
  (kill-this-buffer)
  (when (window-configuration-p pkn-pre-deft-window-config)
    (set-window-configuration pkn-pre-deft-window-config)
    )
  )

(global-set-key (kbd "C-c C-q") 'pkn-quit-deft)

;; Settings for org-mode and related shit
;;
;;

(setq org-agenda-files
      (quote (
              "~/Dropbox/deft"
              "~/Dropbox/org")))

;; set maximum indentation for description lists
(setq org-list-description-max-indent 5)

;; prevent demoting heading also shifting text inside sections
(setq org-adapt-indentation nil)

(use-package! org-sidebar)

(use-package! mastodon
  :config
  (mastodon-discover))

(setq mastodon-instance-url "https://mstdn.social")


;; ALL HAIL HYDRA?
;; Tie related commands into a family of short bindings with a common prefix - a hydra
;;

;; Major mode hydra and pretty-hydra
(use-package! major-mode-hydra
  :preface
  (defun with-faicon (icon str &optional height v-adjust)
    "Displays an icon from Font Awesome icon."
    (s-concat (all-the-icons-faicon icon :v-adjust (or v-adjust 0) :height (or height 1)) " " str))

  (defun with-alltheicon (icon str &optional height v-adjust)
    "Displays an icon from all-the-icon."
    (s-concat (all-the-icons-alltheicon icon :v-adjust (or v-adjust 0) :height (or height 1)) " " str))

  (defun with-fileicon (icon str &optional height v-adjust)
    "Displays an icon from the Atom File Icons package."
    (s-concat (all-the-icons-fileicon icon :v-adjust (or v-adjust 0) :height (or height 1)) " " str))

  (defun with-octicon (icon str &optional height v-adjust)
    "Displays an icon from the GitHub Octicons."
    (s-concat (all-the-icons-octicon icon :v-adjust (or v-adjust 0) :height (or height 1)) " " str))

  :bind
  ("M-SPC" . major-mode-hydra))

(major-mode-hydra-define emacs-lisp-mode nil
  ("Eval"
   (("b" eval-buffer "buffer")
    ("e" eval-defun "defun")
    ("r" eval-region "region"))
   "REPL"
   (("I" ielm "ielm"))
   "Test"
   (("t" ert "prompt")
    ("T" (ert t) "all")
    ("F" (ert :failed) "failed"))
   "Doc"
   (("d" describe-foo-at-point "thing-at-pt")
    ("f" describe-function "function")
    ("v" describe-variable "variable")
    ("i" info-lookup-symbol "info lookup"))
   "Quit"
   (("q" nil "quit"))))

(defvar pkn-window--title (with-faicon "windows" "Window Management" 1 -0.05))

;; Rearrange split windows

(defun split-window-horizontally-instead ()
  "Kill any other windows and re-split such that the current window is on the top half of the frame."
  (interactive)
  (let ((other-buffer (and (next-window) (window-buffer (next-window)))))
    (delete-other-windows)
    (split-window-horizontally)
    (when other-buffer
      (set-window-buffer (next-window) other-buffer))))

(defun split-window-vertically-instead ()
  "Kill any other windows and re-split such that the current window is on the left half of the frame."
  (interactive)
  (let ((other-buffer (and (next-window) (window-buffer (next-window)))))
    (delete-other-windows)
    (split-window-vertically)
    (when other-buffer
      (set-window-buffer (next-window) other-buffer))))

(pretty-hydra-define pkn-window (:foreign-keys warn :title pkn-window--title :quit-key "q")
  ("Actions"
   (("TAB" other-window "switch")
    ("x" ace-delete-window "delete")
    ("m" ace-delete-other-windows "maximize")
    ("s" ace-swap-window "swap")
    ("a" ace-select-window "select"))

   "Resize"
   (("h" move-border-left "←")
    ("j" move-border-down "↓")
    ("k" move-border-up "↑")
    ("l" move-border-right "→")
    ("n" balance-windows "balance")
    ("f" toggle-frame-fullscreen "toggle fullscreen"))

   "Split"
   (("b" split-window-right "horizontally")
    ("B" split-window-horizontally-instead "horizontally instead")
    ("v" split-window-below "vertically")
    ("V" split-window-vertically-instead "vertically instead"))

   "Zoom"
   (("+" text-scale-increase "in")
    ("-" text-scale-decrease "out")
    )))


;; Other hydras...
;; Zoom Hydra
(defhydra hydra-zoom (global-map "C-+")
  "zoom"
  ("g" text-scale-increase "in")
  ("l" text-scale-decrease "out")
  )

;; Move Hydra
(defhydra hydra-move (global-map "C-n")
  "move"
  ("n" next-line)
  ("p" previous-line)
  ("f" forward-char)
  ("b" backward-char)
  ("a" beginning-of-line)
  ("e" move-end-of-line)
  ("v" scroll-up-command)
  ;; Converting M-v to V here by analogy.
  ("V" scroll-down-command)
  ("l" recenter-top-bottom)
  )

;; Magit Hydra
(defhydra hydra-magit (global-map "C-c m")
  "magit"
  ("b" magit-blame "blame")
  ("c" magit-clone "clone")
  ("i" magit-init "init")
  ("l" magit-log-buffer-file "commit log (current file)")
  ("L" magit-log-current "commit log (project)")
  ("s" magit-status "status")
  )

;; Goto Hydra
(defhydra hydra-goto (global-map "C-x j")
  "goto"
  ("t" (lambda () (interactive)(move-to-window-line-top-bottom 0)) "top")
  ("b" (lambda () (interactive)(move-to-window-line-top-bottom -1)) "bottom")
  ("m" ((lambda () (interactive) ) () (interactive)(move-to-window-line-top-bottom)) "middle")
  ("e" (lambda () (interactive)(end-of-buffer)) "end")
  ("c" recenter-top-bottom "recenter")
  ("n" next-line "down")
  ("p" (lambda () (interactive) (forward-line -1))  "up")
  ("g" goto-line "goto-line")
  )


;; Elfeed hydra


(defun pkn/hasCap (s) ""
	     (let ((case-fold-search nil))
	       (string-match-p "[[:upper:]]" s)
	       ))


(defun pkn/get-hydra-option-key (s)
  "returns single upper case letter (converted to lower) or first"
  (interactive)
  (let ( (loc (pkn/hasCap s)))
    (if loc
	      (downcase (substring s loc (+ loc 1)))
	    (substring s 0 1)
      )))

;;  (active blogs cs eDucation emacs local misc sports star tech unread webcomics)
(defun pkn/make-elfeed-cats (tags)
  "Returns a list of lists. Each one is line for the hydra configuratio in the form
       (c function hint)"
  (interactive)
  (mapcar (lambda (tag)
	          (let* (
		               (tagstring (symbol-name tag))
		               (c (pkn/get-hydra-option-key tagstring))
		               )
		          (list c (append '(elfeed-search-set-filter) (list (format "@2-week-ago +unread +%s" tagstring) ))tagstring  )))
	        tags))

(defmacro pkn/make-elfeed-hydra ()
  `(defhydra pkn/hydra-elfeed ()
     "filter"
     ,@(pkn/make-elfeed-cats (elfeed-db-get-all-tags))
     ("*" (elfeed-search-set-filter "@6-months-ago +star") "Starred")
     ("M" elfeed-toggle-star "Mark")
     ("A" (elfeed-search-set-filter "@2-week-ago +unread") "All")
     ("T" (elfeed-search-set-filter "@1-day-ago +unread") "Today")
     ("Q" pkn/elfeed-save-db-and-bury "Quit Elfeed" :color blue)
     ("q" nil "quit" :color blue)
     ))

(defun pkn/make-and-run-elfeed-hydra ()
  ""
  (interactive)
  (pkn/make-elfeed-hydra)
  (pkn/hydra-elfeed/body))


(defun my-elfeed-tag-sort (a b)
  (let* ((a-tags (format "%s" (elfeed-entry-tags a)))
         (b-tags (format "%s" (elfeed-entry-tags b))))
    (if (string= a-tags b-tags)
        (< (elfeed-entry-date b) (elfeed-entry-date a)))
    (string< a-tags b-tags)))


(setf elfeed-search-sort-function #'my-elfeed-tag-sort)


(setq elfeed-sort-order 'ascending)
(setq elfeed-search-filter "@2-week-ago +unread ")

(use-package! nyan-mode
  :custom
  (nyan-cat-face-number 4)
  (nyan-animate-nyancat nil)
  :hook
  (doom-modeline-mode . nyan-mode)
  )

;;
;; ALL HAIL HYDRA!

;; EXPERIMENTAL
;;

;; elfeed-dashbboard
(use-package elfeed-dashboard
  :load-path "~/Code/elfeed-dashboard/"
  :config (setq elfeed-dashboard-file "~/Code/elfeed-dashboard/elfeed-dashboard.org"))

(use-package! org-web-tools
  :config (setq org-web-tools-pandoc-sleep-time 1.0))

;; Blogging shit
;;
(setq org-publish-project-alist
      '(("flaggerkatt.github.io" ;; my blog project (just a name)
         ;; Path to org files.
         :base-directory "~/Code/flaggerkatt.github.io/docs/_org"
         :base-extension "org"
         ;; Path to Jekyll Posts
         :publishing-directory "~/Code/flaggerkatt.github.io/docs/_posts"
         :recursive t
         :publishing-function org-html-publish-to-html
         :headline-levels 4
         :html-extension "html"
         :body-only t
         )))

;;
;; MU4e
;;

(add-to-list 'load-path "/usr/local/share/emacs/site-lisp/mu/mu4e")
(require 'mu4e)

(use-package mu4e-config
  :after mu4e
  :load-path "~/.config/mu4e")


;; Set default directory
(setq default-directory "~/")
