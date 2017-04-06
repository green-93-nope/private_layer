;;; keybindings.el --- green-org layer keybindings file for Spacemacs.
;;
;; Copyright (c) 2012-2016 Sylvain Benner & Contributors
;;
;; Author:  <green@green_thinking>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(spacemacs/set-leader-keys-for-major-mode 'org-mode "op" 'org-preview-latex-fragment)
(spacemacs/set-leader-keys "oo" 'org-preview-latex-fragment)
