;; ---------------------------------------------------------------------
;; Monkeytype / Speed typing made simple
;;
;; GNU Emacs / N Λ N O - Emacs made simple
;; Copyright (C) 2020 - N Λ N O developers
;;
;; This program is free software; you can redistribute it and/or modify
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
;; along with this program. If not, see <http://www.gnu.org/licenses/>.
;; ---------------------------------------------------------------------
(package-initialize)

;; Path to nano emacs modules (mandatory)
(add-to-list 'load-path ".")

(require 'nano)

;;;; N Λ N O Emacs default's resetting

(set-default 'cursor-type  '(bar . 1))

;;;;; Modeline
(defun nano-modeline-monkeytype-mode-p ()
  (bound-and-true-p monkeytype-mode))

(defun nano-modeline-monkeytype-mode ()
  (let ((buffer-name "MT")
        (mode-name   (format-mode-line "%m"))
        (mt-status  (format-mode-line
                     (assoc 'monkeytype-mode minor-mode-alist)) )
        (position    (replace-regexp-in-string
                      "\\(TOP\\)\\([0-9]+\\{2\\}%\\)"
                      "TOP"
                      (format-mode-line '("L:%l %P%%%2")))))
    (nano-modeline-compose (nano-modeline-status)
                           buffer-name
                           mt-status
                           position)))

(setq-default header-line-format
  '((:eval
     (cond ((nano-modeline-monkeytype-mode-p)
            (nano-modeline-monkeytype-mode))
           (t
            (nano-modeline-default-mode))))))

;;;; Straight
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

;;;; Monkeytype
(setq fortune-file "/usr/local/share/games/fortunes")

(use-package centered-cursor-mode :defer t)

(use-package scrollable-quick-peek
  :requires quick-peek
  :straight (:host github :repo "jpablobr/scrollable-quick-peek"))

(use-package monkeytype
  :straight (:host github :repo "jpablobr/emacs-monkeytype")
  :requires quick-peek
  :config

  (defun monkeytype-mode-hook ()
    "Hooks for monkeytype-mode."
    ;; nil disables the mode-line completely
    ;; (setq monkeytype-mode-line nil)

    ;; Update `quick-peek' to use Nano's faces
    (set-face 'quick-peek-background-face 'region)
    (set-face 'quick-peek-border-face 'nano-face-header-separator)
    (set-face 'quick-peek-padding-face 'nano-face-header-filler)
    (centered-cursor-mode))
  (add-hook 'monkeytype-mode-hook #'monkeytype-mode-hook))

(when (file-exists-p "monkeytype.local.el")
  (require 'monkeytype.local))
