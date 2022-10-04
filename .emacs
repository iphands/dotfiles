;;; package --- Summary
;;; Commentary:

;;; Code:

;; Disable vc.
(setq vc-handled-backends nil)

(menu-bar-mode -1)

(setq max-lisp-eval-depth 1024)
(setq lsp-ui-imenu-auto-refresh t)
(setq lsp-enable-file-watchers nil)

(setq nxml-child-indent 4 nxml-attribute-indent 4)

(add-hook 'c++-mode-hook (lambda () (setq flycheck-gcc-language-standard "c++11")))

;; rebuild all of the things!
(defun rebuild-emacsd ()
 "Rebuild all things in .emacs.d"
 (interactive)
 (byte-recompile-directory (expand-file-name "~/.emacs.d") 0))

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
   '("e24180589c0267df991cf54bf1a795c07d00b24169206106624bb844292807b9" "c4e6fe8f5728a5d5fd0e92538f68c3b4e8b218bcfb5e07d8afff8731cc5f3df0" "42ac06835f95bc0a734c21c61aeca4286ddd881793364b4e9bc2e7bb8b6cf848" default))
 '(help-at-pt-display-when-idle '(flymake-overlay) nil (help-at-pt))
 '(help-at-pt-timer-delay 1.5)
 '(inhibit-startup-screen t)
 '(js-indent-level 2)
 '(js2-basic-offset 4)
 '(js2-bounce-indent-p t)
 '(package-selected-packages
   '(powershell py-yapf edts git-modes csv-mode eslint-fix prettier flow-minor-mode rjsx-mode systemd bazel tide go-imenu lsp-ui yasnippet typescript-mode protobuf-mode lsp-mode rustic racer eldoc go-eldoc helm-ls-git helm helm-git helm-go-package smex company company-box company-c-headers company-cmake company-ctags company-go company-shell yafolding flymake-shellcheck cmake-mode go-mode groovy-mode flymake-json flymake-jshint web-mode json-mode js2-highlight-vars js2-mode xref-js2 toml-mode cargo flycheck-rust rust-mode magit magit-filenotify magit-find-file yaml-mode python-environment puppetfile-mode puppet-mode phi-rectangle nginx-mode neotree multiple-cursors move-text markdown-mode+ lua-mode lineno json-rpc highline epc dockerfile-mode coffee-mode)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(col-highlight ((t (:background "#202020"))))
 '(highline-face ((t (:background "#202020"))))
 '(hl-line ((t (:background "#202020")))))

(defun tabson()
  "turn tab mode on"
  (interactive)
  (progn
    (setq c-basic-indent    8
	  c-basic-offset    8
	  default-tab-width 8
	  sh-basic-offset   8
	  indent-tabs-mode  t)
    (message "tabson %s" indent-tabs-mode)))

(defun tabsoff()
  "turn tab mode off"
  (interactive)
  (progn
    (setq c-basic-indent 2
	  c-basic-offset 2
	  default-tab-width 2
	  indent-tabs-mode  nil)
    (message "tabsoff %s" indent-tabs-mode)))

(defun toggle-tabs ()
  "toggle between tabs and spaces"
  (interactive)
  (if indent-tabs-mode
      (tabsoff)
    (tabson)))

