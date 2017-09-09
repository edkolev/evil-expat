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
       (should (not (file-exists-p "temp-file"))))))
