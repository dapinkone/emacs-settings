(require 'package)
(add-to-list 'package-archives
	     '("elpy" . "https://jorgenschaefer.github.io/packages/"))
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives
             '("org" . "https://orgmode.org/elpa/") t)
(package-initialize)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; custom has to have a place to throw all the auto-gen´d stuff.
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; org-mode settings
(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-cb" 'org-iswitchb)

(setq org-settings-file "~/.emacs.d/org-settings.el")
(load org-settings-file 'noerror)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GUI settings

(set-face-attribute 'default nil :height 150)

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
;(toggle-frame-fullscreen)

;; fixes an issue with scrolling latency.
(setq scroll-conservatively 10000
   scroll-preserve-screen-position t)

(global-set-key (kbd "C-x C-b") 'ibuffer)
(setq ibuffer-expert t)  ;; don't ask me about everything
(add-hook 'ibuffer-mode-hook
       '(lambda ()
          (ibuffer-auto-mode 1))) ;; auto-update ibuffer

(setq recentf-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Mobility
(global-set-key (kbd "M-\\") 'avy-goto-char)

(global-set-key (kbd "M-o") 'ace-window)

(setq aw-keys '(?j ?k ?l ?\; ?m ?o ?i ?p))

(global-set-key (kbd "C-S-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "C-S-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "C-S-<down>") 'shrink-window)
(global-set-key (kbd "C-S-<up>") 'enlarge-window)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Python programming

(elpy-enable)
;; Tell elpy we use python3.
(setq elpy-rpc-python-command "python3")

;; Tell elpy where/how to run unit-tests.
(setq elpy-test-discover-runner-command (quote ("python3" "-m" "unittest")))

;; autoformat buffer.
;; (add-hook 'python-mode-hook (lambda ()
;;                             (add-hook 'before-save-hook 'python-black-buffer)))

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
  (compile (format "g++ %s -o bin" (buffer-file-name))))

(define-key c-mode-base-map (kbd "C-c C-c") #'cpp-compile)
;;; rtag sounds neat, but it just don't build :<
;(add-hook 'c-mode-hook 'rtags-start-process-unless-running)
;(add-hook 'c++-mode-hook 'rtags-start-process-unless-running)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Rust programming

(require 'rust-mode)
;; racer: autocompletion for Rust.

;;; Start the appropriate racer modes when entering rust-mode.
(add-hook 'rust-mode-hook #'racer-mode)
(add-hook 'racer-mode-hook #'eldoc-mode)

;; Interface with company-mode to provide completion.
;; (add-hook 'racer-mode-hook #'company-mode) ;; too slow :(
(define-key rust-mode-map (kbd "TAB") #'company-indent-or-complete-common)

;;(setq company-tooltip-align-annotations t)
(define-key rust-mode-map (kbd "C-c C-c") #'rust-compile)
(add-hook 'rust-mode-hook (lambda ()
                            (add-hook 'before-save-hook 'rust-format-buffer)))
;;;;  syntax error highlighting for rust
(with-eval-after-load 'rust-mode
  (add-hook 'flycheck-mode-hook #'flycheck-rust-setup))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; misc programming preferences.

;; remove trailing whitespace on lines on save in programming modes.
(add-hook 'prog-mode-hook
(lambda ()
(add-hook 'before-save-hook 'delete-trailing-whitespace nil t)))

;; tabs? spaces.
(setq-default indent-tabs-mode nil)

;; pretty up some indentation levels
(add-hook 'prog-mode-hook 'highlight-indentation-mode)
(setq highlight-indent-guides-method 'column)

;; make parens look nicer, and easier to pair up visually.
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
(setq show-paren-mode t)

;; show line numbers.
(add-hook 'prog-mode-hook 'linum-mode)

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
