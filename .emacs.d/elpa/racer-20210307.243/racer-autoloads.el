;;; racer-autoloads.el --- automatically extracted autoloads (do not edit)   -*- lexical-binding: t -*-
;; Generated by the `loaddefs-generate' function.

;; This file is part of GNU Emacs.

;;; Code:

(add-to-list 'load-path (or (and load-file-name (directory-file-name (file-name-directory load-file-name))) (car load-path)))



;;; Generated autoloads from racer.el

(autoload 'racer-find-definition "racer" "\
Run the racer find-definition command and process the results." t)
(autoload 'racer-find-definition-other-window "racer" "\
Run the racer find-definition command and process the results." t)
(autoload 'racer-find-definition-other-frame "racer" "\
Run the racer find-definition command and process the results." t)
(autoload 'racer-mode "racer" "\
Minor mode for racer.

This is a minor mode.  If called interactively, toggle the `racer mode'
mode.  If the prefix argument is positive, enable the mode, and if it is
zero or negative, disable the mode.

If called from Lisp, toggle the mode if ARG is `toggle'.  Enable the
mode if ARG is nil, omitted, or is a positive number.  Disable the mode
if ARG is a negative number.

To check whether the minor mode is enabled in the current buffer,
evaluate the variable `racer-mode'.

The mode's hook is called both when the mode is enabled and when it is
disabled.

\\{racer-mode-map}

(fn &optional ARG)" t)
(register-definition-prefixes "racer" '("racer-"))

;;; End of scraped data

(provide 'racer-autoloads)

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; no-native-compile: t
;; coding: utf-8-emacs-unix
;; End:

;;; racer-autoloads.el ends here
