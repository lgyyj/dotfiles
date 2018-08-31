;;; init-maps.el -- Provide global key maps

;;; Commentary:
;;; Provide global maps that aren't specific to any mode or package.

;;; Code:
(define-key global-map (kbd "C-x C-q") 'kill-emacs)
(define-key global-map (kbd "C-c u")   'insert-char) ;; "u" for Unicode, get it?
(define-key global-map (kbd "C-c s")   (lambda () (interactive) (ansi-term "zsh")))
(define-key global-map (kbd "s-e")     'eval-buffer)

(global-set-key (kbd "C-x 2") 'vsplit-last-buffer)
(global-set-key (kbd "C-x 3") 'hsplit-last-buffer)

(global-set-key [M-left] 'shrink-window-horizontally)
(global-set-key [M-right] 'enlarge-window-horizontally)
(global-set-key [M-up] 'shrink-window)
(global-set-key [M-down] 'enlarge-window)

;; 动态调整字体大小:
;; C-x C-+
;; C-x C--
(global-set-key (kbd "C-c <left>")  'windmove-left)
(global-set-key (kbd "C-c <right>") 'windmove-right)
(global-set-key (kbd "C-c <up>")    'windmove-up)
(global-set-key (kbd "C-c <down>")  'windmove-down)

(global-set-key (kbd "M-,") 'godef-jump)
(global-set-key (kbd "M-'") 'pop-tag-mark)

(global-set-key (kbd "M-]") 'dumb-jump-go)
(global-set-key (kbd "M-t") 'dumb-jump-back)

(global-set-key (kbd "M-p") 'hold-line-scroll-up )
(global-set-key (kbd "M-n") 'hold-line-scroll-down )

(global-set-key (kbd "C-!") 'eshell-here)
(global-set-key (kbd "C-#") 'eshell-x)

(defun gds/cleanup ()
  "Diminish all the clutter in my modeline."
  (interactive)
  (size-indication-mode 0)
  (setq display-time-mail-file t)
  (setq display-time-load-average-threshold 4.0)
  (diminish 'yas-minor-mode)
  (diminish 'paredit-mode)
  (diminish 'projectile-mode)
  (diminish 'whitespace-mode)
  (diminish 'eldoc-mode)
  (diminish 'volatile-highlights-mode)
  (diminish 'flyspell-mode)
  (diminish 'git-gutter-mode)
  ;; (diminish 'auto-complete-mode)
  (diminish 'abbrev-mode)
  (diminish 'orgstruct-mode)
  (diminish 'auto-fill-function)
  ;; (diminish 'ruby-block-mode)
  (diminish 'skewer-mode)
  (diminish 'which-key-mode)
  (diminish 'undo-tree-mode))
(gds/cleanup)

(provide 'init-maps)
;;; init-maps.el ends here
