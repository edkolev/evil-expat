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

(evil-define-command evil-expat-rename (new-name)
  "Rename the current file and its buffer to NEW-NAME."
  ;; TODO create any missing directory structure
  ;; TODO with bang, overwrite existing files
  (interactive "<f>")
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (unless filename
      (user-error "Buffer %s is not visiting a file" name))
    (when (string-equal (expand-file-name filename) (expand-file-name new-name))
      (user-error "%s and %s are the same file" buffer-file-name new-name))
    (when (file-exists-p new-name)
      (user-error "File %s already exists" new-name))
    (when (get-buffer new-name)
      (user-error "A buffer named %s already exists" new-name))

    (rename-file filename new-name 1)
    (rename-buffer new-name)
    (set-visited-file-name new-name)
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
             (user-error "File %s has modifications, use :gremove! to force" (buffer-file-name))
           (user-error (error-message-string err))))))
    (when (not (file-exists-p filename))
      (kill-buffer))))
(evil-ex-define-cmd "gremove" 'evil-expat-gremove)

(provide 'evil-expat)

;;; evil-expat.el ends here
