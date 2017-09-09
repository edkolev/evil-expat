(require 'ert)
(require 'evil)
(require 'evil-expat)
(require 'evil-test-helpers)

(ert-deftest evil-expat-test ()
  (ert-info (":rev")
    (evil-test-buffer
     "<one\nt>wo\nthree"
     (":rev")
     "two\none\nthree"))
  (ert-info (":remove")
    (let ((temp-file (concat "/tmp/evil-expat-test-remove" (number-to-string (random)) ".txt")))
      (evil-test-buffer
       (find-file temp-file)
       (":w")
       (should (file-exists-p temp-file))
       (":remove")
       (should (not (file-exists-p temp-file))))))
  (ert-info (":rename")
    (let ((temp-file1 (concat "/tmp/evil-expat-test-rename-1-" (number-to-string (random)) ".txt"))
          (temp-file2 (concat "/tmp/evil-expat-test-rename-2-" (number-to-string (random)) ".txt")))
      (evil-test-buffer
       (find-file temp-file1)
       (":w")
       (should (file-exists-p temp-file1))
       ((vconcat ":rename " temp-file2 [return]))
       (should (not (file-exists-p temp-file1)))
       (should (file-exists-p temp-file2))))))
