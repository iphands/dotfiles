;;; ~/.emacs --- signpost: the real config lives in ~/.emacs.d -*- lexical-binding: t -*-
;;; Commentary:
;;
;; This file is a symlink to emacs/dot-emacs.el in the dotfiles repo
;; (~/prog/dotfiles), put here by ./init.  DON'T PUT CONFIG HERE.
;;
;; Emacs reads ~/.emacs INSTEAD OF ~/.emacs.d/init.el when this file exists,
;; so the one line of code at the bottom hands off to the real config.
;; Without that line, this file would silently disable everything.
;;
;; ---------------------------------------------------------------------------
;; Where things are
;; ---------------------------------------------------------------------------
;;
;;   ~/.emacs.d/early-init.el  -> emacs/early-init.el   runs first: Emacs 30+ guard,
;;                                                      package archives (https)
;;   ~/.emacs.d/init.el        -> emacs/init.el         ALL config: settings, keys,
;;                                                      one use-package block per
;;                                                      package that needs config
;;   ~/.emacs.d/lisp/          -> emacs/lisp/           my-packages.el: the package
;;                                                      list machinery
;;   emacs/packages.el                                  SHARED package list (every
;;                                                      machine installs these)
;;   ~/.emacs.d/packages-local.el
;;                 -> host/<host>/emacs/packages-local.el   this machine's extras
;;
;;   Local only, never in git: ~/.emacs.d/elpa/ (downloaded packages),
;;   ~/.emacs.d/custom.el (M-x customize), eln-cache/, history files.
;;
;; ---------------------------------------------------------------------------
;; How to use it
;; ---------------------------------------------------------------------------
;;
;;   Install a package     M-x list-packages, i x   -> commit emacs/packages.el
;;   Remove a package      M-x list-packages, D x   -> commit the list it left
;;   Upgrade               M-x list-packages, U x   (lists don't change)
;;   This machine only     M-x my/package-make-local   (my/package-make-shared
;;                         to undo) -> commit host/<host>/emacs/packages-local.el
;;   Configure a package   edit or add its use-package block in emacs/init.el
;;   Remove stale config   M-x my/package-trim-config  (startup warns when needed)
;;   Sync a machine        git pull && ./init
;;                         (or: emacs-bootstrap [--dry-run | --upgrade])
;;   New machine           git clone ... && cd dotfiles && ./init
;;   Customize settings    saved to ~/.emacs.d/custom.el, this machine only;
;;                         move one into emacs/init.el to share it
;;
;;   Full docs: emacs/README.md in the dotfiles repo.
;;
;;; Code:

(let ((init (expand-file-name "init.el" user-emacs-directory)))
  (if (file-exists-p init)
      (load init nil 'nomessage 'nosuffix)
    (display-warning
     'dot-emacs
     (format "%s is missing: run ./init in the dotfiles repo (~/prog/dotfiles)" init)
     :error)))

;;; ~/.emacs ends here
