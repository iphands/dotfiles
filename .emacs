;;; package --- Summary
;;; Commentary:

;;; Code:
;; BACKUP FILES
(setq make-backup-files nil)
(setq auto-save-default nil)

;; (setq backup-directory-alist `(("." . "~/.saves")))
;; (setq backup-by-copying t)
;; (setq delete-old-versions t
;; 	  kept-new-versions 8
;; 	  kept-old-versions 4
;; 	  version-control t)

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
 '(custom-safe-themes
   (quote
    ("e24180589c0267df991cf54bf1a795c07d00b24169206106624bb844292807b9" "c4e6fe8f5728a5d5fd0e92538f68c3b4e8b218bcfb5e07d8afff8731cc5f3df0" "42ac06835f95bc0a734c21c61aeca4286ddd881793364b4e9bc2e7bb8b6cf848" default)))
 '(help-at-pt-display-when-idle (quote (flymake-overlay)) nil (help-at-pt))
 '(help-at-pt-timer-delay 1.5)
 '(inhibit-startup-screen t)
 '(js2-basic-offset 4)
 '(js2-bounce-indent-p t)
 '(package-selected-packages
   (quote
    (rjsx-mode tide groovy-mode flymake-json flymake-jshint exec-path-from-shell web-mode json-mode ac-js2 discover-js2-refactor js2-highlight-vars js2-mode js2-refactor xref-js2 toml toml-mode cargo flycheck-rust racer rust-mode ac-php-core magit magit-filenotify magit-find-file egg yaml-mode windresize win-switch whole-line-or-region ujelly-theme twilight-theme textmate-to-yas tabbar sws-mode smooth-scrolling smooth-scroll simple-httpd shell-pop sass-mode ruby-compilation ruby-block python-environment puppetfile-mode puppet-mode php-extras php+-mode phi-rectangle nginx-mode neotree multiple-cursors move-text minimap markdown-mode+ lua-mode lineno less-css-mode jump json-rpc jade-mode igrep hl-line+ highline flymake-puppet flymake-cursor find-file-in-project epc emacs-eclim drupal-mode dockerfile-mode color-theme-railscasts color-theme-heroku color-theme-gruber-darker color-theme-github col-highlight coffee-mode buffer-stack buffer-move blank-mode birds-of-paradise-plus-theme auto-complete anaconda-mode 2048-game))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(col-highlight ((t (:background "#202020"))))
 '(highline-face ((t (:background "#202020"))))
 '(hl-line ((t (:background "#202020")))))

;; Turn on tabs
;; (setq indent-tabs-mode t)
;; (setq-default indent-tabs-mode t)
(setq-default indent-tabs-mode nil)


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
;; (add-hook 'js3-mode-hook (lambda () (auto-complete-mode) (flymake-jslint-load)))
(add-hook 'python-mode-hook (lambda () (auto-complete-mode)))



;; (custom-set-variables
;; '(eclim-eclipse-dirs '("~/eclipse"))
;; '(eclim-executable "~/eclipse/eclim"))

(require 'cl)

;; regular auto-complete initialization
(require 'auto-complete-config)
(ac-config-default)

;; add the emacs-eclim source
;; (require 'ac-emacs-eclim-source)
;; (ac-emacs-eclim-config)

;; use web-mode for .jsx files
(add-to-list 'auto-mode-alist '("\\.jsx$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

;; http://www.flycheck.org/manual/latest/index.html
(require 'flycheck)

;; turn on flychecking globally
(add-hook 'after-init-hook #'global-flycheck-mode)

;; disable jshint since we prefer eslint checking
(setq-default flycheck-disabled-checkers
  (append flycheck-disabled-checkers
    '(javascript-jshint)))

;; use eslint with web-mode for jsx files
(flycheck-add-mode 'javascript-eslint 'web-mode)

;; customize flycheck temp file prefix
(setq-default flycheck-temp-prefix ".flycheck")

;; disable json-jsonlist checking for json files
(setq-default flycheck-disabled-checkers
  (append flycheck-disabled-checkers
    '(json-jsonlist)))

;; for better jsx syntax-highlighting in web-mode
;; - courtesy of Patrick @halbtuerke
(defadvice web-mode-highlight-part (around tweak-jsx activate)
  (if (equal web-mode-content-type "jsx")
    (let ((web-mode-enable-part-face nil))
      ad-do-it)
    ad-do-it))

;; adjust indents for web-mode to 2 spaces
(defun my-web-mode-hook ()
  "Hooks for Web mode. Adjust indents"
  ;;; http://web-mode.org/
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2))
(add-hook 'web-mode-hook  'my-web-mode-hook)


(add-to-list 'auto-mode-alist '("Jenkinsfile" . groovy-mode))
(add-to-list 'auto-mode-alist '("\\.jenkinsfile\\'" . groovy-mode))

(defun rebuild-emacsd ()
 "Rebuild all things in .emacs.d"
 (interactive)
 (byte-recompile-directory (expand-file-name "~/.emacs.d") 0))

;;; .emacs ends here
