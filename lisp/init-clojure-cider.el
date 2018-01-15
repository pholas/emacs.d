(require 'init-clojure)

(defun cider-figwheel-repl ()
  (interactive)
  (save-some-buffers)
  (with-current-buffer (cider-current-repl-buffer)
    (goto-char (point-max))
    (insert "(require 'figwheel-sidecar.repl-api)
             (figwheel-sidecar.repl-api/start-figwheel!) ; idempotent
             (figwheel-sidecar.repl-api/cljs-repl)")
    (cider-repl-return)))

(defun user/cider-send-to-repl ()
  (interactive)
  (let ((s (buffer-substring-no-properties
            (nth 0 (cider-last-sexp 'bounds))
            (nth 1 (cider-last-sexp 'bounds)))))
    (with-current-buffer (cider-current-connection)
      (insert s)
      (cider-repl-return))))

(defun cider-start-http-server ()
  (interactive)
  (cider-load-current-buffer)
  (let ((ns (cider-current-ns)))
    (cider-repl-set-ns ns)
    (cider-interactive-eval (format "(println '(def server (%s/start))) (println 'server)" ns))
    (cider-interactive-eval (format "(def server (%s/start)) (println server)" ns))))

(defun cider-refresh ()
  (interactive)
  (cider-interactive-eval (format "(user/reset)")))

(defun cider-user-ns ()
  (interactive)
  (cider-repl-set-ns "user"))

(when (maybe-require-package 'cider)
  (setq nrepl-popup-stacktraces nil)


  ;; go right to the REPL buffer when it's finished connecting
  (setq cider-repl-pop-to-buffer-on-connect t)

  ;; When there's a cider error, show its buffer and switch to it
  (setq cider-show-error-buffer t)
  (setq cider-auto-select-error-buffer t)

  ;; Where to store the cider history.
  (setq cider-repl-history-file "~/.emacs.d/cider-history")

  ;; Wrap when navigating history.
  (setq cider-repl-wrap-history t)

  (setq cider-default-cljs-repl-type "figwheel")

  ;; In Emacs, just put your cursor in a .clj or .cljs buffer that is part of the project you are configuring.
  ;; Once there, type M-x cider-jack-in-clojurescript [RET]

  ;; If this all succeeds, you will see a Clojure REPL in an Emacs buffer and another Figwheel REPL side-by-side.
  (setq cider-cljs-lein-repl
        "(do (require 'figwheel-sidecar.repl-api)
           (figwheel-sidecar.repl-api/start-figwheel!)
           (figwheel-sidecar.repl-api/cljs-repl))")

  ;; Use clojure mode for other extensions
  (add-to-list 'auto-mode-alist '("\\.edn$" . clojure-mode))
  (add-to-list 'auto-mode-alist '("\\.boot$" . clojure-mode))
  (add-to-list 'auto-mode-alist '("\\.cljs.*$" . clojurescript-mode))
  (add-to-list 'auto-mode-alist '("lein-env" . enh-ruby-mode))

  (after-load 'cider
    (add-hook 'cider-mode-hook 'turn-on-eldoc-mode)
    (add-hook 'cider-mode-hook 'eldoc-mode)
    (add-hook 'cider-mode-hook #'company-mode)
    (add-hook 'cider-repl-mode-hook 'eldoc-mode)
    (add-hook 'cider-repl-mode-hook 'subword-mode)
    (add-hook 'cider-repl-mode-hook 'paredit-mode)
    (add-hook 'cider-repl-mode-hook #'company-mode)

    ;; nrepl isn't based on comint
    (add-hook 'cider-repl-mode-hook 'sanityinc/no-trailing-whitespace))
  (eval-after-load 'cider
    '(progn
       (define-key clojure-mode-map (kbd "C-c C-v") 'cider-start-http-server)
       (define-key clojure-mode-map (kbd "C-M-r") 'cider-refresh)
       (define-key clojure-mode-map (kbd "C-c u") 'cider-user-ns)
       (define-key cider-mode-map (kbd "C-c u") 'cider-user-ns)))
  (global-set-key (kbd "C-c C-f") #'cider-figwheel-repl)
  (require-package 'flycheck-clojure)
  (after-load 'clojure-mode
    (after-load 'cider
      (after-load 'flycheck
        (flycheck-clojure-setup)))))



(provide 'init-clojure-cider)
