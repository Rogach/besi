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

(defun besi-newline ()
  (interactive)
  (newline-and-indent))
