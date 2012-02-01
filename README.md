BESI
====

BESI - Better Emacs-Scala Indentation

With this mode installed, Emacs would indent all lines at the level, equal to the previous line, or two spaces to the right, if previous line ended with "{", "=", ">", "(". Also, it would add matching brace, if you press enter after "(", "{" or "{ var_name => ".

Example of indentation:

    List (
      1,
      2,
      3
    ).map { i =>
      i + 2
    }

Installation
============

* Make sure you have scala-mode installed.
* Add file besi.el to your load path
* Add this line to start of scala-mode.el:

    ```(require 'besi)```
  
* Edit the line in scala-mode.el

    ```indent-line-function          'besi-indent-line```
  
* Edit the line in scala-mode-ui.el

    ```("\r"                       'besi-newline)```
  
* You're set!
