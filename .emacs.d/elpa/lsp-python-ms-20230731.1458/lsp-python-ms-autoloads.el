;;; lsp-python-ms-autoloads.el --- automatically extracted autoloads  -*- lexical-binding: t -*-
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "lsp-python-ms" "lsp-python-ms.el" (0 0 0 0))
;;; Generated autoloads from lsp-python-ms.el

(autoload 'lsp-python-ms-update-server "lsp-python-ms" "\
Update Microsoft Python Language Server.

On Windows, if the server is running, the updating will fail.
After stopping or killing the process, retry to update." t nil)

(register-definition-prefixes "lsp-python-ms" '("lsp-python-ms-"))

;;;***

;;;### (autoloads nil nil ("lsp-python-ms-pkg.el") (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; lsp-python-ms-autoloads.el ends here
