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

(defun besi-insert-brace (brace)
    (save-excursion
      (newline)
      (insert brace)
      (backward-char 1)
      (scala-indent-line-to (- (besi-indent) 2))))

(defun besi-is-char-after (char)
  (save-excursion
    (forward-comment 100000)
    (looking-at char)))

(defun besi-is-char-before (char)
  (save-excursion
    (skip-syntax-backward "-w_.")
    (backward-char 1)
    (looking-at char)))       

(defun besi-insert-matching-brace ()
  (if (besi-is-char-before "{")
    (besi-insert-brace "}")
    (if (besi-is-char-before "(")
       (besi-insert-brace ")")
     )))

(defun besi-insert-matching-brace-and-check ()
  (if (besi-is-char-before "{")
    (if (besi-is-char-after "}") nil
      (besi-insert-brace "}"))
    (if (besi-is-char-before "(")
      (if (besi-is-char-after ")") nil
        (besi-insert-brace ")")))))
    

(defun besi-newline ()
  (interactive)
  (progn  
    (if 
      (save-excursion
        (skip-syntax-backward "-w_.")
        (/= (point) 1))
      (if 
        (>= 
          (current-indentation)
          (save-excursion
            (forward-comment 100000)
            (current-indentation)))
        (if 
          (= 
            (current-indentation)
            (save-excursion
              (forward-comment 100000)
              (current-indentation)))
          (besi-insert-matching-brace-and-check)
          (besi-insert-matching-brace)
             )))
    (newline-and-indent)))