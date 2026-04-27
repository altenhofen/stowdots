;; Make native compilation silent.
(when (native-comp-available-p)
  (setq native-comp-async-report-warnings-errors 'silent))

;; Disable backup
(setq make-backup-files nil)
(setq backup-inhibited nil)
(setq create-lockfiles nil)
(setq custom-file (make-temp-file "emacs-custom-"))

(setq initial-buffer-choice t)
(setq initial-major-mode 'lisp-interaction-mode)
(setq initial-scratch-message
      (format ";; This is `%s'.  Type `%s' to evaluate and print results.\n\n"
              'lisp-interaction-mode
              (propertize
               (substitute-command-keys "\\<lisp-interaction-mode-map>\\[eval-print-last-sexp]")
               'face 'help-key-binding)))
(defmacro prot-emacs-install (package &rest vc-args)
  "Prepare to install PACKAGE.
PACKAGE is an unquoted symbol, referring to the name of the package.  If
VC-ARGS are nil, then install PACKAGE using `package-install'.

If VC-ARGS is non-nil, then check if their `car' is a directory.  If it
is, apply `package-vc-install-from-checkout' on VC-ARGS, else apply
`package-vc-install'.

At all times, do nothing if PACKAGE is already installled."
  (declare (indent 0))
  (unless (symbolp package)
    (error "The package `%s' is not a symbol" package))
  (cond
   ((and package vc-args)
    (let ((fn (if-let* ((first (car vc-args))
                        (_ (and (stringp first) (file-directory-p first))))
                  'package-vc-install-from-checkout
                'package-vc-install)))
      `(unless (package-installed-p ',package)
         (condition-case-unless-debug err
             (apply #',fn ',vc-args)
           (error (message "Failed `%s' with `%S': `%S'" ',fn ',vc-args (cdr err)))))))
   (package
    `(progn
       (unless (package-installed-p ',package)
         (unless package-archive-contents
           (package-refresh-contents))
         (condition-case-unless-debug nil
             (package-install ',package)
           (error (message "Cannot install `%s'; try `M-x package-refresh-contents' first" ',package))))))))

(defvar my-packages
  '(consult
    consult-denote
    denote
    denote-journal
    denote-org
    denote-silo
    denote-sequence
    dired-preview
    doric-themes
    ef-themes
    fontaine
    lin
    mct
    modus-themes
    pulsar
    show-font
    spacious-padding
    standard-themes
    corfu
    marginalia
    orderless
    vertico
    ))

(mapc
 (lambda (pkg)
   (eval `(prot-emacs-install ,pkg)))
 my-packages)

;; fontaine
(setq fontaine-presets
      '((regular
         :default-family "Monaco"
         :default-weight normal
         :default-height 120
         :fixed-pitch-family "Menlo"
         :fixed-pitch-weight nil ; falls back to :default-weight
         :fixed-pitch-height 1.0
         :variable-pitch-family "Tahoma"
         :variable-pitch-weight normal
         :variable-pitch-height 1.0
         :bold-family nil ; use whatever the underlying face has
         :bold-weight bold
         :italic-family "Monaco"
         :italic-slant italic
         :line-spacing 1)
        (large
         :default-family nil
         :default-weight normal
         :default-height 150
         :fixed-pitch-family nil ; falls back to :default-family
         :fixed-pitch-weight nil ; falls back to :default-weight
         :fixed-pitch-height 1.0
         :variable-pitch-family nil
         :variable-pitch-weight normal
         :variable-pitch-height 1.05
         :bold-family nil ; use whatever the underlying face has
         :bold-weight bold
         :italic-family nil ; use whatever the underlying face has
         :italic-slant italic
         :line-spacing 1)))
(fontaine-mode 1)
(fontaine-set-preset 'large)

;; theme
(load-theme 'standard-light t)

;; corfu
(setq corfu-auto t
      corfu-cycle t
      corfu-preview-current nil
      corfu-preselect 'prompt
      corfu-quit-no-match 'separator)

(global-corfu-mode)

;; orderless
(setq completion-styles '(orderless basic)
      completion-category-defaults nil
      completion-category-overrides
      '((file (styles partial-completion))))

;; marginalia
(marginalia-mode 1)

;; vertico
(vertico-mode 1)

;; consult
(global-set-key (kbd "C-s") #'consult-line)
(global-set-key (kbd "M-y") #'consult-yank-pop)
(global-set-key (kbd "C-x b") #'consult-buffer)

;; savehist
(savehist-mode 1)

;; spacious padding
  (setq spacious-padding-widths
        '( :internal-border-width 10
           :header-line-width 4
           :mode-line-width 6
           :custom-button-width 3
           :tab-width 4
           :right-divider-width 25
           :scroll-bar-width 8
           :fringe-width 8))

(spacious-padding-mode 1)

;; variable pitch
(defun prot/enable-variable-pitch ()
  (unless (derived-mode-p 'mhtml-mode 'nxml-mode 'yaml-mode)
    (when (bound-and-true-p modus-themes-mixed-fonts)
      (variable-pitch-mode 1))))

(add-hook 'text-mode-hook  'prot/enable-variable-pitch)
;; switch windows
(defun split-and-follow-horizontally ()
  (interactive)
  (split-window-below)
  (balance-windows)
  (other-window 1))
(global-set-key (kbd "C-x 2") 'split-and-follow-horizontally)

(defun split-and-follow-vertically ()
  (interactive)
  (split-window-right)
  (balance-windows)
  (other-window 1))
(global-set-key (kbd "C-x 3") 'split-and-follow-vertically)

;; hl current line
(global-hl-line-mode 1)

;; save cursor pos
(save-place-mode 1)
