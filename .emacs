;;2205;0cB1;2205;0c;; .emacs

;; (byte-recompile-directory (expand-file-name "~/.emacs.d") 0)
(setq-default show-trailing-whitespace t)

(add-to-list 'load-path "~/.emacs.d/")

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
 '(inhibit-startup-screen t)
 '(js2-basic-offset 4)
 '(js2-bounce-indent-p t)
 '(js3-indent-level 4))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(col-highlight ((t (:background "#000022"))))
 '(highline-face ((t (:background "#111111"))))
 '(hl-line ((t (:background "000022")))))

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


;;(load "drupal-mode")
;;(add-to-list 'auto-mode-alist '("\\.\\(module\\|test\\|install\\|theme\\)$" . drupal-mode))
;;(add-to-list 'auto-mode-alist '("\\.\\(php\\|inc\\)$" . php-mode))
;;(add-to-list 'auto-mode-alist '("\\.info" . conf-windows-mode))

;(require 'flymake-jslint)
;(add-hook 'js2-mode-hook
;		    (lambda () (flymake-mode t)))

(setq line-number-mode t)
(setq column-number-mode t)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))

(setq package-enable-at-startup nil)
(package-initialize)

;; enable minor modes I like
(ido-mode 1)
(global-linum-mode 1)
(global-highline-mode 1)
(global-auto-complete-mode 1)
;; (crosshairs-mode 1)

(setq linum-format "%4d \u2502 ")

;; colors
(set-face-foreground 'minibuffer-prompt "light sky blue")
;; (color-theme-initialize)
;; (setq color-theme-is-global t)


(require 'buffer-move)
(global-set-key (kbd "<C-S-up>")     'buf-move-up)
(global-set-key (kbd "<C-S-down>")   'buf-move-down)
(global-set-key (kbd "<C-S-left>")   'buf-move-left)
(global-set-key (kbd "<C-S-right>")  'buf-move-right)

;; (require 'buffer-stack)
;; (global-set-key [(backtab)] 'buffer-stack-up)

;; (add-to-list 'load-path "~/.emacs.d/elpa/yasnippet-20140514.1649")
;; (require 'yasnippet) ;; not yasnippet-bundle
;; (yas-global-mode 1)

;; ~/.emacs.d/elpa/yasnippet-bundle-0.6.1
;; (delq 'ac-source-yasnippet ac-sources)
