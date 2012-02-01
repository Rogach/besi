(provide 'besi)

(defun besi-indent-line ()
  "Indent current line"
  (interactive)
  (scala-indent-line-to (besi-indent)))

(defun besi-indent ()
  (save-excursion
    (forward-comment -100000)
    (backward-char 1)
    (if (or (looking-at "{") (looking-at "=") (looking-at ">") (looking-at "("))
      (+ (current-indentation) 2)
      (current-indentation))))

(defun besi-insert-matching-brace (brace)
  (if (besi-is-char-after brace)
    nil
    (save-excursion
      (newline)
      (insert brace)
      (backward-char 1)
      (scala-indent-line-to (- (besi-indent) 2))
)))

(defun besi-is-char-after (char)
  (save-excursion
    (forward-comment 100000)
    (looking-at char)))

(defun besi-is-char-before (char)
  (save-excursion
    (skip-syntax-backward "-w_.")
    (backward-char 1)
    (looking-at char)))       

(defun besi-newline ()
  (interactive)
  (progn  
    (if (/= (point) 1)
      (if (besi-is-char-before "{")
        (besi-insert-matching-brace "}")
        (if (besi-is-char-before "(")
           (besi-insert-matching-brace ")")
         )))
    (newline-and-indent)))