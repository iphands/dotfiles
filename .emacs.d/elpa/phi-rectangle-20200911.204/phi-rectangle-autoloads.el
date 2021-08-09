;;; phi-rectangle-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "phi-rectangle" "phi-rectangle.el" (0 0 0 0))
;;; Generated autoloads from phi-rectangle.el

(defvar phi-rectangle-mode nil "\
Non-nil if Phi-Rectangle mode is enabled.
See the `phi-rectangle-mode' command
for a description of this minor mode.")

(custom-autoload 'phi-rectangle-mode "phi-rectangle" nil)

(autoload 'phi-rectangle-mode "phi-rectangle" "\
minor mode to set rectangle-mark

If called interactively, enable Phi-Rectangle mode if ARG is
positive, and disable it if ARG is zero or negative.  If called
from Lisp, also enable the mode if ARG is omitted or nil, and
toggle it if ARG is `toggle'; disable the mode otherwise.

\(fn &optional ARG)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "phi-rectangle" '("kill-new" "phi-rectangle-")))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; phi-rectangle-autoloads.el ends here
