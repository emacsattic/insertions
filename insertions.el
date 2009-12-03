;;; insertions.el --- handy things to insert in buffers
;;; Time-stamp: <2007-08-25 15:18:32 jcgs>

;; Copyright (C) 2007, John C. G. Sturdy

;; Author: John C. G. Sturdy <john@cb1.com>
;; Maintainer: John C. G. Sturdy <john@cb1.com>
;; Created: long ago
;; Keywords: convenience

;; This file is NOT part of GNU Emacs.

;;  This program is free software; you can redistribute it and/or modify it
;;  under the terms of the GNU General Public License as published by the
;;  Free Software Foundation; either version 3 of the License, or (at your
;;  option) any later version.

;;  This program is distributed in the hope that it will be useful, but
;;  WITHOUT ANY WARRANTY; without even the implied warranty of
;;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;;  General Public License for more details.

;;  You should have received a copy of the GNU General Public License along
;;  with this program; if not, write to the Free Software Foundation, Inc.,
;;  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA


;;; Commentary:
;; 


;;; History:
;; 

;;; Code:
(provide 'insertions)

;;;###autoload
(defun other-window-file-name (&optional non-directory)
  "Insert at point the name of the file in the next window.
With optional (prefix) argument, insert only the non-directory part of the name.
Particularly useful in a shell window."
  (interactive "*P")
  (let ((name
	 (save-window-excursion
	   (buffer-file-name
	    (window-buffer
	     (other-window 1))))))
    (if name
	(insert
	 (if non-directory
	     (file-name-nondirectory name)
	   name))
      (message "Other window has no file"))
    name))

;;;###autoload
(defun other-window-directory-name ()
  "Insert at point the name of the directory of the file in the next window.
Particularly useful in a shell window."
  (interactive "*")
  (let ((name
	 (save-window-excursion
	   (file-name-directory
	    (buffer-file-name
	     (window-buffer
	      (other-window 1)))))))
    (if name
	(insert name)
      (message "Other window has no file"))))
  
;;;###autoload
(defun cd-supposed-directory ()
  "Insert a cd command to the current directory of the buffer."
  (interactive)
  (insert "cd " (expand-file-name default-directory)))

(defvar load-syntaces
  '((emacs-lisp-mode . "(load-file \"%s\")")
    (lisp-mode . "(load \"%s\")")
    (sh-mode . "%s")
    (shell-mode . "%s")
    (postscript-mode . "(%s) run")
    (sml-mode . "use \"%s\";"))
  "Formats for loading files in various languages.")

;;;###autoload
(defun load-other-window-file-name ()
  "Insert at point the name of the file in next window, in the likeliest syntax.
Particularly useful in a shell window."
  (interactive "*")
  (insert
   (save-window-excursion
     (set-buffer (window-buffer (other-window 1)))
     (if buffer-file-name
	 (let ((format-pair (assoc major-mode load-syntaces)))
	   (if format-pair
	       (format (cdr format-pair) buffer-file-name)
	     buffer-file-name))
       (error "Other window has no file")))))

;;;###autoload
(defun eval-insert (expr)
  "Insert something in the current buffer.
If this is called interactively, the expression is read using the minibuffer, and
evaluated to give the text to insert."
  (interactive "XInsert result of evaluating: ")
  (insert
   (cond
    ((stringp expr)                     ; treat this case specially, to
     expr)                              ; avoid \"quotes\" which are probably
    ('else                              ; unwanted ...
     (prin1-to-string expr)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;
; Inserting key commands ;
;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;###autoload
(defun insert-key-command (key-sequence)
  "Insert at point the Emacs function name bound to KEY-SEQUENCE."
  (interactive "*kInsert emacs function for key sequence: ")
  (let ((function (key-binding key-sequence)))
    (insert (symbol-name function) " ")
    (describe-function function)))

;;;###autoload
(defun insert-key-description ()
  "Read a key and insert its description."
  (interactive)
  (let ((description (key-description (list (read-event "Key to insert: ")))))
    (insert
     (if (string-match "<\\(.+\\)>" description)
	 (match-string 1 description)
       description))))

;;;###autoload
(defun insert-function-name (fun)
  "Insert the emacs-lisp function name FUN in the buffer; read using
completion if called interactively."
  (interactive "aFunction name to insert: ")
  (insert (symbol-name fun)))

;;;###autoload
(defun insert-variable-name (var)
  "Insert the emacs-lisp variable name VAR in the buffer; read using
completion if called interactively."
  (interactive "SVariable (symbol) name to insert:")
  (insert (symbol-name var)))

(defun insert-autoload-cookie ()
  "Insert an autoload cookie."
  (interactive)
  (insert generate-autoload-cookie "\n"))

;;; end of insertions.el

(provide 'insertions)

;;; insertions.el ends here
