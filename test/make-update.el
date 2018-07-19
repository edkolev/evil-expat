;; list of the all the dependencies, including the dev dependencies
(defvar dev-packages
  '(evil evil-test-helpers package-lint))

;; initialize package.el
(setq package-user-dir
      (expand-file-name (format ".elpa/%s/elpa" emacs-version)))
(message "installing in %s ...\n" package-user-dir)
(package-initialize)
(setq package-archives
      '(("melpa" . "http://melpa.org/packages/")
        ("gnu" . "http://elpa.gnu.org/packages/")))
(package-refresh-contents)

;; install dependencies
(dolist (package dev-packages)
  (unless (package-installed-p package)
    (ignore-errors
      (package-install package))))

;; upgrade dependencies
(save-window-excursion
  (package-list-packages t)
  (condition-case nil
      (progn
        (package-menu-mark-upgrades)
        (package-menu-execute t))
    (error
     (message "All packages up to date"))))
