;;; evil-expat.el --- Evil ex commands -*- lexical-binding: t; coding: utf-8 -*-

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
  :type line
  :repeat nil
  (interactive "<r>")
  (when (eq (line-number-at-pos beg) (line-number-at-pos (1- end)))
    (user-error "More than one lines must be selected"))
  (reverse-region beg end))
(evil-ex-define-cmd "rev[erse]" 'evil-expat-reverse)

(provide 'evil-expat)

;;; evil-expat.el ends here
