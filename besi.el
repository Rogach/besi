(provide 'besi)

(defun besi-indent-line ()
  "Indent current line"
  (interactive)
  (if (> (point) (line-beginning-position))
    (insert "  ")
    (indent-line-to 
      (if (or 
            (eq last-command 'besi-indent-line)
            (eq last-command 'indent-for-tab-command))
        (+ 2 (current-indentation))
        (besi-indent))))
  (setq last-command 'besi-indent-line)
)

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
    (forward-comment -100000)
    (skip-syntax-backward "-w_.")
    (if (> (point) 1)
      (progn
        (backward-char 1)
        (looking-at char))
      nil)))

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
      (and
        (save-excursion
          (forward-comment -100000)
          (skip-syntax-backward "-w_.")
          (/= (point) 1))
        (if
          (/=
            (line-number-at-pos)
            (save-excursion
              (forward-comment 100000)
              (line-number-at-pos)))
          t
          (save-excursion
            (forward-comment 100000)
            (>= (point)  (buffer-size)))))
      (let (
            (next-indent
             (save-excursion
               (forward-comment 100000)
               (current-indentation)))
            (prev-indent
             (save-excursion
               (forward-comment -100000)
               (current-indentation))))
        (if (< next-indent prev-indent)
          (besi-insert-matching-brace)
          (if (= next-indent prev-indent)
            (besi-insert-matching-brace-and-check)))))
    (progn (insert "\n") (indent-according-to-mode))))

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


