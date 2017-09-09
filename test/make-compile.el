(setq files '("evil-expat.el"))

;; compile the `files`, bail out on warnings and errors
(setq byte-compile-error-on-warn t)
(setq byte-compile--use-old-handlers nil)
(mapc (lambda (file)
        (unless (byte-compile-file file)
          (kill-emacs 1)))
      files)
