;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "Roboto Mono" :size 12)
      doom-variable-pitch-font (font-spec :family "Overpass" :size 12)
      doom-big-font (font-spec :family "Roboto Mono" :size 15))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-nord)

;; Dashboard config
(map! :leader :desc "Dashboard" "d" #'+doom-dashboard/open)
;; Strip unnecessary stuff (comment out first line to actually show menu)
;; (remove-hook '+doom-dashboard-functions #'doom-dashboard-widget-shortmenu)
(add-hook! '+doom-dashboard-mode-hook (hide-mode-line-mode 1) (hl-line-mode -1))
(setq-hook! '+doom-dashboard-mode-hook evil-normal-state-cursor (list nil))
(setq fancy-splash-image "~/.doom.d/splash/lego-space-transparent.png")
;; (setq fancy-splash-image "~/.doom.d/splash/doom-emacs-color3.png")

;; Org Prep
;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/.org/")
(setq org-default-notes-file (concat org-directory "~/.org/"))
(setq org-agenda-files (list "~/.org/inbox.org"
                             "~/.org/notes.org"
                             "~/.org/projects.org"
                             "~/.org/todo.org")
      org-agenda-diary-file "~/.org/journal.org")

(setq org-capture-templates
      `(("i" "Inbox" entry  (file "inbox.org")
         ,(concat "* TODO %?\n"
                  "/Entered on/ %U"))))
(defun org-capture-inbox ()
  (interactive)
  (call-interactively 'org-store-link)
  (org-capture nil "i"))

(define-key global-map (kbd "C-c n i") 'org-capture-inbox)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys

;; Additional load-paths; "misc" for random stuff, and the brew-installed mu4e
(add-load-path! "~/.doom.d/misc"
                "/usr/local/share/emacs/site-lisp/mu/mu4e")

;; Clearing some unwanted keybindigs
;;
(global-set-key (kbd "C-z") nil)
(global-set-key (kbd "M-/") nil)

;; Doom buffer and frame titles
(setq doom-fallback-buffer-name "► Doom"
      +doom-dashboard-name "► Doom")

(setq frame-title-format
      '(""
        (:eval
         (if (s-contains-p org-roam-directory (or buffer-file-name ""))
             (replace-regexp-in-string
              ".*/[0-9]*-?" "☰ "
              (subst-char-in-string ?_ ?  buffer-file-name))
           "%b"))
        (:eval
         (let ((project-name (projectile-project-name)))
           (unless (string= "-" project-name)
             (format (if (buffer-modified-p)  " ◉ %s" "  ●  %s") project-name))))))


;; Make doom look nice(r?) on mac
(add-to-list 'default-frame-alist '(inhibit-double-buffering . t))
(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
(add-to-list 'default-frame-alist '(ns-appearance . dark))
(setq ns-use-proxy-icon nil)

;; Escape! from minibuffers and the likes
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Moving about the buffer
(global-set-key (kbd "<next>") 'forward-paragraph)
(global-set-key (kbd "<prior>") 'backward-paragraph)
(global-set-key (kbd "<home>") 'doom/backward-to-bol-or-indent)
(global-set-key (kbd "<end>") 'doom/forward-to-last-non-comment-or-eol)
(global-set-key (kbd "C-<home>") 'beginning-of-buffer)
(global-set-key (kbd "C-<prior>") 'beginning-of-buffer)
(global-set-key (kbd "C-<end>") 'end-of-buffer)
(global-set-key (kbd "C-<next>") 'end-of-buffer)


;; Global mapped shortcuts
(map! :leader :desc "Mu4e" "C-u" #'mu4e)
(map! :leader :desc "Elfeed" "C-e" #'pkn/elfeed-load-db-and-open)
(map! :leader :desc "Mastodon" "C-a" #'mastodon)


;; Personal library
;; String related
;; A set of functions to join two strings such as to fit a given width. This will be used for displaying elfeed posts, privileging the right part (tag and feed).
(defun my/string-pad-right (len s)
  "If S is shorter than LEN, pad it on the right,
   if S is longer than LEN, truncate it on the right."

  (if (> (length s) len)
      (concat (substring s 0 (- len 1)) "…")
    (concat s (make-string (max 0 (- len (length s))) ?\ ))))
(defun my/string-pad-left (len s)
  "If S is shorter than LEN, pad it on the left,
   if S is longer than LEN, truncate it on the left."

  (if (> (length s) len)
      (concat  "…" (substring s (- (length s) len -1)))
    (concat (make-string (max 0 (- len (length s))) ?\ ) s)))
(defun my/string-join (len left right &optional spacing)
  "Join LEFT and RIGHT strings to fit LEN characters with at least SPACING characters
between them. If len is negative, it is retrieved from current window width."

  (let* ((spacing (or spacing 3))
         (len (or len (window-body-width)))
         (len (if (< len 0)
                  (+ (window-body-width) len)
                len)))
    (cond ((> (length right) len)
           (my/string-pad-left len right))

          ((> (length right) (- len spacing))
           (my/string-pad-left len (concat (make-string spacing ?\ )
                                           right)))

          ((> (length left) (- len spacing (length right)))
           (concat (my/string-pad-right (- len spacing (length right)) left)
                   (concat (make-string spacing ?\ )
                           right)))
          (t
           (concat left
                   (make-string (- len (length right) (length left)) ?\ )
                   right)))))

;; Date related
;; A set of date related functions, mostly used for mail display.

(defun my/date-day (date)
  "Return DATE day of month (1-31)."

  (nth 3 (decode-time date)))
(defun my/date-month (date)
  "Return DATE month number (1-12)."

  (nth 4 (decode-time date)))
(defun my/date-year (date)
  "Return DATE year."

  (nth 5 (decode-time date)))
(defun my/date-equal (date1 date2)
  "Check if DATE1 is equal to DATE2."

  (and (eq (my/date-day date1)
           (my/date-day date2))
       (eq (my/date-month date1)
           (my/date-month date2))
       (eq (my/date-year date1)
           (my/date-year date2))))
(defun my/date-inc (date &optional days months years)
  "Return DATE + DAYS day & MONTH months & YEARS years"

  (let ((days (or days 0))
        (months (or months 0))
        (years (or years 0))
        (day (my/date-day date))
        (month (my/date-month date))
        (year (my/date-year date)))
    (encode-time 0 0 0 (+ day days) (+ month months) (+ year years))))
(defun my/date-dec (date &optional days months years)
  "Return DATE - DAYS day & MONTH months & YEARS years"

  (let ((days (or days 0))
        (months (or months 0))
        (years (or years 0)))
    (my/date-inc date (- days) (- months) (- years))))
(defun my/date-today ()
  "Return today date."

  (current-time))
(defun my/date-is-today (date)
  "Check if DATE is today."

  (my/date-equal (current-time) date))
(defun my/date-is-yesterday (date)
  "Check if DATE is yesterday."

  (my/date-equal (my/date-dec (my/date-today) 1) date))
(defun my/date-relative (date)
  "Return a string with a relative date format."

  (let* ((now (current-time))
         (delta (float-time (time-subtract now date)))
         (days (ceiling (/ (float-time (time-subtract now date)) (* 60 60 24)))))
    (cond ((< delta (*       3 60))     "now")
          ((< delta (*      60 60))     (format "%d minutes ago" (/ delta   60)))
          ;;  ((< delta (*    6 60 60))     (format "%d hours ago"   (/ delta 3600)))
          ((my/date-is-today date)      (format-time-string "%H:%M" date))
          ((my/date-is-yesterday date)  (format "Yesterday"))
          ((< delta (* 4 24 60 60))     (format "%d days ago" (+ days 1)))
          (t                            (format-time-string "%d %b %Y" date)))))


;; Mini frame
;; A set of functions to create a mini-frame over the header line.

(defun my/mini-frame (&optional height foreground background border)
  "Create a child frame positionned over the header line whose
width corresponds to the width of the current selected window.

The HEIGHT in lines can be specified, as well as the BACKGROUND
color of the frame. BORDER width (pixels) and color (FOREGROUND)
can be also specified."

  (interactive)
  (let* ((foreground (or foreground
                         (face-foreground 'font-lock-comment-face nil t)))
         (background (or background (face-background 'highlight nil t)))
         (border (or border 1))
         (height (round (* (or height 8) (window-font-height))))
         (edges (window-pixel-edges))
         (body-edges (window-body-pixel-edges))
         (top (nth 1 edges))
         (bottom (nth 3 body-edges))
         (left (- (nth 0 edges) (or left-fringe-width 0)))
         (right (+ (nth 2 edges) (or right-fringe-width 0)))
         (width (- right left))

         ;; Window divider mode
         (width (- width (if (and (bound-and-true-p window-divider-mode)
                                  (or (eq window-divider-default-places 'right-only)
                                      (eq window-divider-default-places t))
                                  (window-in-direction 'right (selected-window)))
                             window-divider-default-right-width
                           0)))
         (y (- top border))
         (child-frame-border (face-attribute 'child-frame-border :background)))
    (set-face-attribute 'child-frame-border t :background foreground)
    (let ((frame (make-frame
                  `((parent-frame . ,(window-frame))
                    (delete-before . ,(window-frame))
                    (minibuffer . nil)
                    (modeline . nil)
                    (left . ,(- left border))
                    (top . ,y)
                    (width . (text-pixels . ,width))
                    (height . (text-pixels . ,height))
                    ;; (height . ,height)
                    (child-frame-border-width . ,border)
                    (internal-border-width . ,border)
                    (background-color . ,background)
                    (horizontal-scroll-bars . nil)
                    (menu-bar-lines . 0)
                    (tool-bar-lines . 0)
                    (desktop-dont-save . t)
                    (unsplittable . nil)
                    (no-other-frame . t)
                    (undecorated . t)
                    (pixelwise . t)
                    (visibility . t)))))
      (set-face-attribute 'child-frame-border t :background child-frame-border)
      frame)))
