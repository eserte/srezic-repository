srezic-repository

This repository contains small snippets, typically only in the size of
one function, for a number of programming languages (perl, c,
emacs-lisp, sh ...).

Just copy'n' paste the snippets into your scripts and programs.

There's a convenience function for emacs to do the copy job from a
completion-capable list of available functions. Add the following to
your ~/.emacs:

    (setq repository-directory "/path/to/srezic-repository")
    (define-key global-map [C-f10] 'repository-insert)
    (autoload 'repository-insert "repository" "Source repository" t)

(Or use another key than Control-F10)
