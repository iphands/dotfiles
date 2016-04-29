;;2205;0cB1;2205;0c;; .emacs


;; BACKUP FILES
(setq backup-directory-alist `(("." . "~/.saves")))
(setq backup-by-copying t)
(setq delete-old-versions t
	  kept-new-versions 8
	  kept-old-versions 4
	  version-control t)

;; (byte-recompile-directory (expand-file-name "~/.emacs.d") 0)
(setq-default show-trailing-whitespace t)

(add-to-list 'load-path "~/.emacs.d/lisp")

;;; uncomment this line to disable loading of "default.el" at startup
;; (setq inhibit-default-init t)

;; enable visual feedback on selections
					;(setq transient-mark-mode t)
;; default to better frame titles
(setq frame-title-format
      (concat  "%b - emacs@" (system-name)))

;; default to unified diffs
(setq diff-switches "-u")

;; always end a file with a newline
					;(setq require-final-newline 'query)

;;; uncomment for CJK utf-8 support for non-Asian users
;; (require 'un-define)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("e24180589c0267df991cf54bf1a795c07d00b24169206106624bb844292807b9" "c4e6fe8f5728a5d5fd0e92538f68c3b4e8b218bcfb5e07d8afff8731cc5f3df0" "42ac06835f95bc0a734c21c61aeca4286ddd881793364b4e9bc2e7bb8b6cf848" default)))
 '(help-at-pt-display-when-idle (quote (flymake-overlay)) nil (help-at-pt))
 '(help-at-pt-timer-delay 1.5)
 '(inhibit-startup-screen t)
 '(js2-basic-offset 4)
 '(js2-bounce-indent-p t)
 '(js3-indent-level 4))
(setq js3-consistent-level-indent-inner-bracket t)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(col-highlight ((t (:background "#202020"))))
 '(highline-face ((t (:background "#202020"))))
 '(hl-line ((t (:background "#202020")))))

;; Turn on tabs
(setq indent-tabs-mode t)
(setq-default indent-tabs-mode t)


;; Bind the TAB key
;;(global-set-key (kbd "TAB") 'self-insert-command)

;; Set the tab width
(setq default-tab-width 4)
(setq tab-width 4)
(setq c-basic-indent 4)



;; bind compile
(global-set-key (kbd "<f5>") 'compile)
(global-set-key "\C-x\\" 'delete-trailing-whitespace)


(add-to-list 'auto-mode-alist '("\\.scss\\'" . sass-mode))

;;(load "drupal-mode")
;;(add-to-list 'auto-mode-alist '("\\.\\(module\\|test\\|install\\|theme\\)$" . drupal-mode))
;;(add-to-list 'auto-mode-alist '("\\.\\(php\\|inc\\)$" . php-mode))
;;(add-to-list 'auto-mode-alist '("\\.info" . conf-windows-mode))

;(require 'flymake-jslint)
;(add-hook 'js2-mode-hook
;		    (lambda () (flymake-mode t)))
(setq line-number-mode t)
(setq column-number-mode t)
; (setq column-highlight-mode t)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.org/packages/")))

(setq package-enable-at-startup nil)
(package-initialize)

;; enable minor modes I like
(ido-mode 1)
(global-linum-mode 1)
(global-highline-mode 1)
(auto-complete-mode 1)
(show-paren-mode 1)
(column-highlight-mode 1)
;; (crosshairs-mode 1)

(setq linum-format "%4d \u2502 ")

;; colors
(set-face-foreground 'minibuffer-prompt "light sky blue")
;; (color-theme-initialize)
(load-theme 'wombat t)
;; (setq color-theme-is-global t)


(require 'buffer-move)
(global-set-key (kbd "<C-S-up>")     'buf-move-up)
(global-set-key (kbd "<C-S-down>")   'buf-move-down)
(global-set-key (kbd "<C-S-left>")   'buf-move-left)
(global-set-key (kbd "<C-S-right>")  'buf-move-right)

(global-set-key (kbd "M-[ h") 'beginning-of-line)
(global-set-key (kbd "M-[ f") 'end-of-line)

;; (global-set-key (kbd "<C-S> y") 'enlarge-window)
;;(global-set-key (kbd "<C-S> h") 'shrink-window)

;; (require 'buffer-stack)
;; (global-set-key [(backtab)] 'buffer-stack-up)

;; (add-to-list 'load-path "~/.emacs.d/elpa/yasnippet-20140514.1649")
;; (require 'yasnippet) ;; not yasnippet-bundle
;; (yas-global-mode 1)

;; ~/.emacs.d/elpa/yasnippet-bundle-0.6.1
;; (delq 'ac-source-yasnippet ac-sources)

(setq flymake-gui-warnings-enabled nil)


;; (add-to-list 'load-path "/lib/node_modules/tern/emacs/")
;; (autoload 'tern-mode "tern.el" nil t)
;; (add-hook 'js3-mode-hook (lambda () (auto-complete-mode) (flymake-jslint-load) (tern-mode t)))

(add-hook 'js3-mode-hook (lambda () (auto-complete-mode) (flymake-jslint-load)))


(add-hook 'python-mode-hook (lambda () (auto-complete-mode)))

;;#(custom-set-variables
;; '(eclim-eclipse-dirs '("~/eclipse"))
;; '(eclim-executable "~/eclipse/eclim"))

(require 'cl)

;; regular auto-complete initialization
(require 'auto-complete-config)
(ac-config-default)

;; add the emacs-eclim source
;; (require 'ac-emacs-eclim-source)
;; (ac-emacs-eclim-config)


