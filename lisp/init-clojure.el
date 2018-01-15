;; See also init-clojure-cider.el

(defun my-clojure-refactor-hook ()
  (clj-refactor-mode 1)
  (yas-minor-mode 1) ; for adding require/use/import statements
  ;; This choice of keybinding leaves cider-macroexpand-1 unbound
  (cljr-add-keybindings-with-prefix "C-c C-m"))

(when (maybe-require-package 'clojure-mode)
  (require-package 'clojure-mode-extra-font-locking)
  (require-package 'clj-refactor)
  (require-package 'cljsbuild-mode)
  (require-package 'elein)
  (require-package 'clojure-mode-extra-font-locking)

  (after-load 'clojure-mode
    ;; Enable paredit for Clojure
    (add-hook 'clojure-mode-hook 'enable-paredit-mode)

    ;; This is useful for working with camel-case tokens, like names of
    ;; Java classes (e.g. JavaClassName)
    (add-hook 'clojure-mode-hook 'subword-mode)
    (add-hook 'clojure-mode-hook #'my-clojure-refactor-hook)
    (add-hook 'clojure-mode-hook 'sanityinc/lisp-setup)
    (add-hook 'clojure-mode-hook 'subword-mode)

    ;; clojure style guide: https://github.com/bbatsov/clojure-style-guide
    ;; refer the possible values of clojure-indent-style, :always-align (the default)
    ;; https://github.com/clojure-emacs/clojure-mode
    ;; (setq clojure-indent-style :always-indent)
    (setq clojure-indent-style :always-align)
    (put-clojure-indent 'defui '(1 nil (1)))))


(provide 'init-clojure)
