;;; init.el --- Ian's Emacs config -*- lexical-binding: t -*-
;;; Commentary:
;; Tracked at emacs/init.el in the dotfiles repo; ./init symlinks it into a
;; real, local ~/.emacs.d.  Every package is declared below with use-package
;; and installed from the network on first start (or by `emacs-bootstrap').
;; Nothing under ~/.emacs.d other than the symlinks is ever tracked.
;;; Code:

;; Customize writes here, NOT into this file.  package.el records every
;; install in `package-selected-packages' through Customize, so without this
;; each package-install would rewrite tracked config.
(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file 'noerror 'nomessage)

(require 'use-package)
;; Install anything missing; load lazily via each package's own autoloads,
;; which is how the old package-initialize setup behaved.
(setq use-package-always-ensure t
      use-package-always-defer t)

;; Disable vc.
(setq vc-handled-backends nil)

(menu-bar-mode -1)

(setq max-lisp-eval-depth 40960)

(setq nxml-child-indent 4 nxml-attribute-indent 4)

(let ((frame-background-mode 'dark)) (frame-set-background-mode nil))

(setq inhibit-startup-screen t)
(setq-default show-trailing-whitespace t)

(add-to-list 'load-path (locate-user-emacs-file "lisp"))

;; default to better frame titles
(setq frame-title-format
      (concat  "%b - emacs@" (system-name)))

;; default to unified diffs
(setq diff-switches "-u")

(require 'help-at-pt)
(customize-set-variable 'help-at-pt-timer-delay 1.5)
(customize-set-variable 'help-at-pt-display-when-idle '(flymake-overlay))

(custom-set-faces
 '(hl-line ((t (:background "#202020")))))

;;; Tabs

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

;; STAHP
(global-set-key "\C-xp" 'toggle-tabs)
(tabsoff)

;;; Global keys

(global-set-key (kbd "C-x w q") (lambda () (interactive) (save-buffers-kill-emacs t)))

(global-set-key (kbd "C-x a")
                (lambda () (interactive)
                  (indent-region 0 (1-(point-max)))
                  (delete-trailing-whitespace)))

(global-set-key "\C-x\\" 'delete-trailing-whitespace)

(global-set-key (kbd "M-[ h") 'beginning-of-line)
(global-set-key (kbd "M-[ f") 'end-of-line)

;; This is your old M-x.
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;;; Built-in modes and UI

(setq column-number-mode t)
(global-display-line-numbers-mode 1)
(ido-mode 1)
(global-hl-line-mode)
(show-paren-mode 1)

(set-face-foreground 'minibuffer-prompt "light sky blue")
(load-theme 'wombat t)

(setq-default tab-width 2)
(setq-default json-indent-level 2)
(setq-default js-indent-level 2)

(add-to-list 'auto-mode-alist '("\\.cconf$" . python-mode))
(add-to-list 'auto-mode-alist '("\\.cinc$"  . python-mode))
(add-to-list 'auto-mode-alist '("\\.tw$"    . python-mode))

(add-to-list 'auto-mode-alist '("\\.\\(php\\|inc\\)$" . hack-mode))

(defun my-hack-mode-hook()
  "Setup my hack mode stuff"
  (company-mode)
  (local-set-key (kbd "C-x a") 'hack-format-buffer))
(add-hook 'hack-mode-hook 'my-hack-mode-hook)

(defun my-cpp-mode-hook()
  "Setup my cpp mode stuff"
  ;; (setq flycheck-gcc-language-standard "c++20")
  (flycheck-mode 0)
  (setq clang-format-style-option "llvm")
  (local-set-key (kbd "C-x a") 'clang-format-buffer))
(add-hook 'c++-mode-hook 'my-cpp-mode-hook)

(defun my-sh-mode-hook ()
  "My preferences for sh-mode"
  (setq sh-basic-offset 2)
  (setq sh-indent-after-continuation 'always)
  (setq sh-indent-for-case-alt '+)
  (setq sh-indent-for-case-label 0))
(add-hook 'sh-mode-hook 'my-sh-mode-hook)

;; Disable backup files (ie .#foo and foo~ files)
(setq make-backup-files nil)
(setq auto-save-default nil)

(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

;;; Packages
;; One block per package.  `use-package-always-ensure' installs it; the
;; keywords say how it gets loaded.  Built-ins are not declared.

;; --- completion / navigation ---

(use-package smex
  :bind (("M-x" . smex)
         ("M-X" . smex-major-mode-commands)))

(use-package helm
  :bind ("C-x C-d" . helm-browse-project))
(use-package helm-ls-git)
(use-package helm-go-package)

(defun myfzf (&optional _with-preview)
  "Customized FZF launch"
  ;; fzf--start is internal (not autoloaded), so load fzf explicitly.
  (require 'fzf)
  (let ((d "~/j/cloudbridge"))
    (fzf--start d
                (lambda (x)
                  (let ((f (expand-file-name x d)))
                    (when (file-exists-p f)
                      (find-file f)))))))

(use-package fzf)
(global-set-key (kbd "M-p") (lambda () (interactive) (myfzf)))

(use-package company
  :custom (company-idle-delay 0))
(use-package company-ctags)
(use-package company-shell)

(use-package yasnippet)
(use-package neotree)
(use-package multiple-cursors)
(use-package move-text)
(use-package phi-rectangle)
(use-package yafolding)

;; --- git ---

(use-package magit)
(use-package magit-filenotify)
(use-package magit-find-file)
(use-package git-modes)

;; --- checking / lsp ---

(use-package flycheck
  :hook ((after-init . global-flycheck-mode)
         (python-mode . flycheck-mode))
  :config
  (add-to-list 'flycheck-disabled-checkers 'python-flake8)
  (add-to-list 'flycheck-disabled-checkers 'python-pylint)
  (require 'flycheck-pyflakes)
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
                        '(json-jsonlist))))
(use-package flycheck-pyflakes)
(use-package flycheck-color-mode-line)
(use-package flycheck-jest)
(use-package flycheck-kotlin)
(use-package flycheck-rust)
(use-package flymake-jshint)
(use-package flymake-json)

(use-package lsp-mode
  :custom (lsp-enable-file-watchers nil))
(use-package lsp-ui
  :custom (lsp-ui-imenu-auto-refresh t))

;; --- go ---

(defun my-go-mode-hook ()
  "Setup my go mode stuff"
  (company-mode)
  (lsp-deferred)
  (yas-minor-mode)
  (local-set-key (kbd "C-x a") 'gofmt-before-save))

(use-package go-mode
  :init (setq gofmt-command "goimports")
  :hook (go-mode . my-go-mode-hook))
(use-package go-imenu)

;; --- rust ---

(defun my-rust-mode-hook()
  "Setup my rust mode stuff"
  (local-set-key (kbd "C-x a") 'rust-format-buffer))

(use-package rust-mode
  :hook (rust-mode . my-rust-mode-hook))
(use-package rustic)
(use-package cargo)
(use-package cargo-mode)

;; --- js / ts / web ---

(defun my-jsx-mode-hook()
  "Setup my jsx mode stuff"
  ;; (prettier-mode)
  (company-mode)
  (local-set-key (kbd "C-x a")
                 (lambda () (interactive)
                   (indent-region 0 (1-(point-max)))
                   (eslint-fix)
                   (delete-trailing-whitespace))))

(use-package rjsx-mode
  :mode ("\\.js$" "\\.jsx$")
  :hook (rjsx-mode . my-jsx-mode-hook))

(defun my-typescript-mode-hook()
  "Setup my typescript mode stuff"
  ;; (prettier-mode)
  ;; (tide-mode)
  (local-set-key (kbd "C-x a")
                 (lambda () (interactive)
                   (indent-region 0 (1-(point-max)))
                   (eslint-fix)
                   (delete-trailing-whitespace))))

(use-package typescript-mode
  :mode "\\.tsx$"
  :init (setq typescript-indent-level 2
              typescript-auto-indent-flag t)
  :hook (typescript-mode . my-typescript-mode-hook))

(use-package js2-mode
  :init (setq js2-basic-offset 2
              js2-bounce-indent-p t))
(use-package js2-highlight-vars)
(use-package xref-js2)
(use-package json-mode)
(use-package tide)
(use-package prettier)
(use-package eslint-fix)
(use-package coffee-mode)

;; adjust indents for web-mode to 2 spaces
(defun my-web-mode-hook ()
  "Hooks for Web mode. Adjust indents"
  ;;; http://web-mode.org/
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2))

;; for better jsx syntax-highlighting in web-mode
;; - courtesy of Patrick @halbtuerke
;; NOTE: current web-mode no longer defines `web-mode-highlight-part', so this
;; advice never fires.  Kept (it is harmless) until someone decides.
(defun my-web-mode-jsx-highlight (orig &rest args)
  (if (equal web-mode-content-type "jsx")
      (let ((web-mode-enable-part-face nil))
        (apply orig args))
    (apply orig args)))

(use-package web-mode
  :hook (web-mode . my-web-mode-hook)
  :config
  (advice-add 'web-mode-highlight-part :around #'my-web-mode-jsx-highlight))

(use-package sass-mode
  :mode "\\.scss\\'")

;; --- other languages ---

(defun my-kotlin-mode-hook()
  "Setup my kotlin mode stuff"
  (setq-default indent-tabs-mode nil)
  (setq-default kotlin-tab-width 2))

(use-package kotlin-mode
  :hook (kotlin-mode . my-kotlin-mode-hook))

;; use bazel-mode for TARGETS
(use-package bazel
  :mode ((".bzl$"     . bazel-starlark-mode)
         ("BUCK$"     . bazel-starlark-mode)
         ("PACKAGE$"  . bazel-starlark-mode)
         ("TARGETS$"  . bazel-starlark-mode)))

;; use groovy-mode for Jenkins stuff
(use-package groovy-mode
  :mode (("Jenkinsfile"        . groovy-mode)
         ("\\.jenkinsfile\\'"  . groovy-mode)))

(use-package clang-format)
(use-package cmake-mode)
(use-package csv-mode)
(use-package dockerfile-mode)
(use-package just-mode)
(use-package lua-mode)
(use-package markdown-mode)
(use-package nginx-mode)
(use-package php-mode)
(use-package powershell)
(use-package protobuf-mode)
(use-package puppet-mode)
(use-package systemd)
(use-package toml-mode)
(use-package yaml-mode)

;; Kill auto tabs
(tabsoff)
(setq-default indent-tabs-mode nil)

;;; init.el ends here
