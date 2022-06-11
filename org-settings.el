;; GTD org agenda stuff.
;; credit where due:
;; https://emacs.cafe/emacs/orgmode/gtd/2017/06/30/orgmode-gtd.html
;; (setq org-agenda-files '("~/s/gtd/inbox.org"
;;                          "~/s/gtd/gtd.org"
;;                          "~/s/gtd/tickler.org"))

;; (setq org-capture-templates '(("t" "Todo [inbox]" entry
;;                                (file+headline "~/s/gtd/inbox.org" "Tasks")
;;                                "* TODO %i%?")
;;                               ("T" "Tickler" entry
;;                                (file+headline "~/s/gtd/tickler.org" "Tickler")
;;                                "* %i%? \n %U")))

;; ;; what is (max)level doing here?
;; (setq org-refile-targets '(("~/s/gtd/gtd.org" :maxlevel . 3)
;;                            ("~/s/gtd/someday.org" :level .1)
;;                            ("~/s/gtd/tickler.org" :maxlevel .2)))

(setq org-todo-keywords
   (quote
    ((sequence "TODO" "INWK" "HOLD" "NEXT"
               "|" "✘CAN" "✔DONE"))))

(setq org-agenda-custom-commands
      '(("o" "At the office" tags-todo "@office"
         ((org-agenda-overriding-header "Office")
          (org-agenda-skip-function #'my-org-agenda-skip-all-siblings-but-first)))))

(defun my-org-agenda-skip-all-siblings-but-first ()
  "Skip all but the first non-done entry."
  (let (should-skip-entry)
    (unless (org-current-is-todo)
      (setq should-skip-entry t))
    (save-excursion
      (while (and (not should-skip-entry) (org-goto-sibling t))
        (when (org-current-is-todo)
          (setq should-skip-entry t))))
    (when should-skip-entry
      (or (outline-next-heading)
          (goto-char (point-max))))))

(defun org-current-is-todo ()
  (string= "TODO" (org-get-todo-state)))

;; i want to store the timestamp of when items are completed
(setq org-log-done 'time)

;; hide special chars such as / in /italics/ and * in *bold*
(setq org-hide-emphasis-markers t)

;; TODO: add hooks for org-agenda-list to update
;; particularly window-configuration-change-hook


;; updates org-agenda every 5 minutes
;; (run-with-timer 0 300 (lambda () (org-agenda nil "a")) )
