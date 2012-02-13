(provide 'besi)

(defun besi-indent-line ()
  "Indent current line"
  (interactive)
  (indent-line-to 
    (if (eq last-command this-command)
      (+ 2 (current-indentation))
      (besi-indent))))

(defun besi-indent ()
  (save-excursion
    (forward-comment -100000)
    (backward-char 1)
    (if (or 
          (looking-at "{")
          (looking-at "=") 
          (save-excursion
            (if (looking-at ">")
               (progn
                 (backward-char 1)
                 (if (looking-at "=")
                   1
                   (if (looking-at "/") nil 
                     (progn 
                       (back-to-indentation)
                       (if (looking-at "</")
                          nil 1))
                     )))
               nil))
          (looking-at "("))
      (+ (current-indentation) 2)
      (current-indentation))))

(defun besi-insert-brace (brace)
    (save-excursion
      (newline)
      (insert brace)
      (backward-char 1)
      (indent-line-to (- (besi-indent) 2))))

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

(defun besi-insert-match (pre aft)
  (progn
    (insert pre)
    (insert aft)
    (backward-char 1)))


(add-hook 'scala-mode-hook
  (lambda () 
    (progn
      (setq indent-line-function 'besi-indent-line)
      (local-set-key (kbd "RET") 'besi-newline)
      (local-set-key (kbd "\"") 
        (lambda () (interactive) 
          (insert-match "\"" "\"")))
      (local-set-key (kbd "'") 
        (lambda () (interactive) 
          (insert-match "'" "'"))))))


