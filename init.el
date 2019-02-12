(require 'package)
(add-to-list 'package-archives
	     '("elpy" . "http://jorgenschaefer.github.io/packages/"))
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives
             '("org" . "http://orgmode.org/elpa/") t)
(package-initialize)

(require 'org)
(setq org-src-tab-acts-natively t)
(org-babel-load-file
 (expand-file-name "settings.org"
                   user-emacs-directory))
