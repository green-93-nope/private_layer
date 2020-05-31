;;; packages.el --- green-tool layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2017 Sylvain Benner & Contributors
;;
;; Author:  <green@green_thinking>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;;; Commentary:

;; See the Spacemacs documentation and FAQs for instructions on how to implement
;; a new layer:
;;
;;   SPC h SPC layers RET
;;
;;
;; Briefly, each package to be installed or configured by this layer should be
;; added to `green-tool-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `green-tool/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `green-tool/pre-init-PACKAGE' and/or
;;   `green-tool/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:

(defconst green-tool-packages
  '(openwith
    atomic-chrome
    )
  "The list of Lisp packages required by the green-tool layer.

Each entry is either:

1. A symbol, which is interpreted as a package to be installed, or

2. A list of the form (PACKAGE KEYS...), where PACKAGE is the
    name of the package to be installed or loaded, and KEYS are
    any number of keyword-value-pairs.

    The following keys are accepted:

    - :excluded (t or nil): Prevent the package from being loaded
      if value is non-nil

    - :location: Specify a custom installation location.
      The following values are legal:

      - The symbol `elpa' (default) means PACKAGE will be
        installed using the Emacs package manager.

      - The symbol `local' directs Spacemacs to load the file at
        `./local/PACKAGE/PACKAGE.el'

      - A list beginning with the symbol `recipe' is a melpa
        recipe.  See: https://github.com/milkypostman/melpa#recipe-format")

(defun green-tool/init-openwith ()
  (use-package openwith
    :init
    (openwith-mode t)
    (setq openwith-associations
          (list
           (list (openwith-make-extension-regexp
                  '("mpg" "mpeg" "mp3" "mp4"
                    "avi" "wmv" "wav" "mov" "flv"
                    "ogm" "ogg" "mkv"))
                 "mpv"
                 '(file))
           (list (openwith-make-extension-regexp
                  '("doc" "xls" "ppt" "odt" "ods" "odg" "odp"))
                 "libreoffice"
                 '(file))
           '("\\.lyx" "lyx" (file))
           '("\\.chm" "kchmviewer" (file))
           (list (openwith-make-extension-regexp
                  '("pdf" "ps" "ps.gz" "dvi"))
                 "okular"
                 '(file))
           ))
    )
  )

(defun green-tool/init-atomic-chrome ()
  (use-package atomic-chrome
    :init
    (atomic-chrome-start-server)
        )
  )

(defun green-tool/my-find-file-internal (directory)
  "Find file in Directory."
  (let*((cmd "fd -t f")
       (default-directory directory)
       (output (shell-command-to-string cmd))
       (lines (cdr (split-string output "[\n\r]+")))
       selected-line)
    (setq selected-line (ivy-read (format "Find file in %s: " default-directory)
                                  lines))
    (when (and selected-line (file-exists-p selected-line))
      (find-file selected-line))))

(defun green-tool/my-find-file-in-project()
  "Find file in project root directory"
  (interactive)
  (green-tool/my-find-file-internal (locate-dominating-file default-directory ".git")))

(defun green-tool/my-find-file (&optional level)
  (interactive "P")
  (unless level
    (setq level 0))
  (let* ((parent-directory default-directory)
         (i 0))
    (while (< i level)
      (setq parent-directory (file-name-directory (directory-file-name parent-directory)))
      (setq i (+ i 1)))
    (green-tool/my-find-file-internal parent-directory)))
;;; packages.el ends here
