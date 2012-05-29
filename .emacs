
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; as of 19.34.6, the default font is courier, I don't like it
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;set-default-font "-b&h-lucidatypewriter-medium-r-normal-sans-12-120-75-75-m-70-iso8859-1")
;if window-system
;   (progn 
;     (set-background-color "AliceBlue")
;     (set-foreground-color "DodgerBlue3")))

(setq load-path
  (append (list nil
		"/usr/local/share/emacs/site-lisp"
		"/usr/local/share/emacs/site-lisp/emacs-goodies-el"
		"/usr/local/share/emacs/site-lisp/bbdb/lisp")
	  load-path))
(require 'juniper)
(require 'goli)
(require 'session)
(require 'emacs-goodies-loaddefs)
(require 'emacs-goodies-el)
(require 'highlight-beyond-fill-column)
(require 'uniquify)
(require 'bbdb)
(require 'midnight)
(require 'ange-ftp)
(require 'python)
(bbdb-initialize 'gnus 'message)

; Common User Access 
(cua-mode t)
(setq cua-enable-cua-keys  nil)

(define-key global-map "\C-z" 'undo)
(eval-after-load "outline" '(require 'foldout))

(add-hook 'term-mode-hook
          (function
           (lambda ()
             (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *")
             (make-local-variable 'mouse-yank-at-point)
             (make-local-variable 'transient-mark-mode)
             (setq mouse-yank-at-point t)
             (setq transient-mark-mode nil)
             (auto-fill-mode -1)
             (setq tab-width 8)
	     (define-key term-raw-map "[6;5~" 'scroll-up)
	     (define-key term-raw-map "[5;5~" 'scroll-down)
	     (define-key term-raw-map "O5E" 'scroll-down)
	     (define-key term-raw-map "O5F" 'scroll-up)
             (define-key term-raw-map "O5A" 'previous-line)
             (define-key term-raw-map "O5B" 'next-line)
             (term-set-escape-char ?\C-x))))


;(if (not window-system)		;; Only use in tty-sessions.
;     (progn
;      (defvar arrow-keys-map (make-sparse-keymap) "Keymap for arrow keys");
;      (define-key esc-map "O" arrow-keys-map)
;      (define-key arrow-keys-map "A" 'previous-line)
;      (define-key arrow-keys-map "B" 'next-line)
;      (define-key arrow-keys-map "C" 'forward-char)
;      (define-key arrow-keys-map "D" 'backward-char)))

;Abbreviations
;(read-abbrev-file "~/.abbrev_defs")

;;*========================
;;* VI-style matching parenthesis
;;  From Eric Hendrickson edh @ med.umn.edu
(setq blink-matching-paren t)
(defun match-paren (arg)
  "Go to the matching parenthesis if on parenthesis otherwise insert %."
  (interactive "p")
  (cond ((looking-at "[([{]") (forward-sexp 1) (backward-char))
        ((looking-at "[])}]") (forward-char) (backward-sexp 1))
        (t (self-insert-command (or arg 1)))))
(global-set-key "%" 'match-paren)


;; I prefer unified context diffs.
(setq diff-switches "-u")

;; todo mode
(global-set-key "\C-ct" 'todo-show) ;; switch to TODO buffer
(setq todo-insert-threshold 8)
(setq todo-time-string-format "%02m/%02d/%:y %02H:%02M")
(setq list-diary-entries-hook
       '(include-other-diary-files sort-diary-entries))
(setq diary-display-hook 'fancy-diary-display)


;; doxygen
(require `doxygen)
(define-key ctl-x-map "c" 'doxygen-insert-function-comment)

;; gid
(require `id-utils)
(autoload `gid "gid" nil t)

;; CSCOPE settings
(require `xcscope)
(define-key global-map [(control f3)]  'cscope-set-initial-directory)
(define-key global-map [(control f4)]  'cscope-unset-initial-directory)
(define-key global-map [(control f5)]  'cscope-find-this-symbol)
(define-key global-map [(control f6)]  'cscope-find-global-definition)
(define-key global-map [(control f7)]  'cscope-find-global-definition-no-prompting)
(define-key global-map [(control f8)]  'cscope-pop-mark)
(define-key global-map [(control f9)]  'cscope-next-symbol)
(define-key global-map [(control f10)] 'cscope-next-file)
(define-key global-map [(control f11)] 'cscope-prev-symbol)
(define-key global-map [(control f12)] 'cscope-prev-file)
(define-key global-map [(meta f9)]  'cscope-display-buffer)
(define-key global-map [(meta f10)] 'cscope-display-buffer-toggle)
(setq cscope-do-not-update-database t)

(setq mouse-sel-retain-highlight t)

; set scroll step to 1 to avoid annoying jumping scroll
(setq scroll-step '1)

; Show equivalent key-binding when M-x command is used.
(setq suggest-key-bindings 3)

; kill the colors for now
; (setq visix-use-hilit19 nil)

; set default mode to text
(setq default-major-mode 'text-mode)

; define useful commands
(define-key ctl-x-map "l" 'goto-line)
(define-key ctl-x-map "?" 'what-line)

; Find Tag - ^t
(define-key global-map "\C-t" 'find-tag-other-window)

(defun toggle-indent-tabs-mode ()
  "Toggle indentaion from tab to spaces"
  (interactive)
  (if (eq indent-tabs-mode nil)
      (setq indent-tabs-mode t)
    (setq indent-tabs-mode nil)))

(defun toggle-tab-width ()
  "Toggle the value of tab-width between 4 and 8"
  (interactive)
  (if (= tab-width 8)
      (setq tab-width 4)
    (if (= tab-width 4)
        (setq tab-width 8)))
  (scroll-up 0))

(defun toggle-c-offset ()
  "Toggle the value of c-basic-offset between 4 and 8"
  (interactive)
  (if (= c-basic-offset 8)
      (setq c-basic-offset 4)
    (if (= c-basic-offset 4)
        (setq c-basic-offset 8)))
  (scroll-up 0))

(defun insert-current-date ()
  "Insert the current date and time at the current point"
  (interactive)
  (let* ((date (current-time-string))
         (foo (string-match 
             (concat 
              "\\([A-Z][a-z][a-z]\\) *"
              "\\([A-Z][a-z][a-z]\\) *"
              "\\([0-9]*\\) *"
              "\\([0-9:]*\\) *"
              "\\([0-9]*\\)$")
             date))
       (weekday (substring date (match-beginning 1) (match-end 1)))
       (day (substring date (match-beginning 3) (match-end 3)))
       (time (substring date (match-beginning 4) (match-end 4)))
       (month
        (cdr (assoc
              (substring date (match-beginning 2) (match-end 2))
              '(("Jan" . "1") ("Feb" . "2")  ("Mar" . "3")  ("Apr" . "4")
                ("May" . "5") ("Jun" . "6")  ("Jul" . "7")  ("Aug" . "8")
                ("Sep" . "9") ("Oct" . "10") ("Nov" . "11") ("Dec" . "12")))))
       (year (substring date (match-beginning 5) (match-end 5))))
  (insert (concat weekday " " month "/" day ", " time))))

(global-set-key "\M-\C-b" 'vbackward-word)
(defun vbackward-word ()
  "Move point backward one word or to the first capital letter going backwards."
  (interactive)
  (setq case-fold-search nil)
  (backward-char)
  (re-search-backward "\\(\\W\\w\\|\\W[A-Z]\\|[a-z][A-Z]\\)")
  (forward-char)
  (setq case-fold-search t))

(global-set-key "\M-\C-f" 'vforward-word)
(defun vforward-word ()
  "Move point forward one word or to the next capital letter."
  (interactive)
  (setq case-fold-search nil)
  (forward-char)
  (re-search-forward "\\(\\w\\W\\|[a-z][A-Z]\\|w[A-Z]+\\)")
  (backward-char)
  (setq case-fold-search t))

(global-set-key "\M-\C-d" 'vkill-word)
(defun vkill-word ()
  "Kill characters forward until encountering the end of a word or a capital letter."
  (interactive)
  (kill-region (point) (progn (vforward-word) (point))))

; (global-set-key "\M-\C-Å" 'vkill-word-backward)
(defun vkill-word-backward ()
  "Kill characters backwardward until encountering the end of a word or a capital letter."
  (interactive)
  (kill-region (point) (progn (vbackward-word) (point))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; My keymappings for new version of emacs
;
;	The new version of emacs interprets function keys
;	directly
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Info		- Help
;(define-key global-map [help] 'info)

; Quit	 	- Stop
;(define-key global-map [f11] "\C-g")

; Repeat	- Again
;(define-key global-map [f12] 'repeat-complex-command)

; Undo		- Undo
;(define-key global-map [f14] 'advertised-undo)

; Set Mark	- Props
;(define-key global-map [f13] 'set-mark-command)

; Kill ring save- Copy
;(define-key global-map [f16] 'kill-ring-save)

; Kill Region	- Cut
;(define-key global-map [f20] 'kill-region)

; Yank		- Paste
;(define-key global-map [f18] 'yank)

; Forward Search- Find
;(define-key global-map [f19] 'isearch-forward)
;(define-key isearch-mode-map [f19] 'isearch-repeat-forward)

; Page Up	- PgUp
;(define-key global-map [f29] 'scroll-down)

; Page Down	- PgDn
;(define-key global-map [f35] 'scroll-up)

; Top		- Home
;(define-key global-map [f27] 'beginning-of-buffer)

; Bottom	- End
;(define-key global-map [f33] 'end-of-buffer)

; Find-file	- F1
(define-key global-map [f1] 'find-file)
(define-key global-map [kp-f1] 'find-file)

; Create window	- F2
; (define-key global-map [f2] 'split-window-vertically)
; (define-key global-map [kp-f2] 'split-window-vertically)
(define-key global-map [f2] 'toggle-c-offset)
(define-key global-map [kp-f2] 'toggle-c-offset)

; One window	- F3
(define-key global-map [f3] 'compile)
(define-key global-map [kp-f3] 'compile)

; Other window	- F4
;(define-key global-map [f4] 'toggle-tab-width)

; Other window	- F4
(define-key global-map [f4] 'next-error)
(define-key global-map [kp-f4] 'next-error)

(defun paul-compile ()
  (interactive)
  (cd "d:/user/paul/src/iCC/Shared")
  (compile "nmake solipsadep")
  (cd "d:/user/paul/src/iCC/Shared/solipsa/telephony/externalmanager"))

; Buffer menu	- F5
; (define-key global-map [f5] 'paul-compile)

; Buffer menu	- F5
;(define-key global-map [f5] 'list-buffers)
;(define-key global-map [f18] 'list-buffers)
(define-key global-map [f5] 'call-last-kbd-macro)
(define-key global-map [f18] 'call-last-kbd-macro)

; Revert Buffer - F6 (like undo all edits)
(define-key global-map [f6] 'revert-buffer)

; Kill Buffer	- F7
(define-key global-map [f7] 'kill-buffer)

; Select Buffer - F8 (creates new buffer)
(define-key global-map [f8] 'switch-to-buffer)

; Save Buffer	- F9
(define-key global-map [f9] 'save-buffer)

; Save As New	- F10
(define-key global-map [f10] 'tmm-menubar)

; Tag Search    - F11
(define-key global-map [f11] 'tags-search)

; Continue Tag Search    - F12
(define-key global-map [f12] 'toggle-tab-width)
;(define-key global-map [f12] 'tags-loop-continue)

; Go to top
(define-key global-map [f19] 'beginning-of-buffer)

; Go to bottom
(define-key global-map [f20] 'end-of-buffer)

; Describe Key	- Print Screen
(define-key global-map [f22] 'describe-key)


; Set Global Key- Scroll Lock
(define-key global-map [f23] 'global-set-key)

; Set Local Key - Pause
(define-key global-map [f21] 'local-set-key)

(put 'upcase-region 'disabled nil)

(put 'downcase-region 'disabled nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Stuff specific to C programming
; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(load "cc-mode")
(load "paren")
(defun start-c-mode ()
  (c-set-offset 'label 0)
  (c-set-offset 'substatement-open  0)
  (c-set-offset 'case-label '+)
  (c-set-offset 'statement 0)
  (c-set-offset 'statement-case-intro  0)
  (c-set-offset 'statement-case-open 0)
  (c-set-offset 'arglist-intro '+)
  (c-set-offset 'arglist-close 'c-lineup-arglist)
  (setq c-basic-offset 4)
  (setq tab-width 8)
)

(setq c-indent-val 4)



(defun KR-c-mode ()
  "Set up C mode for K&R (actually UNIX kernel) style"
  (interactive)
  (setq c-mode-hook 'KR-c-mode)

  (setq c-argdecl-indent c-indent-val)
  (setq c-basic-offset c-indent-val)    ; new in 19.34 cc-mode.
  (setq c-auto-newline nil)
  (setq c-auto-newline nil)
  (setq comment-column 40)
  (setq c-comment-starting-blank nil)
  (setq c-comment-ending-blank nil)
  (setq c-electric-crunch t)
  (setq c-brace-imaginary-offset 0)
  (setq comment-multi-line t)
  (setq c-brace-offset (- c-indent-val))
  (setq c-continued-statement-offset c-indent-val)
  (setq c-indent-level c-indent-val)
  (setq c-label-offset (- c-indent-val))
  (define-key c-mode-map "\r" 'newline-and-indent)
  (define-key c-mode-map "\C-ct" 'set-c-tabs)
  )

(setq orig-c-style-alist c-style-alist
      juniper-c-indent-val 4)
(c-add-style "juniper"
             '(
               (c-basic-offset . 4)
               (c-comment-only-line-offset . 0)
               (fill-column . 80)
               (c-offsets-alist
                . (
                   ;; first line of a new statement block
                   (statement-block-intro . +)
		   
                   ;; First line of a K&R C argument declaration.
                   (knr-argdecl-intro . 4)
		   
                   ;; The brace that opens a substatement block.
                   (substatement-open . 0)
		   
                   ;; Any non-special C label.
                   (label . 2)

                   ;; A `case' or `default' label.
                   (case-label . 0)

                   ;; The first line in a case block that starts with
                   ;; a brace.
                   (statement-case-open . +)

                   ;; A continuation of a statement.
                   (statement-cont . +)

                   ;; The first line after a conditional or loop
                   ;; construct.
                   (substatement . 4)

                   ;; The first line in an argument list.
                   (arglist-intro . c-lineup-arglist-intro-after-paren)

                   ;; The solo close paren of an argument list.
                   (arglist-close . c-lineup-arglist)

                   ;; Brace that opens an in-class inline method.
                   (inline-open . 0)

                   ;; Open brace of an enum or static array list.
                   (brace-list-open . 0)))

               (c-special-indent-hook . c-gnu-impose-minimum)
               (c-block-comment-prefix . "")))

(defun juniper-c-default-style ()
  "Set the default c-style for Juniper."
  (interactive)
  (define-key c-mode-map "\r" 'newline-and-indent)
  (c-set-style "juniper"))

;(add-hook 'c-mode 'juniper-c-default-style)
;(setq c-mode-hook 'KR-c-mode)
(add-hook 'c-mode-hook 'juniper-c-default-style)
(add-hook 'c++-mode-hook  'start-c-mode)

(add-hook 'outline-mode-hook 
   '(lambda ()
      (turn-on-auto-fill)))

(if (getenv "SB")
    (setq bookmark-default-file (concat (getenv "SB") "/emacs.bmk")))

;;;
;;; Use C mode to edit ddl and odl files
;;;
(setq-default py-indent-offset 4)

(setq auto-mode-alist
      (append '(("\\.odl$"    . c-mode)
                ("\\.ddl$"   . c-mode)
                ("\\.idl$"   . c-mode)
                ("\\.errmsg$"   . c-mode)
                ("\\.diff$" . text-mode)
                ("\\.org$" . org-mode)
                ("\\.py$" . python-mode)
                ) auto-mode-alist))


(defun py-mode () "\
Hack up a major mode triggered by the \".py\" suffix on a file,
used to change the tab-width locally to be 4 instead of 8."
  (interactive)
  (fundamental-mode)
  (setq major-mode 'python-mode)
  (setq mode-name "Python")
  (make-local-variable 'tab-width)
  (setq tab-width 8)
  (run-hooks 'py-mode-hook)
  )
  
;;;(setq auto-mode-alist (nconc '(("\\.py$" . py-mode)) auto-mode-alist))

(provide 'xml-mode)

(defun xml-mode () "\
Hack up a major mode triggered by the \".xml\" suffix on a file,
used to change the tab-width locally to be 4 instead of 8."
  (interactive)
  (fundamental-mode)
  (setq major-mode 'xml-mode)
  (setq mode-name "Xml-Paul")
  (make-local-variable 'tab-width)
  (setq tab-width 8)
  (run-hooks 'xml-mode-hook)
  )

  
(setq auto-mode-alist (nconc '(("\\.xml$" . xml-mode)) auto-mode-alist))

(provide 'xml-mode)

(put 'eval-expression 'disabled nil)


(provide 'site-fonts-x11)

; LDAP
(setq message-expand-name-databases '(eudc))
(require 'eudc nil t)
(setq ldap-host-parameters-alist 
	'(("ldap.juniper.net" base "DC=jnpr,DC=net" auth nil scope subtree))
      eudc-query-form-attributes '(uid name firstname email)
      eudc-inline-query-format '((uid) (name) (mail))
      eudc-inline-expansion-format '("%s <%s>"  cn mail))
(eudc-set-server "ldap.juniper.net" 'ldap t)

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(abbrev-mode t)
 '(ange-ftp-default-user "goli")
 '(bookmark-save-flag 1)
 '(clean-buffer-list-delay-general 1)
 '(clean-buffer-list-kill-never-buffer-names (quote ("*scratch*" "*Messages*" "*Group*")))
 '(cua-rectangle-mark-key [134217760])
 '(global-cwarn-mode t nil (cwarn))
 '(global-font-lock-mode t nil (font-lock))
 '(gud-gdb-command-name "gdb --annotate=1")
 '(highlight-beyond-fill-column-in-modes (quote ("c-mode" "text-mode")))
 '(inhibit-splash-screen t)
 '(iswitchb-mode t nil (iswitchb))
 '(large-file-warning-threshold nil)
 '(lpr-command "lpr")
 '(make-backup-files nil)
 '(midnight-mode t nil (midnight))
 '(org-hide-leading-stars t)
 '(printer-name "locust")
 '(rfcview-use-view-mode-p t)
 '(save-abbrevs (quote silently))
 '(show-trailing-whitespace nil)
 '(tool-bar-mode nil nil (tool-bar))
 '(tooltip-gud-tips-p t)
 '(which-function-mode t nil (which-func)))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(font-lock-comment-face ((((class color) (min-colors 8) (background light)) nil)))
 '(font-lock-keyword-face ((((type tty) (class color)) (:foreground "magenta"))))
 '(font-lock-variable-name-face ((((class color) (min-colors 8)) (:foreground "cyan" :weight light))))
 '(org-level-2 ((t (:foreground "blue"))))
 '(rfcview-headlink-face ((t (:foreground "purple"))))
 '(rfcview-headname-face ((t (:foreground "red" :underline t :weight bold))))
 '(trailing-whitespace ((((class color) (background light)) (:background "grey")))))
;;(require 'notes-variables)
