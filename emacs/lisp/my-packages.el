;;; my-packages.el --- package lists written by M-x list-packages -*- lexical-binding: t -*-
;;; Commentary:
;; Which packages get installed is decided by two plain lists, not by init.el:
;;
;;   emacs/packages.el                     shared: every machine installs these
;;   ~/.emacs.d/packages-local.el          this machine only; ./init links it to
;;     -> host/<host>/emacs/packages-local.el   so it is tracked per host
;;
;; package.el keeps `package-selected-packages' (what you installed on purpose,
;; never dependencies) and normally saves it through Customize.  We redirect
;; that save: new installs land in the shared list, packages already in the
;; local list stay there, and deletions disappear from whichever list had them.
;; So `i x' / `D x' in list-packages edit the tracked files directly; commit them,
;; and `./init' (emacs-bootstrap) on another machine installs and removes to match.
;;
;; init.el's use-package blocks only CONFIGURE.  Every block gets an automatic
;; `:if (my/package-available-p NAME)', so a block whose package is gone simply
;; switches off; startup warns, and M-x my/package-trim-config deletes it.
;;; Code:

(require 'package)
(require 'cl-lib)

(defconst my/packages-shared-header
  ";; Shared Emacs packages: every machine installs these.
;; Written by package.el when you install/delete in M-x list-packages - commit it.
;; Machine-only extras: host/<host>/emacs/packages-local.el (M-x my/package-make-local).
;; Sync a machine with: ./init  (or emacs-bootstrap). See emacs/README.md.
")

(defconst my/packages-local-header
  ";; Emacs packages for THIS machine only (not installed on other hosts).
;; Written by package.el and M-x my/package-make-local / my/package-make-shared.
;; Lives in host/<host>/emacs/ via ./init - commit it.  See emacs/README.md.
")

(defvar my/packages-read-ok t
  "Nil when a package list could not be read; then nothing is written or removed.")
(defvar my/packages-shared nil "The shared list, as last read or written.")
(defvar my/packages-local nil "This machine's list, as last read or written.")

(defun my/packages-shared-file ()
  "The repo's emacs/packages.el, found through the init.el symlink."
  (expand-file-name "packages.el"
                    (file-name-directory
                     (file-truename (locate-user-emacs-file "init.el")))))

(defun my/packages-local-file ()
  "Where this machine's list really lives.
Resolves the ~/.emacs.d/packages-local.el symlink even when it dangles, so the
first write creates host/<host>/emacs/packages-local.el in the repo."
  (file-truename (locate-user-emacs-file "packages-local.el")))

(defun my/packages-read (file)
  "Return the package names in FILE, nil if FILE does not exist.
Signals an error for anything that is not one list of symbols, including git
conflict markers (which would otherwise read as innocent symbols)."
  (when (file-exists-p file)
    (with-temp-buffer
      (insert-file-contents file)
      (goto-char (point-min))
      (when (re-search-forward "^\\(<<<<<<<\\|=======\\|>>>>>>>\\)" nil t)
        (error "%s has git conflict markers" file))
      (goto-char (point-min))
      (let ((form (condition-case nil (read (current-buffer))
                    (end-of-file nil))))
        (unless (and (listp form) (cl-every #'symbolp form))
          (error "%s is not a list of package names" file))
        (when (condition-case nil (progn (read (current-buffer)) t)
                (end-of-file nil))
          (error "%s has more than one form" file))
        form))))

(defun my/packages--format (header pkgs)
  (let ((sorted (sort (delete-dups (copy-sequence pkgs)) #'string<)))
    (concat header
            (if sorted
                (concat "(" (mapconcat #'symbol-name sorted "\n ") ")\n")
              "()\n"))))

(defun my/packages--write (file header pkgs &optional create-empty)
  "Write PKGS to FILE in canonical form.  Return non-nil if FILE changed.
An empty list does not create a missing FILE unless CREATE-EMPTY."
  (let ((new (my/packages--format header pkgs))
        (old (and (file-exists-p file)
                  (with-temp-buffer (insert-file-contents file) (buffer-string)))))
    (unless (or (equal new old)
                (and (null pkgs) (null old) (not create-empty)))
      (make-directory (file-name-directory file) t)
      (let ((coding-system-for-write 'utf-8-unix))
        (write-region new nil file nil 'silent))
      t)))

(defun my/packages--check-ok ()
  (unless my/packages-read-ok
    (user-error "Package lists are unreadable (merge conflict?): fix them and restart Emacs first")))

(defun my/packages--store (shared local)
  "Write SHARED and LOCAL to their files and report what changed."
  (let* ((local (sort (delete-dups (copy-sequence local)) #'string<))
         (shared (sort (cl-set-difference (delete-dups (copy-sequence shared)) local)
                       #'string<))
         (changed (delq nil
                        (list (and (my/packages--write (my/packages-shared-file)
                                                       my/packages-shared-header shared t)
                                   (my/packages-shared-file))
                              (and (my/packages--write (my/packages-local-file)
                                                       my/packages-local-header local)
                                   (my/packages-local-file))))))
    (setq my/packages-shared shared
          my/packages-local local
          package-selected-packages (sort (append shared local nil) #'string<))
    (when changed
      (message "Package list changed, commit it: %s"
               (mapconcat #'abbreviate-file-name changed ", ")))
    changed))

(defun my/packages-load ()
  "Read both lists into `package-selected-packages'."
  (setq my/packages-read-ok t)
  (condition-case err
      (setq my/packages-shared (my/packages-read (my/packages-shared-file))
            my/packages-local (my/packages-read (my/packages-local-file)))
    (error
     (setq my/packages-read-ok nil
           my/packages-shared nil
           my/packages-local nil)
     (display-warning
      'my-packages
      (format "%s.  Until it is fixed and Emacs restarted, package lists are NOT \
written and nothing is auto-removed." (error-message-string err))
      :error)))
  (setq package-selected-packages
        (sort (delete-dups (append my/packages-shared my/packages-local nil))
              #'string<)))

(defun my/packages--save (&rest _)
  "Replacement for `package--save-selected-packages-1': save to the list files."
  (if (not my/packages-read-ok)
      (display-warning 'my-packages
                       "Package lists unreadable: this install/delete was NOT recorded."
                       :error)
    (let* ((current package-selected-packages)
           (local (cl-intersection my/packages-local current)))
      (my/packages--store (cl-set-difference current local) local))))

(advice-add 'package--save-selected-packages-1 :override #'my/packages--save)
;; With an empty or unread list, autoremove would offer to delete everything.
(advice-add 'package-autoremove :before
            (lambda (&rest _) (my/packages--check-ok)
              (unless package-selected-packages
                (user-error "No selected packages: refusing to autoremove everything"))))

(defun my/package-make-local (pkg)
  "Move PKG from the shared list to this machine's list."
  (interactive
   (progn (my/packages--check-ok)
          (list (intern (completing-read "Make machine-only: "
                                         (mapcar #'symbol-name my/packages-shared)
                                         nil t)))))
  (my/packages--check-ok)
  (my/packages--store (remq pkg my/packages-shared) (cons pkg my/packages-local)))

(defun my/package-make-shared (pkg)
  "Move PKG from this machine's list to the shared list."
  (interactive
   (progn (my/packages--check-ok)
          (list (intern (completing-read "Share with every machine: "
                                         (mapcar #'symbol-name my/packages-local)
                                         nil t)))))
  (my/packages--check-ok)
  (my/packages--store (cons pkg my/packages-shared) (remq pkg my/packages-local)))

;;; Config blocks whose package is gone

(defvar my/package-orphans nil
  "use-package blocks skipped because their package is in neither list.")
(defvar my/package-unsynced nil
  "use-package blocks skipped because their package is listed but not installed.")

(defun my/package-available-p (name)
  "Non-nil if NAME is installed; otherwise record why its block is skipped."
  (or (package-installed-p name)
      (progn
        (if (memq name package-selected-packages)
            (cl-pushnew name my/package-unsynced)
          (cl-pushnew name my/package-orphans))
        nil)))

(with-eval-after-load 'use-package-core
  ;; Give every block `:if (my/package-available-p 'NAME)' unless it already
  ;; has its own condition, or says it is not a package (`:ensure nil', a
  ;; built-in feature such as sh-script).
  (add-to-list 'use-package-defaults
               (list :if
                     (lambda (name _args) `(my/package-available-p ',name))
                     (lambda (_name args)
                       (not (or (plist-member args :if)
                                (plist-member args :when)
                                (plist-member args :unless)
                                (plist-member args :load-path)
                                (and (plist-member args :ensure)
                                     (null (car-safe (plist-get args :ensure))))))))))

(defun my/package-report ()
  "Warn about skipped use-package blocks."
  (when my/package-unsynced
    (display-warning
     'my-packages
     (format "Listed but not installed (config skipped): %s.  Run emacs-bootstrap (or ./init)."
             (mapconcat #'symbol-name (reverse my/package-unsynced) " "))))
  (when my/package-orphans
    (display-warning
     'my-packages
     (format "Config for packages in neither list (skipped): %s.  \
M-x my/package-trim-config to delete those blocks from init.el."
             (mapconcat #'symbol-name (reverse my/package-orphans) " ")))))

(add-hook 'after-init-hook #'my/package-report)

(defun my/packages--helpers (form)
  "Your own functions (my-* / my/*) that FORM refers to."
  (let (found)
    (cl-labels ((walk (x)
                  (cond ((consp x) (walk (car x)) (walk (cdr x)))
                        ((and (symbolp x) (fboundp x)
                              (string-match-p "\\`my[-/]" (symbol-name x)))
                         (cl-pushnew x found)))))
      (walk form))
    (nreverse found)))

(defun my/package-trim-config ()
  "Offer to delete each init.el use-package block whose package is in neither list."
  (interactive)
  (unless my/package-orphans
    (user-error "No orphaned config blocks"))
  (let ((init (file-truename (locate-user-emacs-file "init.el")))
        deleted helpers)
    (with-current-buffer (find-file-noselect init)
      (unless noninteractive (pop-to-buffer (current-buffer)))
      (save-excursion
        (goto-char (point-min))
        (condition-case nil
            (while t
              (let* ((form (read (current-buffer)))
                     (end (point))
                     (start (save-excursion (backward-sexp) (point))))
                (when (and (eq (car-safe form) 'use-package)
                           (memq (cadr form) my/package-orphans))
                  ;; Comment lines directly above the block belong to it.
                  (save-excursion
                    (goto-char start)
                    (while (and (= (forward-line -1) 0) (looking-at "[ \t]*;"))
                      (setq start (point))))
                  (let ((ov (make-overlay start end)))
                    (overlay-put ov 'face 'highlight)
                    (goto-char start)
                    (unless noninteractive (recenter 3))
                    (if (unwind-protect
                            (y-or-n-p (format "Delete the config block for `%s'? "
                                              (cadr form)))
                          (delete-overlay ov))
                        (progn
                          (delete-region start end)
                          ;; Leave one blank line between the neighbours.
                          (let ((b (progn (skip-chars-backward " \t\n") (point))))
                            (skip-chars-forward " \t\n")
                            (delete-region b (point))
                            (goto-char b)
                            (insert (cond ((= b (point-max)) "\n")
                                          ((= b (point-min)) "")
                                          (t "\n\n"))))
                          (push (cadr form) deleted)
                          (setq helpers (append helpers (my/packages--helpers form))))
                      ;; Kept: continue AFTER it, or the loop re-reads it forever.
                      (goto-char end))))))
          (end-of-file nil)))
      (when deleted (save-buffer)))
    (setq my/package-orphans (cl-set-difference my/package-orphans deleted))
    (message "Deleted %d block(s)%s%s"
             (length deleted)
             (if deleted (format " (%s) - commit init.el"
                                 (mapconcat #'symbol-name (nreverse deleted) " "))
               "")
             (if helpers
                 (format "; left in place, now possibly unused: %s"
                         (mapconcat #'symbol-name (delete-dups helpers) " "))
               ""))))

(provide 'my-packages)
;;; my-packages.el ends here
