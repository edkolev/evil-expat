;;; evil-expat.el --- Evil ex commands -*- coding: utf-8 -*-

;; Copyright (C) 2017 edkolev

;; Author: edkolev <evgenysw@gmail.com>
;; URL: http://github.com/edkolev/evil-expat
;; Package-Requires: ((emacs "24.3") (evil "1.0.0"))
;; Version: 0.0.1
;; Keywords: emulations, evil, vim

;; This file is NOT part of GNU Emacs.

;;; License:
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; Evil ex commands
;;
;; Usage:
;;
;; (require 'evil-expat)
;;
;; The above lines will install extra evil ex commands.
;;
;;; Code:

(require 'evil)

(evil-define-command evil-expat-reverse (beg end)
  "Reverse the lines between BEG and END."
  :type line
  :repeat nil
  (interactive "<r>")
  (when (eq (line-number-at-pos beg) (line-number-at-pos (1- end)))
    (user-error "More than one lines must be selected"))
  (reverse-region beg end))
(evil-ex-define-cmd "rev[erse]" 'evil-expat-reverse)

;; :remove to delete file and buffer
(evil-define-command evil-expat-remove ()
  "Remove the current file and its buffer."
  (interactive)
  (let ((filename (buffer-file-name)))
    (unless filename
      (user-error "Buffer %s is not visiting a file" (buffer-name)))
    (delete-file filename)
    (kill-buffer)
    (message "Removed %s and its buffer" filename)))
(evil-ex-define-cmd "remove" 'evil-expat-remove)

(evil-define-command evil-expat-rename (bang new-name)
  "Rename the current file and its buffer to NEW-NAME."
  ;; TODO create any missing directory structure
  (interactive "<!><f>")
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (unless filename
      (user-error "Buffer %s is not visiting a file" name))
    (when (string-equal (expand-file-name filename) (expand-file-name new-name))
      (user-error "%s and %s are the same file" buffer-file-name new-name))
    (when (and (file-exists-p new-name) (not bang))
      (user-error "File %s exists, use :grename! to overwrite it" new-name))
    (when (and (get-buffer new-name) (not bang))
      (user-error "A buffer named %s already exists" new-name))

    (condition-case err
        (rename-file filename new-name bang)
      (error
       (if (and (string-match-p "File already exists" (error-message-string err)) (not bang))
           (user-error "File %s exists, use :grename! to overwrite it" new-name)
         (user-error (error-message-string err)))))
    (set-visited-file-name new-name t)
    (set-buffer-modified-p nil)))
(evil-ex-define-cmd "rename" 'evil-expat-rename)

(declare-function magit-file-tracked-p "ext:magit")
(declare-function magit-file-delete "ext:magit")

(evil-define-command evil-expat-gblame ()
  (unless (require 'magit nil 'noerror)
    (user-error "Package magit isn't installed"))
  (call-interactively 'magit-blame))
(evil-ex-define-cmd "gblame" 'evil-expat-gblame)

(evil-define-command evil-expat-gremove (bang)
  "Remove current file and its buffer.

BANG forces removal of files with modifications"
  (interactive "<!>")
  (unless (require 'magit nil 'noerror)
    (user-error "Package magit isn't installed"))
  (let ((filename (buffer-file-name)))
    (unless filename
      (user-error "Buffer %s is not visiting a file" (buffer-name)))
    (unless (magit-file-tracked-p filename)
      (user-error "File %s is not tracked by git" filename))

    ;; call magit to remove the file
    (let ((magit-process-raise-error t))
      (condition-case err
          (magit-file-delete filename bang)
        (magit-git-error
         (if (string-match-p "the following file has local modifications" (error-message-string err))
             (user-error "File %s has modifications, use :gremove! to force" (buffer-name))
           (user-error (error-message-string err))))))
    (when (not (file-exists-p filename))
      (kill-buffer))))
(evil-ex-define-cmd "gremove" 'evil-expat-gremove)

;; define :tyank and :tput only when running under tmux
(when (and (getenv "TMUX") (executable-find "tmux"))
  (evil-define-command evil-expat-tyank (begin end _type)
    "Save range in tmux paste buffer"
    (interactive "<R>")
    (shell-command (concat "tmux set-buffer " (shell-quote-argument (buffer-substring begin end)))))
  (evil-ex-define-cmd "tyank" 'evil-expat-tyank)

  (evil-define-command evil-expat-tput ()
    "Paster from tmux paste buffer."
    (interactive)
    (save-excursion
      (end-of-line)
      (newline)
      (insert (shell-command-to-string "tmux show-buffer"))))
  (evil-ex-define-cmd "tput" 'evil-expat-tput))

(defun expat-diff-orig ()
  (interactive)
  ;; call diff-buffer-with-file uninteractively to avoid getting a file prompt
  (diff-buffer-with-file))
(evil-ex-define-cmd "diff-orig" 'expat-diff-orig)

(evil-define-interactive-code "<expat-theme>"
  "A color theme ex argument."
  :ex-arg expat-theme
  (list (when (and (evil-ex-p) evil-ex-argument)
          (intern evil-ex-argument))))

(evil-ex-define-argument-type expat-theme
  "Defines an argument type which can take a color theme name."
  :collection
  (lambda (arg predicate flag)
    (let ((completions
           (append '("default") ;; append "default" theme
                   (mapcar 'symbol-name (custom-available-themes)))))
      (when arg
        (cond
         ((eq flag nil)
          (try-completion arg completions predicate))
         ((eq flag t)
          (all-completions arg completions predicate))
         ((eq flag 'lambda)
          (test-completion arg completions predicate))
         ((eq (car-safe flag) 'boundaries)
          (cons 'boundaries
                (completion-boundaries arg
                                       completions
                                       predicate
                                       (cdr flag)))))))))

(evil-define-command expat-colorscheme (theme)
  (interactive "<expat-theme>")
  (mapc #'disable-theme custom-enabled-themes)
  (unless (string-equal "default" theme)
    (load-theme theme t)))

(evil-ex-define-cmd "colo[rscheme]" 'expat-colorscheme)

(provide 'evil-expat)

;;; evil-expat.el ends here
