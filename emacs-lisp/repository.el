;;; -*- emacs-lisp -*-

;;;
;;; $Id: repository.el,v 1.2 2007/04/24 10:50:40 eserte Exp $
;;; Author: Slaven Rezic
;;;
;;; Copyright (C) 2000, 2001 Slaven Rezic. All rights reserved.
;;; This program is free software.
;;;
;;; Mail: slaven.rezic@berlin.de
;;; WWW:  http://www.rezic.de/eserte
;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; To use the repository.el functions, put the emacs/repository.el file
;;; into an emacs load-path directory
;;; (e.g. /usr/local/share/emacs/site-lisp/)
;;; and add the following lines to your .emacs:
;;;
;;;   (autoload 'repository-insert "repository" "Source repository" t)
;;;   (define-key global-map [C-f10] 'repository-insert)
;;;
;;; By pressing Control-F10, you will get a prompt to choose a function
;;; to insert at the cursor. You can use the TAB for auto-completion.
;;;
;;; The functions should be put in the repository directories, which
;;; by default are in ~/src/repository/perl, ~/src/repository/c,
;;; ~/src/repository/emacs-lisp etc., that is, the repository root directory
;;; concatenated with the name of the current major mode. To use another
;;; repository root directory set the repository-directory variable:
;;;
;;;   (setq repository-directory (concat (getenv "HOME") "/src/repository"))
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar repository-directory (concat (getenv "HOME") "/src/repository"))

(defvar repository-md5-executable nil)
(defvar repository-md5-executable-type nil)

(defun repository-current-mode ()
  (let ((mode (format "%s" major-mode)))
    (if (= (string-match "^\\(.*\\)-mode$" mode) 0)
	(progn
	  (setq mode (substring mode (match-beginning 1) (match-end 1)))
	  (if (string= mode "cperl")
	      (setq mode "perl"))
	  mode)
      nil)))

(defun repository-header ()
  (concat comment-start "REPO BEGIN" comment-end))

(defun repository-footer ()
  (concat comment-start "REPO END" comment-end))

(defun repository-name (name)
  (concat comment-start "REPO NAME " name " " repository-directory " " 
	  comment-end))
 
; XXX noch nicht OK:  
(defun repository-buffer-func-modified-p ()
  (save-excursion
    (let (first last oldmd5 newmd5)
      (setq first (search-backward (repository-header)))
      (setq last (search-forward (repository-footer)))
      (goto-char first)
      (search-forward-regexp "REPO MD5 \\([^ \n]+\\)" last)
      (setq oldmd5 (buffer-substring (match-beginning 1) (match-end 1)))
      (setq newmd5 (repository-md5-string
		    (buffer-substring (progn (forward-char) (point))
				      (- last
					 (length (repository-footer))))))
      (not (string= oldmd5 newmd5)))))

(defun repository-md5 (file)
  (concat comment-start "REPO MD5 "
	  (if (eq repository-md5-executable-type 'md5)
	      (repository-md5-file file)
	    (repository-md5sum-file file))
	  comment-end))

(defun repository-md5-file (file)
  (let* ((md5str (shell-command-to-string
		  (concat repository-md5-executable " " file))))
    (string-match "^MD5.*) = \\(.*\\)$" md5str)
    (substring md5str (match-beginning 1) (match-end 1))))

(defun repository-md5sum-file (file)
  (let* ((md5str (shell-command-to-string
		  (concat repository-md5-executable " " file))))
    (string-match "^\\([^ ^]*\\)" md5str)
    (substring md5str (match-beginning 1) (match-end 1))))

(defun repository-md5-string (s)
  (save-excursion
    (set-buffer (get-buffer-create "*repository*"))
    (setq buffer-read-only nil)
    (erase-buffer)
    (call-process "md5" nil t nil "-s" s)
    (string-match "\\`MD5\\(\n\\|.\\)*) = \\(.*\\)\n\\'" (buffer-string))
    (buffer-substring (1+ (match-beginning 2))
		      (1+ (match-end 2))))) ; warum 1+? emacs-bug?

;;; XXX repository-md5sum-string missing 

(defun repository-current-directory ()
  (let* ((dir repository-directory)
	 (mode (repository-current-mode))
	 (dir (concat dir "/" mode)))
    dir))
	 
(defun repository-get-files ()
  (let* ((dir (repository-current-directory))
	 (files (directory-files dir))
	 (ret-files))
    (while files
      (let ((file (car files)))
	(if (and (not (string= file "CVS"))
		 (not (string= file "."))
		 (not (string= file ".."))
		 (not (string-match "^#" file))
		 (not (string-match "~$" file))
		 (file-regular-p (concat dir "/" file)))
	    (setq ret-files (cons file ret-files)))
	(setq files (cdr files))))
    ret-files))

;;; XXXX geht so nicht... interactive ist nicht geschaffen dafür...
(defun repository-insert-plain ()
  (interactive)
  (repository-insert t))

(defun repository-insert ()
  (interactive
   (let* ((no-repo nil)
	  (mode (repository-current-mode))
	  (dir (repository-current-directory))
	  (files (repository-get-files))
	  (func (completing-read (concat mode " function: ")
				 (mapcar 'list files)
				 nil t nil))
	  (file (concat dir "/" func))
	  markpos)
     (save-excursion
       (if (= (point) (point-max))
	   (progn
	     (insert "\n")
	     (backward-char)))
       (if (not no-repo)
	   (progn
	     (insert (repository-header) "\n")
	     (insert (repository-name func) "\n")
	     (insert (repository-md5 file) "\n")
	     (insert "\n") ; strictly needed for perl's pod
	     ))
       ;;; XXX what about the MD5 fingerprint?
       (let ((repo-mark (make-marker)))
	 (set-marker repo-mark (1+ (point)))
	 (insert-file file)
	 (goto-char (1- (marker-position repo-mark)))
	 (if (not no-repo)
	     (insert (repository-footer) "\n")
	   )
	 (setq markpos (point))
	 ))
     (push-mark markpos)
     )))

(defun repository-find-md5-executable ()
  (if (not repository-md5-executable)
      (let ((md5exe (repository-is-in-path "md5"))
	    (md5sumexe (repository-is-in-path "md5sum")))
	(if md5exe
	    (progn
	      (setq repository-md5-executable md5exe)
	      (setq repository-md5-executable-type 'md5))
	  (setq repository-md5-executable md5sumexe)
	  (setq repository-md5-executable-type 'md5sum))))
  )

;REPO BEGIN
;REPO NAME is-in-path /home/e/eserte/src/repository 
;REPO MD5 2645fe579dda3f32dc7407fe5b0699be
(defun repository-is-in-path (prog)
  "For program name PROG return nil, if there is no such programm in $PATH or
the complete pathname to the program."
  (let ((path (parse-colon-path (getenv "PATH")))
	(found nil)
	currpath
	dir)
    (while (and path
		(not found))
      (setq dir (car path))
      (setq currpath (concat dir (char-to-string directory-sep-char) prog))
      (if (and (file-exists-p currpath)
	       (file-executable-p currpath))
	  (setq found currpath))
      (setq path (cdr path))
    )
    found))
;REPO END

(defun repository-update ())

(defun repository-mark-region ()
  (interactive)
  (let (first last)
    (setq first (search-backward (repository-header)))
    (setq last (search-forward (repository-footer)))
    (set-mark last)
    (goto-char first)
    )
  )

(repository-find-md5-executable)

(provide 'repository)

;;; TODO ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; - option: insert perl files without pod
;;; - implement repository-update(-all), repository-check(-all)
;;;
