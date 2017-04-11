;;; keybindings.el --- green-tool layer keybindings file for Spacemacs.
;;
;; Copyright (c) 2012-2016 Sylvain Benner & Contributors
;;
;; Author:  <green@green_thinking>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(spacemacs/declare-prefix "oa" "aya")
(spacemacs/set-leader-keys "oaw" #'aya-create)
(spacemacs/set-leader-keys "oay" #'aya-expand)
(spacemacs/set-leader-keys "oao" #'aya-open-line)
