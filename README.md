BESI
====

BESI - Better Emacs-Scala Indentation

With this mode installed, Emacs would indent all lines at the level equal to the previous line, or two spaces to the right, if previous line ended with "{", "=", ">", "(". Also, it would add matching brace, if you press enter after "(", "{" or "{ var_name => ".

Tested on Emacs 23.1.1

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

* Add file besi.el to your load path
* Add this line to your init.el:

    ```(require 'besi)```
  
* You're set!
