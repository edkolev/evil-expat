[![Build Status](https://travis-ci.org/edkolev/evil-expat.svg?branch=master)](https://travis-ci.org/edkolev/evil-expat)

# evil-expat.el

Add extra evil ex commands, including:

- `:reverse` reverse visually selected lines
- `:remove` remove current file and its buffer
- `:rename` rename current file and its buffer
- `:gblame` git-blame current file, requires `magit`
- `:gremove` git remove current file, requires `magit`
- `:tyank` copy range into tmux paste buffer, requires running under `tmux`
- `:tput` paste from tmux paste buffer, requires running under `tmux`

## Installation

NOTE: this section is invalid, the package ins't on Melpa yet.

#### with [use-package](https://github.com/jwiegley/use-package)
``` emacs-lisp
(use-package evil-expat
  :ensure t
  ;; optional, defer loading until 1 second of inactivity,
  ;; hence not affecting emacs startup time
  :defer 1)
```

#### without [use-package](https://github.com/jwiegley/use-package)

`M-x package-install RET evil-expat RET`, then add in `init.el`:

`(require 'evil-expat)`
