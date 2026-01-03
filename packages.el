;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; To install a package with Doom you must declare them here and run 'doom sync'
;; on the command line, then restart Emacs for the changes to take effect -- or
;; use 'M-x doom/reload'.


;; To install SOME-PACKAGE from MELPA, ELPA or emacsmirror:
                                        ;(package! some-package)

;; To install a package directly from a remote git repo, you must specify a
;; `:recipe'. You'll find documentation on what `:recipe' accepts here:
;; https://github.com/radian-software/straight.el#the-recipe-format
                                        ;(package! another-package
                                        ;  :recipe (:host github :repo "username/repo"))

;; If the package you are trying to install does not contain a PACKAGENAME.el
;; file, or is located in a subdirectory of the repo, you'll need to specify
;; `:files' in the `:recipe':
                                        ;(package! this-package
                                        ;  :recipe (:host github :repo "username/repo"
                                        ;           :files ("some-file.el" "src/lisp/*.el")))

;; If you'd like to disable a package included with Doom, you can do so here
;; with the `:disable' property:
                                        ;(package! builtin-package :disable t)

;; You can override the recipe of a built in package without having to specify
;; all the properties for `:recipe'. These will inherit the rest of its recipe
;; from Doom or MELPA/ELPA/Emacsmirror:
                                        ;(package! builtin-package :recipe (:nonrecursive t))
                                        ;(package! builtin-package-2 :recipe (:repo "myfork/package"))

;; Specify a `:branch' to install a package from a particular branch or tag.
;; This is required for some packages whose default branch isn't 'master' (which
;; our package manager can't deal with; see radian-software/straight.el#279)
                                        ;(package! builtin-package :recipe (:branch "develop"))

;; Use `:pin' to specify a particular commit to install.
                                        ;(package! builtin-package :pin "1a2b3c4d5e")


;; Doom's packages are pinned to a specific commit and updated from release to
;; release. The `unpin!' macro allows you to unpin single packages...
                                        ;(unpin! pinned-package)
;; ...or multiple packages
                                        ;(unpin! pinned-package another-pinned-package)
;; ...Or *all* packages (NOT RECOMMENDED; will likely break things)
                                        ;(unpin! t)

;; misc
(package! deadgrep)
(package! grip-mode)

;; password seorage integrations
(package! password-store)
(package! auth-source-pass)

                                        ; Corfu, cape
(package! corfu)
(package! cape)

;; Nyancat
(package! nyan-mode)

;; Minions
(package! minions)

;; Consider some nano-stuff
(package! nano-agenda)
(package! nano-theme)
(package! nano-modeline)

;; Translation and GPT
(package! gptel)
(package! immersive-translate)
(package! chatgpt-shell)

;; Elfeed-webkit
(package! elfeed-webkit)

;; Test out befram
(package! beframe)

;; svg-lib is an Emacs library that allows to create and display various SVG objects, namely tags, icons, buttons, progress bars,
;; progress pies and dates. Each object is guaranteed to fit nicely in a text buffer ensuring width is a multiple of character
;; width and height a multiple of character height.
(package! svg-lib)

;; Calibredb - read calibre library from within emacs
(package! calibredb)

;; Hercules, An auto-magical, which-key based hydra banisher.
(package! hercules)

;; Denote
(package! denote)

;; Logos
(package! logos)


;; Catpuccin?
(package! catppuccin-theme)

;; ef-themes
(package! ef-themes)

;; elfeed-curate
(package! elfeed-curate)


;; trying zetteldeft again...
(package! zetteldeft)


;; consult-mu
(package! consult-mu
  :recipe (:host github :repo "armindarvish/consult-mu" :branch "main" :files (:defaults "extras/*.el")))

(straight-use-package
 '(consult-mu :type git :host github :repo "armindarvish/consult-mu" :branch "main" :files (:defaults "extras/*.el")))
