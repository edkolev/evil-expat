(require 'ert)
(require 'evil)
(require 'evil-expat)
(require 'evil-test-helpers)

(ert-deftest evil-expat-test ()
  (ert-info ("basic")
    (evil-test-buffer
     "[o]ne"
     ("x")
     "ne")))
