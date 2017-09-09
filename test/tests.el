(require 'ert)
(require 'evil)
(require 'evil-expat)
(require 'evil-test-helpers)

(ert-deftest evil-expat-test ()
  (ert-info (":rev")
    (evil-test-buffer
     "<one\nt>wo\nthree"
     (":rev")
     "two\none\nthree")))
