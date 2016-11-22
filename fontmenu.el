;;; fontmenu.el --- Examine how a text is rendered in different fonts

;; Copyright (C) 2015-16 Jambunathan K <kjambunathan at gmail dot com>

;; Author: Jambunathan K <kjambunathan at gmail dot com>
;; Maintainer: Jambunathan K <kjambunahtan at gmail dot com>
;; URL: https://github.com/kjambunathan/fontmenu
;; Version: 0.1

;; This file is not part of GNU Emacs.

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Once you load this file, a buffer named "*Font Menu*" is to
;; created.  This buffer displays a sample text in all available
;; fonts.
;;
;; 1. Press 't' to change the sample text.  See `fontmenu-set-text'.
;; 2. Press `s' to narrow the fonts to a chosen script.  See
;;    `fontmenu-set-script'.
;; 3. Press `C-m' to change the frame font to the one under current line.
;;    See `fontmenu-set-frame-font'.

(require 'tabulated-list)

;;; Code:

(defvar-local fontmenu-text "Press `t' to change sample text.  Press `s' to filter fonts by script."
  "Text to display.")

(defvar-local fontmenu-script nil
  "Display only fonts that support this script.")

(defvar fontmenu-mode-map
  (let ((map (make-sparse-keymap))
        (menu-map (make-sparse-keymap "Font Menu")))
    (set-keymap-parent map tabulated-list-mode-map)
    (define-key map "\C-m" 'fontmenu-set-frame-font)
    (define-key map "t" 'fontmenu-set-text)
    (define-key map "s" 'fontmenu-set-script)
    map)
  "Local keymap for `fontmenu-mode' buffers.")

(define-derived-mode fontmenu-mode tabulated-list-mode "Font Menu"
  "Display the string in `fontmenu-text' in all available fonts.  

 \\<fontmenu-mode-map> \\{fontmenu-mode-map}"
  (setq tabulated-list-format
        `[("Font" 30 t)
          ("Text" 30 nil)])
  (setq tabulated-list-padding 2)
  (setq tabulated-list-sort-key (cons "Font" nil))
  (add-hook 'tabulated-list-revert-hook 'fontmenu--refresh nil t)
  (fontmenu--refresh)
  (tabulated-list-init-header)
  (tabulated-list-print))

(defun fontmenu ()
  "Examine how a text is rendered in all available font families.
Use `fontmenu-set-text' to change the sample text.  Use
`fontmenu-set-script' to change the script.  Use
`fontmenu-set-frame-font' to change the frame font to the font in
the current line."
  (interactive)
  (let ((buf (get-buffer-create "*Font Menu*")))
    (with-current-buffer buf
      (fontmenu-mode))
    (switch-to-buffer buf)))

(defun fontmenu--refresh ()
  "Re-populate `tabulated-list-entries'."
  (let ((f (delete-dups
	    (if fontmenu-script
		(mapcar (lambda (spec)
			  (symbol-name (font-get spec :family)))
			(list-fonts  (font-spec :script fontmenu-script)))
	      (font-family-list)))))
    (setq tabulated-list-entries
	  (mapcar
	   (lambda (f)
	     (let ((s (or fontmenu-text f)))
	       (list f (vector
			(cons f `(font-view ,f action fontmenu-set-frame-font))
			(propertize s 'face (list :family f))))))
	   f))))

(defun fontmenu-set-text (s)
  "Set the sample text to S."
  (interactive "sSample Text: ")
  (when (derived-mode-p 'fontmenu-mode)
    (setq fontmenu-text (if (string= s "") (default-value 'fontmenu-text) s))
    (fontmenu--refresh)
    (tabulated-list-print)))

(defun fontmenu-set-script (&optional s)
  "Set preferred script to S.
S is either nil or one of the `script-representative-chars'."
  (interactive
   (list (let ((s (completing-read
		   (format "Script (%s): " (or fontmenu-script ""))
		   script-representative-chars nil t)))
	   (if (string= s "") nil (intern s)))))

  (when (derived-mode-p 'fontmenu-mode)
    (setq fontmenu-script s)
    (fontmenu--refresh)
    (tabulated-list-print)))

(defun fontmenu-set-frame-font ()
  "Set the frame font to the one in current line."
  (interactive)
  (when (derived-mode-p 'fontmenu-mode)
      (let ((f (tabulated-list-get-id)))
	(when (and f (y-or-n-p (format "Set frame font to %s " f)))
	  (set-frame-font f nil t)))))

(call-interactively 'fontmenu)

(provide 'fontmenu)

;;; fontmenu.el ends here
