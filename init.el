(package-initialize)

(require 'package)
(add-to-list 'package-archives
	     '("elpy" . "https://jorgenschaefer.github.io/packages/"))

(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives
	     '("org" . "https://orgmode.org/elpa/") t)

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)

;; This is only needed once, near the top of the file
(eval-when-compile
  ;; Following line is not needed if use-package.el is in ~/.emacs.d
;;  (add-to-list 'load-path "<path where use-package is installed>")
  (require 'use-package))

(use-package highlight-indentation :ensure t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; org-mode settings
(use-package org-bullets
  :ensure t
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
  (setq org-settings-file "~/.emacs.d/org-settings.el")
  (load org-settings-file 'noerror)
  :bind
	("\C-cl" . org-store-link)
	("\C-ca" . org-agenda)
	("\C-cc" . org-capture)
	("\C-cb" . org-iswitchb)
        )
(use-package org-bullets :ensure t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GUI settings
; by default emacs rounds frame size to nearest char height. ~~this is no.~~ is no for GUI. required for console.
;(setq frame-resize-pixelwise t)
(set-face-attribute 'default nil :height 150)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq recentf-mode 1)

;; fixes an issue with scrolling latency.
(setq scroll-conservatively 10000
   scroll-preserve-screen-position t)

(global-set-key (kbd "C-x C-b") 'ibuffer)
(setq ibuffer-expert t)  ;; don't ask me about everything
(add-hook 'ibuffer-mode-hook
       '(lambda ()
          (ibuffer-auto-mode 1))) ;; auto-update ibuffer
(use-package rainbow-delimiters :ensure t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Python programming

(use-package elpy
  :ensure t
  :init
  ;; Tell elpy we use python3.
  (setq elpy-rpc-python-command "python3")
  :config
  (elpy-enable)
  ;; Tell elpy where/how to run unit-tests.
  (setq elpy-test-discover-runner-command (quote ("python3" "-m" "unittest")))
  )
(use-package python-black :ensure t)
(use-package flycheck :ensure t)
(use-package flymake-python-pyflakes :ensure t)
(add-hook 'python-mode-hook (setq intent-tabs-mode t) (setq tab-width 4))

;; autoformat buffer.
(add-hook 'python-mode-hook (lambda ()
                             (add-hook 'before-save-hook 'python-black-buffer)))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; C programming

;; specify a code formatting standard for C
(setq-default c-basic-offset 4)
(c-set-offset 'case-label '+)
(setq c-default-style "linux" c-basic-offset 4)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; C++ programming

(defun cpp-compile ()
  "Compile using `g++` and run"
  (interactive)
  (compile (format "g++ %s -Wall -Wextra -Wpedantic -Wconversion -std=c++17 -O2 -o bin" (buffer-file-name))))

(add-hook 'c-mode '(lambda ()
                     (define-key c-mode-base-map (kbd "C-c C-c") #'cpp-compile)))
;;; rtag sounds neat, but it just don't build :<
;(add-hook 'c-mode-hook 'rtags-start-process-unless-running)
;(add-hook 'c++-mode-hook 'rtags-start-process-unless-running)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; golang
;; go land!
;; deps: gopls, goimport, go-guru
;; todo - some major touchups. Let's break all the requires out.
;; TODO ensures.
(defun run-go-tests () (interactive)
	   (async-shell-command "go test -v"))

(use-package go-mode
  :ensure t
  :bind
  (:map go-mode-map
        ("C-c d" . lsp-describe-thing-at-point)
        ("C-c g" . godoc)
        ("C-i" . company-indent-or-complete-common)
        ("C-M-i" . company-indent-or-complete-common)
        ("M-." . godef-jump)
        ("M-*" . pop-tag-mark)
		("C-c C-c" . run-go-tests)
		)

  :init ;; changed from config
  (setq gofmt-command "gofmt"     ; use goimports or gofmt
        company-idle-delay nil)	; avoid auto completion popup, use TAB
                                        ; to show it
  (setq company-minimum-prefix-length 2)
  (add-hook 'before-save-hook #'gofmt-before-save)
  (add-hook 'go-mode-hook 'yas-minor-mode)


  ;; eldoc
  (require 'go-eldoc)
  (add-hook 'go-mode-hook 'go-eldoc-setup)
  ;; ;; guru
  (require 'go-guru)

  ;; ;; completion
  (require 'lsp)
  (add-hook 'go-mode-hook #'lsp)
  )
(setq-default tab-width 3)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; LSP mode
(use-package lsp-mode
  :ensure
  :commands lsp
  :custom
  (lsp-eldoc-render-all t)
  (lsp-idle-delay 0.6)
  (lsp-rust-analyzer-server-display-inlay-hints t)
  :bind
  (:map lsp-mode-map
        ("C-M-j" . lsp-ui-imenu)) ;; show a handy outline of the code structure.
  :config
  (add-hook 'lsp-mode-hook 'lsp-ui-mode))

(use-package lsp-ui
  :ensure
  :commands lsp-ui-mode
  :custom
  (lsp-ui-peek-always-show t)
  (lsp-ui-sideline-show-hover t)
  (lsp-ui-doc-enable nil))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Company-mode
(use-package company
  :ensure
  :custom
  (company-idle-delay 0.5) ;; how long to wait until popup
  ;; (company-begin-commands nil) ;; uncomment to disable popup
  :bind
  (:map company-active-map
	      ("C-n". company-select-next)
	      ("C-p". company-select-previous)
	      ("M-<". company-select-first)
	      ("M->". company-select-last))
  (:map company-mode-map
	("<tab>". tab-indent-or-complete)
	("TAB". tab-indent-or-complete)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Mobility
(use-package avy
  :ensure t
  :bind ("M-\\" . avy-goto-char))
(use-package ace-window
  :ensure t
  :bind ("M-o" . ace-window)
  :config
  (setq aw-keys '(?j ?k ?l ?\; ?m ?o ?i ?p))
  )

(global-set-key (kbd "C-S-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "C-S-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "C-S-<down>") 'shrink-window)
(global-set-key (kbd "C-S-<up>") 'enlarge-window)

;; credit for move-line-up and move-line down:
;; https://emacsredux.com/blog/2013/04/02/move-current-line-up-or-down/
(defun move-line-up ()
  "Move up the current line."
  (interactive)
  (transpose-lines 1)
  (forward-line -2)
  (indent-according-to-mode))

(defun move-line-down ()
  "Move down the current line."
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1)
  (indent-according-to-mode))

(global-set-key (kbd "C-M-<up>") 'move-line-up)
(global-set-key (kbd "C-M-<down>") 'move-line-down)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; misc programming preferences.

;; remove trailing whitespace on lines on save in programming modes.
(add-hook 'prog-mode-hook
	  (lambda ()
	    (add-hook 'before-save-hook 'delete-trailing-whitespace nil t)))

;; tabs? spaces.
;(setq-default indent-tabs-mode t)

;; pretty up some indentation levels
(add-hook 'prog-mode-hook 'highlight-indentation-mode)
(setq highlight-indent-guides-method 'column)

;; make parens look nicer, and easier to pair up visually.
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
(setq show-paren-mode t)

;; show line numbers.
(add-hook 'prog-mode-hook 'linum-mode)


;;:::::::::::::::::::::::::::::::
;; Yasnippet
(use-package yasnippet
  :ensure
  :config
  (yas-reload-all)
  (add-hook 'prog-mode-hook 'yas-minor-mode)
  (add-hook 'text-mode-hook 'yas-minor-mode))

;; a little helper function
(defun company-yasnippet-or-completion ()
  (interactive)
  (or (do-yas-expand)
      (company-complete-common)))
(defun check-expansion ()
  (save-excursion
    (if (looking-at "\\_>") t
      (backward-char 1)
      (if (looking-at "\\.") t
        (backward-char 1)
        (if (looking-at "::") t nil)))))

(defun do-yas-expand ()
  (let ((yas/fallback-behavior 'return-nil))
    (yas/expand)))

(defun tab-indent-or-complete ()
  (interactive)
  (if (minibufferp)
      (minibuffer-complete)
    (if (or (not yas/minor-mode)
            (null (do-yas-expand)))
        (if (check-expansion)
            (company-complete-common)
          (indent-for-tab-command)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; magit
(use-package magit
  :ensure)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Misc macros I have found useful.

;; indent current line, then move to the next.
(fset 'indent-generic [tab ?\C-a ?\C-n])
(global-set-key (kbd "<f9>") 'indent-generic)

;; removes a bunch of spaces, replaces them with a single space.
(fset 'collapse-spacing
      "\C-[xdelete-horizontal-space\C-m ")
(global-set-key (kbd "C-c C-SPC") 'collapse-spacing)

(defun insert-current-date () (interactive)
              (insert (shell-command-to-string "echo -n $(date +%Y-%m-%d)")))
(defun close-all-parentheses ()
  (interactive "*")
  (let ((closing nil))
    (save-excursion
      (while (condition-case nil
         (progn
           (backward-up-list)
           (let ((syntax (syntax-after (point))))
             (cl-case (car syntax)
               ((4) (setq closing (cons (cdr syntax) closing)))
               ((7 8) (setq closing (cons (char-after (point)) closing)))))
           t)
           ((scan-error) nil))))
    (apply #'insert (nreverse closing))))
