;;; eslint-fix-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "eslint-fix" "eslint-fix.el" (0 0 0 0))
;;; Generated autoloads from eslint-fix.el

(autoload 'eslint-fix "eslint-fix" "\
Format the current file with ESLint." t nil)

(autoload 'eslint-fix-auto-mode "eslint-fix" "\
Run `eslint-fix' after save.

If called interactively, enable Eslint-Fix-Auto mode if ARG is
positive, and disable it if ARG is zero or negative.  If called
from Lisp, also enable the mode if ARG is omitted or nil, and
toggle it if ARG is `toggle'; disable the mode otherwise.

\(fn &optional ARG)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "eslint-fix" '("eslint-fix-")))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; eslint-fix-autoloads.el ends here
