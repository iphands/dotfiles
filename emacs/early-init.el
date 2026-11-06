;;; early-init.el --- runs before package.el and the first frame -*- lexical-binding: t -*-
;;; Commentary:
;; Tracked in the dotfiles repo at emacs/early-init.el and symlinked into a
;; REAL, local ~/.emacs.d by ./init.  Everything Emacs writes (elpa/,
;; eln-cache/, history, custom.el) stays in that local directory and never
;; reaches git.  New machine: git clone && ./init && emacs-bootstrap
;;; Code:

(when (< emacs-major-version 30)
  (error "This config needs Emacs 30+ (built-in use-package); this is %s"
         emacs-version))

;; Fewer GCs during startup; restored once init is done.
(setq gc-cons-threshold (* 64 1024 1024))
(add-hook 'emacs-startup-hook
          (lambda () (setq gc-cons-threshold (* 16 1024 1024))))

;; https only: MELPA packages are unsigned, so over plain http anyone on the
;; path could substitute a package.
(setq package-archives
      '(("gnu"    . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa"  . "https://melpa.org/packages/")))
;; No package-archive-priorities on purpose: with them, ~35 packages resolve
;; to old tagged releases on nongnu (go-mode 1.6.0, typescript-mode 0.4)
;; instead of MELPA snapshots.  Highest version wins, as it always has.

;; package-enable-at-startup stays at its default (t): startup activates the
;; installed packages right after this file, before init.el runs.

(provide 'early-init)
;;; early-init.el ends here
