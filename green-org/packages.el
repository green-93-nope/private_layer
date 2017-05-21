;;; packages.el --- green-org layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2016 Sylvain Benner & Contributors
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
;; added to `green-org-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `green-org/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `green-org/pre-init-PACKAGE' and/or
;;   `green-org/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:

(defconst green-org-packages
  '(
    org
    org-octopress
    ox-publish
    prodigy
    )
  "The list of Lisp packages required by the green-org layer.

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
(defun green-org/post-init-ox-publish()
  (with-eval-after-load 'ox-publish
    (defun org-custom-link-img-follow (path)
      (org-open-file-with-emacs
       (format "../source/img/%s" path)))
    (defun org-custom-link-img-export (path desc format)
      (cond
       ((eq format 'html)
        (format "<img src=\"/img/%s\" alt=\"%s\"/>" path desc))))
    (org-add-link-type "img" 'org-custom-link-img-follow 'org-custom-link-img-export)
    )
  )
(defun green-org/init-org-octopress()
  (use-package org-octopress
    :commands (org-octopress org-octopress-setup-publish-project)
    :init
    (progn
      (setq org-octopress-directory-top       "~/Hexo")
      (setq org-octopress-directory-posts     "~/Hexo/source/_posts")
      (setq org-octopress-directory-org-top   "~/Hexo")
      (setq org-octopress-directory-org-posts "~/Hexo/blog")
      (setq org-octopress-setup-file "~/Hexo/setupfile.org")
      )
    )
  )
(defun green-org/post-init-prodigy()
  (with-eval-after-load 'prodigy
    (prodigy-define-service
      :name "Hexo Server"
      :command "hexo"
      :args '("server")
      :cwd "~/Hexo"
      :tags '(hexo server)
      :kill-signal 'sigkill
      :kill-process-buffer-on-stop t)

    (prodigy-define-service
      :name "Hexo Deploy"
      :command "hexo"
      :args '("deploy" "--generate")
      :cwd "~/Hexo"
      :tags '(hexo deploy)
      :kill-signal 'sigkill
      :kill-process-buffer-on-stop t)
    )
  )

(defun green-org/post-init-org()
  (with-eval-after-load 'org
    (progn
      (setq org-capture-templates
            '(("t" "Todo" entry (file+headline "~/org/gtd.org" "Tasks")
               "* TODO %?\n  %i\n  %a")
              ("j" "Journal" entry (file+datetree "~/org/journal.org")
               "* %?\nEntered on %U\n  %i\n  %a")
              ("n" "Notes" entry (file+datetree "~/org/journal.org")
               "* %?\nEntered on %U\n  %i\n  %a")))

      (setq org-agenda-files (list "~/org/work.org"
                                   "~/org/school.org" 
                                   "~/org/home.org"
                                   "~/org/gtd.org"))
      ;; org-mode export to latex
      (setq xelatexmagick '(xelatexmagick
                            :programs ("latex" "convert" "gs")
                            :description "pdf > png"
                            :message
                            "you need to install programs: latex, imagemagick and ghostscript."
                            :use-xcolor t
                            :image-input-type "pdf"
                            :image-output-type "png"
                            :image-size-adjust (1.0 . 1.0)
                            :latex-compiler ("xelatex -interaction nonstopmode -output-directory %o %f")
                            :image-converter
                            ("convert -background white -alpha remove -trim +repage %f %O")
                            ))
      (add-to-list 'org-preview-latex-process-alist xelatexmagick)

      (setq org-preview-latex-default-process 'xelatexmagick)
      ;;org-mode export to PDF with xelatex 
      (require 'ox-latex)
      ;;org-mode source code setup in exporting to latex
      (add-to-list 'org-latex-listings '("" "listings"))
      (add-to-list 'org-latex-listings '("" "color"))

      (add-to-list 'org-latex-packages-alist
                   '("" "fontenc" t))
      (add-to-list 'org-latex-packages-alist
                   '("" "algorithm" t))
      (add-to-list 'org-latex-packages-alist
                   '("" "algpseudocode" t))
      (add-to-list 'org-latex-packages-alist
                   '("" "algorithmicx" t))
      (add-to-list 'org-latex-packages-alist
                   '("" "xcolor" t))
      (add-to-list 'org-latex-packages-alist
                   '("" "listings" t))
      (add-to-list 'org-latex-packages-alist
                   '("" "fontspec" t))
      (add-to-list 'org-latex-packages-alist
                   '("" "indentfirst" t))
      (add-to-list 'org-latex-packages-alist
                   '("" "xunicode" t))
      (add-to-list 'org-latex-packages-alist
                   '("" "geometry"))
      (add-to-list 'org-latex-packages-alist
                   '("" "float"))
      (add-to-list 'org-latex-packages-alist
                   '("" "longtable"))
      (add-to-list 'org-latex-packages-alist
                   '("" "tikz"))
      (add-to-list 'org-latex-packages-alist
                   '("" "fancyhdr"))
      (add-to-list 'org-latex-packages-alist
                   '("" "textcomp"))
      (add-to-list 'org-latex-packages-alist
                   '("" "amsmath"))
      (add-to-list 'org-latex-packages-alist

                   ;;  LocalWords:  english
                   '("" "tabularx" t))
      (add-to-list 'org-latex-packages-alist
                   '("" "booktabs" t))
      (add-to-list 'org-latex-packages-alist
                   '("" "grffile" t))
      (add-to-list 'org-latex-packages-alist
                   '("" "wrapfig" t))
      (add-to-list 'org-latex-packages-alist
                   '("normalem" "ulem" t))
      (add-to-list 'org-latex-packages-alist
                   '("" "amssymb" t))
      (add-to-list 'org-latex-packages-alist
                   '("" "capt-of" t))
      (add-to-list 'org-latex-packages-alist
                   '("figuresright" "rotating" t))
      (add-to-list 'org-latex-packages-alist
                   '("Lenny" "fncychap" t))

      (add-to-list 'org-latex-classes
                   '("xelatex-org-book"
                     "\\documentclass{ctexbook}
% chapter set
\\usepackage{titlesec}
\\usepackage{hyperref}

[NO-DEFAULT-PACKAGES]
[PACKAGES]



\\setCJKmainfont{WenQuanYi Micro Hei} % 设置缺省中文字体
\\setCJKsansfont{WenQuanYi Micro Hei}
\\setCJKmonofont{WenQuanYi Micro Hei Mono}

\\setmainfont{DejaVu Sans} % 英文衬线字体
\\setsansfont{DejaVu Serif} % 英文无衬线字体
\\setmonofont{DejaVu Sans Mono}
%\\setmainfont{WenQuanYi Micro Hei} % 设置缺省中文字体
%\\setsansfont{WenQuanYi Micro Hei}
%\\setmonofont{WenQuanYi Micro Hei Mono}

%如果没有它，会有一些 tex 特殊字符无法正常使用，比如连字符。
\\defaultfontfeatures{Mapping=tex-text}

% 中文断行
\\XeTeXlinebreaklocale \"zh\"
\\XeTeXlinebreakskip = 0pt plus 1pt minus 0.1pt

% 代码设置
\\lstset{numbers=left,
numberstyle= \\tiny,
keywordstyle= \\color{ blue!70},commentstyle=\\color{red!50!green!50!blue!50},
frame=shadowbox,
breaklines=true,
rulesepcolor= \\color{ red!20!green!20!blue!20}
}

[EXTRA]
"
                 ("\\chapter{%s}" . "\\chapter*{%s}")
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))


  (add-to-list 'org-latex-classes
               '("xelatex-org-article"
                 "\\documentclass{ctexart}
\\usepackage{xltxtra}
\\usepackage{fontspec}
\\usepackage{xunicode}
\\usepackage{titlesec}
\\usepackage{hyperref}

[NO-DEFAULT-PACKAGES]
[PACKAGES]

\\parindent 2em

\\setCJKmainfont{WenQuanYi Micro Hei} % 设置缺省中文字体
\\setCJKsansfont{WenQuanYi Micro Hei}
\\setCJKmonofont{WenQuanYi Micro Hei Mono}

\\setmainfont{DejaVu Sans} % 英文衬线字体
\\setsansfont{DejaVu Serif} % 英文无衬线字体
\\setmonofont{DejaVu Sans Mono}
%\\setmainfont{WenQuanYi Micro Hei} % 设置缺省中文字体
%\\setsansfont{WenQuanYi Micro Hei}
%\\setmonofont{WenQuanYi Micro Hei Mono}

%如果没有它，会有一些 tex 特殊字符无法正常使用，比如连字符。
\\defaultfontfeatures{Mapping=tex-text}

% 中文断行
\\XeTeXlinebreaklocale \"zh\"
\\XeTeXlinebreakskip = 0pt plus 1pt minus 0.1pt

% 代码设置
\\lstset{numbers=left,
numberstyle= \\tiny,
keywordstyle= \\color{ blue!70},commentstyle=\\color{red!50!green!50!blue!50},
frame=shadowbox,
breaklines=true,
rulesepcolor= \\color{ red!20!green!20!blue!20}
}

[EXTRA]
"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

  (add-to-list 'org-latex-classes
               '("xelatex-org-beamer"
                 "\\documentclass{ctexbeamer}
\\usepackage{ctexcap}
\\usepackage{varwidth}
% beamer set
\\usepackage[none]{hyphenat}
\\usepackage[abs]{overpic}

[NO-DEFAULT-PACKAGES]
[PACKAGES]

\\setCJKmainfont{WenQuanYi Micro Hei} % 设置缺省中文字体
\\setCJKsansfont{WenQuanYi Micro Hei}
\\setCJKmonofont{WenQuanYi Micro Hei Mono}

\\setmainfont{DejaVu Sans} % 英文衬线字体
\\setsansfont{DejaVu Serif} % 英文无衬线字体
\\setmonofont{DejaVu Sans Mono}
%\\setmainfont{WenQuanYi Micro Hei} % 设置缺省中文字体
%\\setsansfont{WenQuanYi Micro Hei}
%\\setmonofont{WenQuanYi Micro Hei Mono}

%如果没有它，会有一些 tex 特殊字符无法正常使用，比如连字符。
\\defaultfontfeatures{Mapping=tex-text}

% 中文断行
\\XeTeXlinebreaklocale \"zh\"
\\XeTeXlinebreakskip = 0pt plus 1pt minus 0.1pt

% 代码设置
\\lstset{numbers=left,
numberstyle= \\tiny,
keywordstyle= \\color{ blue!70},commentstyle=\\color{red!50!green!50!blue!50},
frame=shadowbox,
breaklines=true,
rulesepcolor= \\color{ red!20!green!20!blue!20}
}

[EXTRA]
"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

    (setq org-latex-pdf-process
        '("xelatex -interaction nonstopmode -output-directory %o %f"
          ;;"biber %b" "xelatex -interaction nonstopmode -output-directory %o %f"
          "bibtex %b"
          "xelatex -interaction nonstopmode -output-directory %o %f"
          "xelatex -interaction nonstopmode -output-directory %o %f"))
    )

)
)

;;; packages.el ends here
