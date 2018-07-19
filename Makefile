update:
	emacs -batch -l test/make-update.el

compile: clean
	emacs -batch -l test/elpa.el -l test/make-compile.el

test:
	emacs -batch -l test/elpa.el -l test/make-test.el

package-lint:
	emacs -batch -l test/elpa.el -f package-lint-batch-and-exit evil-expat.el

clean:
	rm -f *.elc

.PHONY: update compile test clean
