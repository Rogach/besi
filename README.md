BESI
====

BESI - Better Emacs-Scala Indentation

Installation
============

* Add file besi.el to your load path
* Add this line to start of scala-mode.el:
    (require 'besi)
* Edit the line in scala-mode.el
    indent-line-function          'besi-indent-line
* Edit the line in scala-mode-ui.el
    ("\r"                       'besi-newline)
* You're set!