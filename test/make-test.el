(let* ((project-tests-file "tests.el")
       (current-directory (file-name-directory load-file-name))
       (project-test-path (expand-file-name "." current-directory))
       (project-root-path (expand-file-name ".." current-directory)))

  (add-to-list 'load-path project-root-path)
  (add-to-list 'load-path project-test-path)

  (load (expand-file-name project-tests-file project-test-path) nil t)

  (ert-run-tests-batch-and-exit))