(global-set-key "\C-xp" 'toggle-tabs)
(tabsoff)

(global-set-key (kbd "C-x a")
	       (lambda () (interactive)
		 (indent-region 0 (1-(point-max)))
		 (delete-trailing-whitespace)))

;; bind compile
;; (global-set-key (kbd "<f5>") 'compile)
(global-set-key "\C-x\\" 'delete-trailing-whitespace)


(add-to-list 'auto-mode-alist '("\\.scss\\'" . sass-mode))

;;(load "drupal-mode")
;;(add-to-list 'auto-mode-alist '("\\.\\(module\\|test\\|install\\|theme\\)$" . drupal-mode))
(add-to-list 'auto-mode-alist '("\\.\\(php\\|inc\\)$" . hack-mode))
;;(add-to-list 'auto-mode-alist '("\\.info" . conf-windows-mode))

;(require 'flymake-jslint)
;(add-hook 'js2-mode-hook
;		    (lambda () (flymake-mode t)))
;; (setq line-number-mode t)
(setq column-number-mode t)
;; (setq column-highlight-mode t)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("melpa" . "http://melpa.org/packages/")
		 	 ;; ("marmalade" . "http://marmalade-repo.org/packages/")
			 ))

(setq package-enable-at-startup nil)
(package-initialize)

;; from https://gist.github.com/samertm/8bccfeb30c0902194de5
(setq company-idle-delay 0)
(setq gofmt-command "goimports")
;; (setq gofmt-args '("-local" "git.corp.tanium.com"))

(if (string-match-p (regexp-quote "od.fbinfra") (getenv "HOSTNAME"))
    (setenv "NODE_PATH" "/var/www/scripts/third-party/node_modules"))

;; (add-hook 'before-save-hook 'gofmt-before-save)
;; UPDATE: gofmt-before-save is more convenient then having a command
;; for running gofmt manually. In practice, you want to
;; gofmt/goimports every time you save anyways.
;; (add-hook 'before-save-hook 'gofmt-before-save)
;; (global-set-key (kbd "C-c M-n") 'company-complete)
;; (global-set-key (kbd "C-c C-n") 'company-complete)
(defun my-go-mode-hook ()
  "Setup my go mode stuff"
  ;; (toggle-debug-on-error)
  (company-mode)
  (lsp-deferred)
  (yas-minor-mode)
  (add-to-list 'company-backends 'company-go)
  ;; (set (make-local-variable 'company-backends) '(company-go))
  (go-eldoc-setup)
  (local-set-key (kbd "C-x a") 'gofmt-before-save))

(add-hook 'go-mode-hook 'my-go-mode-hook)

(defun my-hack-mode-hook()
  "Setup my hack mode stuff"
  ;; (toggle-debug-on-error)
  (company-mode)
  (local-set-key (kbd "C-x a") 'hack-format-buffer))
(add-hook 'hack-mode-hook 'my-hack-mode-hook)

(defun my-rust-mode-hook()
  "Setup my rust mode stuff"
  ;; (toggle-debug-on-error)
  (company-mode)
  (racer-mode)
  (rustic-mode)
  (local-set-key (kbd "C-x a") 'rust-format-buffer))
(add-hook 'rust-mode-hook 'my-rust-mode-hook)

(defun my-jsx-mode-hook()
  "Setup my jsx mode stuff"
  ;; (toggle-debug-on-error)
  (prettier-mode)
  (company-mode)
  (local-set-key (kbd "C-x a")
		 (lambda () (interactive)
		   (indent-region 0 (1-(point-max)))
		   (eslint-fix)
		   (delete-trailing-whitespace))))
(add-hook 'rjsx-mode-hook 'my-jsx-mode-hook)

(defun my-typescript-mode-hook()
  "Setup my typescript mode stuff"
  ;; (toggle-debug-on-error)
  (prettier-mode)
  ;; (tide-mode)
  (local-set-key (kbd "C-x a")
		 (lambda () (interactive)
		   (indent-region 0 (1-(point-max)))
		   (eslint-fix)
		   (delete-trailing-whitespace))))
(add-hook 'typescript-mode-hook 'my-typescript-mode-hook)

(if (version<= "26.0.50" emacs-version)
    (global-display-line-numbers-mode 1)
  (global-linum-mode 1))

;; enable minor modes I like
(ido-mode 1)
;; (global-linum-mode 1)
(global-highline-mode 1)
;; (auto-complete-mode 1)
(show-paren-mode 1)
;; (column-highlight-mode 1)
;; (crosshairs-mode 1)

(setq linum-format "%4d \u2502 ")

;; color
(set-face-foreground 'minibuffer-prompt "light sky blue")
;; (color-theme-initialize)
(load-theme 'wombat t)
;; (setq color-theme-is-global t)


;; (require 'buffer-move)
;; (global-set-key (kbd "<C-S-up>")     'buf-move-up)
;; (global-set-key (kbd "<C-S-down>")   'buf-move-down)
;; (global-set-key (kbd "<C-S-left>")   'buf-move-left)
;; (global-set-key (kbd "<C-S-right>")  'buf-move-right)

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
;; (add-hook 'python-mode-hook (lambda () (auto-complete-mode)))



;; (custom-set-variables
;; '(eclim-eclipse-dirs '("~/eclipse"))
;; '(eclim-executable "~/eclipse/eclim"))

;; (require 'cl)

;; regular auto-complete initialization
;; (require 'auto-complete-config)
;; (ac-config-default)

;; add the emacs-eclim source
;; (require 'ac-emacs-eclim-source)
;; (ac-emacs-eclim-config)

;; use web-mode for .jsx files
(add-to-list 'auto-mode-alist '("\\.jsx$" . rjsx-mode))
(add-to-list 'auto-mode-alist '("\\.tsx$" . typescript-mode))
(add-to-list 'auto-mode-alist '("\\.js$" .  rjsx-mode))

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

(defun my-setup-sh-mode ()
  "My preferences for sh-mode"
  (setq sh-basic-offset 2)
  (setq sh-indent-after-continuation 'always)
  (setq sh-indent-for-case-alt '+)
  (setq sh-indent-for-case-label 0))

(add-hook 'sh-mode-hook #'my-setup-sh-mode)

;; SMEX smex
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; This is your old M-x.
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;; HELM helm
(global-set-key (kbd "C-x C-d") 'helm-browse-project)

;; highlight-symbol
;; (require 'highlight-symbol)
;; (global-set-key [(control f3)] 'highlight-symbol)
;; (global-set-key [f3] 'highlight-symbol-next)
;; (global-set-key [(shift f3)] 'highlight-symbol-prev)
;; (global-set-key [(meta f3)] 'highlight-symbol-query-replace)

;; BACKUP FILES
(setq make-backup-files nil)
(setq auto-save-default nil)

;;; .emacs ends here