(defun my/mini-frame-reset (frame)
  "Reset FRAME size and position.

  Move frame at the top of parent frame and resize it
  horizontally to fit the width of current selected window."

  (interactive)
  (let* ((border (frame-parameter frame 'internal-border-width))
         (height (frame-parameter frame 'height)))
    (with-selected-frame (frame-parent frame)
      (let* ((edges (window-pixel-edges))
             (body-edges (window-body-pixel-edges))
             (top (nth 1 edges))
             (bottom (nth 3 body-edges))
             (left (- (nth 0 edges) (or left-fringe-width 0)))
             (right (+ (nth 2 edges) (or right-fringe-width 0)))
             (width (- right left))
             (y (- top border)))
        (set-frame-width frame width nil t)
        (set-frame-height frame height)
        (set-frame-position frame (- left border) y)))))
(defun my/mini-frame-shrink (frame &optional delta)
  "Make the FRAME DELTA lines smaller.

  If no argument is given, make the frame one line smaller. If
  DELTA is negative, enlarge frame by -DELTA lines."

  (interactive)
  (let ((delta (or delta -1)))
    (when (and (framep frame)
               (frame-live-p frame)
               (frame-visible-p frame))
      (set-frame-parameter frame 'height
                           (+ (frame-parameter frame 'height) delta)))))

;; Mail (mu4e) related functions.

(defun my/mu4e-get-account (msg)
  "Get MSG related account."

  (let* ((maildir (mu4e-message-field msg :maildir))
         (maildir (substring maildir 1)))
    (nth 0 (split-string maildir "/"))))
(defun my/mu4e-get-maildir (msg)
  "Get MSG related maildir."

  (let* ((maildir (mu4e-message-field msg :maildir))
         (maildir (substring maildir 1)))
    (nth 0 (reverse (split-string maildir "/")))))
(defun my/mu4e-get-mailbox (msg)
  "Get MSG related mailbox as 'account - maildir' "

  (format "%s - %s" (mu4e-get-account msg) (mu4e-get-maildir msg)))
(defun my/mu4e-get-sender (msg)
  "Get MSG sender."

  (let ((addr (cdr-safe (car-safe (mu4e-message-field msg :from)))))
    (mu4e~headers-contact-str (mu4e-message-field msg :from))))

;; End of Personal Library


;; Elfeed Configuration
;; An Emacs web feeds client

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

(use-package! elfeed
  :bind (:map elfeed-search-mode-map
              ("q" . pkn/elfeed-save-db-and-bury)
	      ("Q" . pkn/elfeed-save-db-and-bury)
              ("B" . bookmark-jump)
	      ("m" . elfeed-toggle-star)
	      ("M" . elfeed-toggle-star)
              )
  :config
  (elfeed-update)
  (elfeed-set-max-connections 32)

  (defalias 'elfeed-toggle-star
    (elfeed-expose #'elfeed-search-toggle-all 'star))

  (setq elfeed-show-entry-delete 'elfeed-goodies/delete-pane
        elfeed-show-entry-switch 'elfeed-goodies/switch-pane)

  )

(use-package! elfeed-goodies
  :config
  (elfeed-goodies/setup)
  :init
  (setq elfeed-goodies/entry-pane-size 0.7))

(use-package! elfeed-org
  :init
  (setq rmh-elfeed-org-files '("~/.org/elfeed.org"))
  :config
  (elfeed-org))

(defun my-elfeed-tag-sort (a b)
  (let* ((a-tags (format "%s" (elfeed-entry-tags a)))
         (b-tags (format "%s" (elfeed-entry-tags b))))
    (if (string= a-tags b-tags)
        (< (elfeed-entry-date b) (elfeed-entry-date a)))
    (string< a-tags b-tags)))

(setf elfeed-search-sort-function #'my-elfeed-tag-sort)

(setq elfeed-sort-order 'ascending)

;; view/tag specific feeds

(defun pkn-elfeed-default ()
  "Show the default filter for elfeed."
  (interactive)
  (elfeed-search-set-filter "+unread @6-months-ago"))

(defun pkn-elfeed-dnd ()
  "Show unread D&D entries in elfeed."
  (interactive)
  (elfeed-search-set-filter "+dnd +unread @6-months-ago"))

(defun pkn-elfeed-emacs ()
  "Show unread emacs entries in elfeed."
  (interactive)
  (elfeed-search-set-filter "+emacs +unread @6-months-ago"))

(defun pkn-elfeed-gtd ()
  "Show unread emacs entries in elfeed."
  (interactive)
  (elfeed-search-set-filter "+gtd +unread @6-months-ago"))

(defun pkn-elfeed-rpg ()
  "Show unread rpg entries in elfeed."
  (interactive)
  (elfeed-search-set-filter "+rpg +unread @6-months-ago"))

(defun pkn-elfeed-fun ()
  "Show unread fun entries in elfeed."
  (interactive)
  (elfeed-search-set-filter "+fun +unread @6-months-ago"))

(defun pkn-elfeed-tech ()
  "Show unread tech entries in elfeed."
  (interactive)
  (elfeed-search-set-filter "+tech +unread @6-months-ago"))

(defun pkn-elfeed-star ()
  "Show starred in elfeed."
  (interactive)
  (elfeed-search-set-filter "+star"))

(after! elfeed
  (setq elfeed-search-filter "@1-month-ago +unread"))

; setup keys for my preference
(eval-after-load 'elfeed-search
  (progn
    ;; in the "*elfeed-search*" buffer
    (define-key elfeed-search-mode-map (kbd "j a") 'pkn-elfeed-default)
    (define-key elfeed-search-mode-map (kbd "j d") 'pkn-elfeed-dnd)
    (define-key elfeed-search-mode-map (kbd "j e") 'pkn-elfeed-emacs)
    (define-key elfeed-search-mode-map (kbd "j r") 'pkn-elfeed-rpg)
    (define-key elfeed-search-mode-map (kbd "j f") 'pkn-elfeed-fun)
    (define-key elfeed-search-mode-map (kbd "j s") 'pkn-elfeed-star)
    (define-key elfeed-search-mode-map (kbd "j c") 'pkn-elfeed-tech)
    (define-key elfeed-search-mode-map (kbd "j t") 'pkn-elfeed-gtd)
    )
  )

;; Mastodon is not the new twitter. Or is it?
(use-package! mastodon
  :config
  (mastodon-discover))

(setq mastodon-instance-url "https://mstdn.social"
      mastodon-active-user "flaggerkatt")

(require 'mastodon-alt-tl)
(mastodon-alt-tl-activate)

;; Mastodon hyra to help navigate; called by "?"
(defhydra mastodon-help (:color blue :hint nil)
  "
Timelines^^   Toots^^^^           Own Toots^^   Profiles^^      Users/Follows^^  Misc^^
^^-----------------^^^^--------------------^^----------^^-------------------^^------^^-----
_H_ome        _n_ext _p_rev       _r_eply       _A_uthors       follo_W_         _X_ lists
_L_ocal       _T_hread of toot^^  wri_t_e       user _P_rofile  _N_otifications  f_I_lter
_F_ederated   (un) _b_oost^^      _e_dit        ^^              _R_equests       _C_opy URL
fa_V_orites   (un) _f_avorite^^   _d_elete      _O_wn           su_G_estions     _S_earch
_#_ tagged    (un) p_i_n^^        ^^            _U_pdate own    _M_ute user      _h_elp
_@_ mentions  (un) boo_k_mark^^   show _E_dits  ^^              _B_lock user
boo_K_marks   _v_ote^^
trendin_g_
_u_pdate
"
  ("H" mastodon-tl--get-home-timeline)
  ("L" mastodon-tl--get-local-timeline)
  ("F" mastodon-tl--get-federated-timeline)
  ("V" mastodon-profile--view-favourites)
  ("#" mastodon-tl--get-tag-timeline)
  ("@" mastodon-notifications--get-mentions)
  ("K" mastodon-profile--view-bookmarks)
  ("g" mastodon-search--trending-tags)
  ("u" mastodon-tl--update :exit nil)

  ("n" mastodon-tl--goto-next-toot)
  ("p" mastodon-tl--goto-prev-toot)
  ("T" mastodon-tl--thread)
  ("b" mastodon-toot--toggle-boost :exit nil)
  ("f" mastodon-toot--toggle-favourite :exit nil)
  ("i" mastodon-toot--pin-toot-toggle :exit nil)
  ("k" mastodon-toot--bookmark-toot-toggle :exit nil)
  ("c" mastodon-tl--toggle-spoiler-text-in-toot)
  ("v" mastodon-tl--poll-vote)

  ("A" mastodon-profile--get-toot-author)
  ("P" mastodon-profile--show-user)
  ("O" mastodon-profile--my-profile)
  ("U" mastodon-profile--update-user-profile-note)

  ("W" mastodon-tl--follow-user)
  ("N" mastodon-notifications-get)
  ("R" mastodon-profile--view-follow-requests)
  ("G" mastodon-tl--get-follow-suggestions)
  ("M" mastodon-tl--mute-user)
  ("B" mastodon-tl--block-user)

  ("r" mastodon-toot--reply)
  ("t" mastodon-toot)
  ("e" mastodon-toot--edit-toot-at-point)
  ("d" mastodon-toot--delete-toot)
  ("E" mastodon-toot--view-toot-edits)

  ("I" mastodon-tl--view-filters)
  ("X" mastodon-tl--view-lists)
  ("C" mastodon-toot--copy-toot-url)
  ("S" mastodon-search--search-query)
  ("h" describe-mode)

  ("q" doom/escape)
  )

(map! :map mastodon-mode-map
      "?" #'mastodon-help/body)

;; Mail (mu4e)

(after! mu4e

  ;; Basic options
  (setq mu4e-mu-binary "/usr/local/bin/mu"
        mu4e-root-maildir "~/.maildir"
        mu4e-attachment-dir "~/Downloads"
        mu4e-get-mail-command "/usr/local/bin/mbsync -a"

        mu4e-update-interval 300            ; Update interval (seconds)
        mu4e-index-cleanup t                ; Cleanup after indexing
        mu4e-index-update-error-warning t   ; Warnings during update
        mu4e-hide-index-messages t          ; Hide indexing messages
        mu4e-index-update-in-background t   ; Background update
        mu4e-change-filenames-when-moving t ; Needed for mbsync
        mu4e-index-lazy-check nil           ; Don't be lazy, index everything

        mu4e-confirm-quit nil
                                        ; mu4e-split-view 'single-window

        mu4e-headers-auto-update nil
        mu4e-headers-date-format "%d-%m"
        mu4e-headers-time-format "%H:%M"
        mu4e-headers-from-or-to-prefix '("" . "To ")
        mu4e-headers-include-related t
        mu4e-headers-skip-duplicates t)

  ;; MIME handling
  (require 'mailcap)

  (push '((viewer . "open %s 2> /dev/null &")
          (type . "application/pdf")
          (test . window-system))
        mailcap-user-mime-data)

  (when (fboundp 'imagemagick-register-types)
    (imagemagick-register-types))

  ;; Some bindings to avoid confirmation for execution (headers and message view)
  (bind-key "X" (lambda() (interactive) (mu4e-mark-execute-all t)) mu4e-headers-mode-map)
  (bind-key "X" (lambda() (interactive) (mu4e-mark-execute-all t)) mu4e-view-mode-map)

  ;; General information about me.
  (setq user-full-name "Per-Karsten Nordhaug"
        user-mail-address "flaggerkatt@gmail.com")

  ;; Common signature for all accounts.
  (setq mu4e-signature (concat
                        "It is the peculiarity of privilege and of every privileged position to kill the intellect and heart of man.\n"
                        "The privileged man, whether he be privileged politically or economically, is a man depraved in intellect and heart (M. Bakunin)" ))

  ;; Because we’ll use mu4e-contexts, we reset single account settings.

  (setq mu4e-contexts nil
        mu4e-drafts-folder nil
        mu4e-compose-reply-to-address nil
        mu4e-compose-signature t
        mu4e-compose-signature-auto-include t
        mu4e-sent-folder nil
        mu4e-trash-folder nil
        doom-modeline-mu4e nil)

  (setq mu4e-context-policy 'ask  ; How to determine context when entering headers view
        mu4e-compose-context-policy nil) ; Do not modify context when composing

  ;; Contextual tefile
  ;;
  (defun my/mu4e-refile-folder (msg)
    "Contextual refile"

    (let ((maildir (mu4e-message-field msg :maildir)))
      (cond
       ((string-match "bifrost" maildir) "/bifrost/Archive")
       ((string-match "gmail" maildir) "/gmail/[Gmail]/All Mail")
       (t ""))))

  (setq mu4e-refile-folder 'my/mu4e-refile-folder)

  ;; Start contexts
  ;; GMail
  ;; To store the password in OSX keychain:
  ;; =security add-internet-password -l ‘smtp.gmail.com -s ‘smtp.gmail.com’ -a ‘username@gmail.com’ -P 587 -r smtp -T Emacs -U -w “password12345”=
  (add-to-list 'mu4e-contexts
               (make-mu4e-context
                :name "gmail"
                :enter-func (lambda () (mu4e-message "Entering gmail context"))
                :leave-func (lambda () (mu4e-message "Leaving gmail context"))
                :match-func (lambda (msg)
                              (when msg (mu4e-message-contact-field-matches msg
                                                                            :to "flaggerkatt@gmail.com")))
                :vars `((user-mail-address . "flaggerkatt@gmail.com"  )
                        (user-full-name . "Per-Karsten Nordhaug" )
                        ;; don't save messages to Sent Messages,
                        ;; Gmail/IMAP takes care of this
                        ;; (mu4e-sent-messages-behavior 'delete)
                        (mu4e-compose-signature . ,mu4e-signature)
                        (mu4e-sent-folder . "/gmail/[Gmail]/Sent Mail/")
                        (mu4e-trash-folder . "/gmail/[Gmail]/Trash")
                        (mu4e-drafts-folder . "/gmail/[Gmail]/Drafts")
                        (mu4e-maildir-shortcuts . (("/gmail/INBOX" . ?i)
                                                   ("/gmail/[Gmail]/All Mail". ?a)
                                                   ("/gmail/[Gmail]/Sent" . ?s)))
                        (smtpmail-smtp-server . "smtp.gmail.com")
                        (smtpmail-stream-type . starttls)
                        (smtpmail-smtp-service . 587))))

  (add-to-list 'mu4e-contexts
               (make-mu4e-context
                :name "bifrost"
                :enter-func (lambda () (mu4e-message "Entering bifrost context"))
                :leave-func (lambda () (mu4e-message "Leaving bifrost context"))
                :match-func (lambda (msg)
                              (when msg (mu4e-message-contact-field-matches msg
                                                                            :to "borgarting@bifrost.no")))
                :vars `((user-mail-address . "borgarting@bifrost.no"  )
                        (user-full-name . "Lovsigar i Borgarting" )
                        (mu4e-compose-signature . ,mu4e-signature)
                        (mu4e-sent-folder . "/bifrost/Sent Messages")
                        (mu4e-trash-folder . "/bifrost/Deleted Messages")
                        (mu4e-drafts-folder . "/bifrost/Drafts")
                        (mu4e-maildir-shortcuts . (("/bifrost/INBOX" . ?i)
                                                   ("/bifrost/Archive" . ?a)
                                                   ("/bifrost/Sent Messages" . ?s)))
                        (smtpmail-smtp-server . "mail.anduin.net")
                        (smtpmail-stream-type . starttls)
                        (smtpmail-smtp-service . 587))))

  ;; Read Email
  ;; Various settings

  (setq mu4e-show-images t
        mu4e-use-fancy-chars nil
        mu4e-view-html-plaintext-ratio-heuristic  most-positive-fixnum
        mu4e-html2text-command 'mu4e-shr2text
        shr-use-fonts nil   ; Simple HTML Renderer / no font
        shr-use-colors nil) ; Simple HTML Renderer / no color

  ;; n/p for nevigating unread mails

  (bind-key "n" #'mu4e-headers-next-unread mu4e-headers-mode-map)
  (bind-key "p" #'mu4e-headers-prev-unread mu4e-headers-mode-map)

  ;; Write email
  ;;

  ;; send function:
  (setq message-send-mail-function 'smtpmail-send-it

        message-cite-reply-position 'above
        message-citation-line-format "%N [%Y-%m-%d at %R] wrote:"
        message-citation-line-function 'message-insert-formatted-citation-line
        message-yank-prefix       "> "
        message-yank-cited-prefix "> "
        message-yank-empty-prefix "> "
        message-indentation-spaces 1
        message-kill-buffer-on-exit t

        mu4e-compose-format-flowed t
        mu4e-compose-complete-only-personal t
        mu4e-compose-complete-only-after "2021-01-01" ; Limite address auto-completion
        mu4e-compose-dont-reply-to-self t)

  (defun my/mu4e-compose-hook ()
    "Settings for message composition."

    (auto-save-mode -1)
    (turn-off-auto-fill)
    (set-fill-column 79))

  (add-hook 'mu4e-compose-mode-hook #'my/mu4e-compose-hook)


  ;; Bookmarks
  ;;
  (setq mu4e-bookmarks
        '((:name "Inbox"
           :key ?i
           :show-unread t
           :query "m:/gmail/INBOX or m:/bifrost/INBOX")

          (:name "Unread"
           :key ?u
           :show-unread t
           :query "flag:unread AND NOT flag:trashed")

          (:name "Today"
           :key ?t
           :show-unread t
           :query "date:today..now")

          (:name "Yesterday"
           :key ?y
           :show-unread t
           :query "date:2d..today and not date:today..now")

          (:name "Last week"
           :key ?w
           :hide-unread t
           :query "date:7d..now")

          (:name "Flagged"
           :key ?f
           :show-unread t
           :query "flag:flagged")

          (:name "Sent"
           :key ?s
           :hide-unread t
           :query "from:Per-Karsten Nordhaug")

          (:name "Drafts"
           :key ?d
           :hide-unread t
           :query "flag:draft")))

  )  ;; Mu4e Configuration after! ends here

;; Consult, Vertico, Corfu, Cape, Orderless, Embark
;; Completion and such!
;; Fun fun fun!

;; Consult
;;
(use-package! consult
  :init
  :config
  :bind (("C-c h" . consult-history)
         ("C-c m" . consult-mode-command)
         ("C-x b" . consult-buffer)                     ;; orig. switch-to-buffer
         ("C-s" . consult-line)                         ;; orig. switch-to-buffer
         ("C-." . embark-act)                           ;; embark-actions on current item/region/whatever
         ("C-z s" . consult-ripgrep)                    ;; rigrepping, across the multiverse
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         )
  )



;; Vertico
;;
(use-package! vertico
  :init
  (vertico-mode)

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

;; Settings for org-mode and related shit

;; set maximum indentation for description lists
(setq org-list-description-max-indent 5)

;; prevent demoting heading also shifting text inside sections
(setq org-adapt-indentation nil)

(use-package! org-sidebar)

;; fix auth stuff
(after! auth-source (setq auth-sources (nreverse auth-sources)))

;; Org-roam
;;
;; (setq org-roam-directory (file-truename "~/.org/roam"))
;; (org-roam-db-autosync-mode)



;; Misc functions and settings
;;
(setq kill-whole-line t)

;; YASnippets
;; Develop in ~/doom.d/snippets

(setq yas-snippet-dirs '("~/.doom.d/snippets"))


;;
;; EXPERIMENTAL SH*T
;;

(use-package! org-web-tools
  :config (setq org-web-tools-pandoc-sleep-time 1.0))

;; Use minions to hide minor modes
(use-package! minions
  :config
  (setq minions-mode-line-lighter ""
        minions-mode-line-delimiters '("" . ""))
  (minions-mode 1))

(use-package! ts)

;; Live markdown preview with grip-mode
(use-package! grip-mode)


;; Show battery in modeline
(unless (equal "Battery status not available"
               (battery))
  (display-battery-mode 1))

(use-package! autothemer)

(use-package! elcord
  :commands elcord-mode
  :config
  (setq elcord-use-major-mode-as-main-icon t))

(use-package! org-present
  )

;; IRC
(after! circe
  (set-irc-server! "im.codemonkey.be"
    `(:port 6667
      :nick "flaggerkatt"
                                        ;      :sasl-username "myusername"
                                        ;      :sasl-password "mypassword"
      :channels ("&bitlbee"))))

;; Spotify?
;;
(use-package! spotify
  )

;; Set default directory
(setq default-directory "~/")
