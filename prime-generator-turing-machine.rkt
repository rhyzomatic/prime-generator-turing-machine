(define (top wd)
  (if (equal? (last wd) '^)
      (butlast wd)
      (top (butlast wd))))

(define (tail wd)
  (if (equal? (first wd) '^)
      (butfirst wd)
      (tail (butfirst wd))))

(define (left wd)
  (if (equal? (first wd) '^) wd
    (word (butlast (top wd)) '^ (last (top wd)) (tail wd))))

(define (right wd)
  (if (equal? (last wd) '^) wd
    (word (top wd) (first (tail wd)) '^ (butfirst (tail wd)))))

(define (print wd sym)
  (word (top wd) '^ sym (bf (tail wd))))

(define (read wd)
  (if (equal? (first wd) '^)
        (first (bf wd))
        (read (bf wd))))
                                 
(define (word-length wd)
  (if (empty? wd) 0
      (+ 1 (word-length (butfirst wd)))))

(define (prime-step machine)
  (let ((tape (first machine)) (state (last machine)))
    (if (< 2 (word-length (tail tape))) (prime-step
        (cond [(equal? state 'a) (cond [(equal? (read tape) 's) (se (print tape 't) 'b)]
                                       [(equal? (read tape) 'p) (se tape 'c)]
                                       [else (se (left tape) 'a)])]
              [(equal? state 'b) (cond [(equal? (read tape) 'q) (se (print tape 'x) 'a)]
                                       [(equal? (read tape) '0) (se (left tape) 'd)]
                                       [else (se (right tape) 'b)])]
              [(equal? state 'c) (cond [(equal? (read tape) 't) (se (right (print tape 's)) 'c)]
                                       [(equal? (read tape) 'q) (se tape 'a)]
                                       [(equal? (read tape) '0) (se (left (print tape 'q)) 'e)]
                                       [else (se (right tape) 'c)])]
              [(equal? state 'd) (cond [(equal? (read tape) 'x) (se (left (print tape 'q)) 'd)]
                                       [(member? (read tape) '(t s)) (se (left (print tape 1)) 'd)]
                                       [(equal? (read tape) 'p) (se (left (print tape 'w)) 'd)]
                                       [(equal? (read tape) '0) (se (print tape 'p) 'f)]
                                       [(equal? (read tape) 'S) (se tape 'h)]
                                       [else (se (left tape) 'd)])]
              [(equal? state 'e) (cond [(equal? (read tape) 'x) (se (left (print tape 'q)) 'e)]
                                       [(equal? (read tape) 's) (se (left (print tape '1)) 'e)]
                                       [(equal? (read tape) 'w) (se (left (print tape '0)) 'e)]
                                       [(equal? (read tape) 'p) (se (print tape '0) 'g)]
                                       [else (se (left tape) 'e)])]
              [(equal? state 'f) (cond [(equal? (read tape) 'w) (se tape 'a)]
                                       [(equal? (read tape) '1) (se (right (print tape 's)) 'f)]
                                       [else (se (right tape) 'f)])]
              [(equal? state 'g) (cond [(equal? (read tape) 'q) (se (left (print (left tape) 'w)) 'j)]
                                       [else (se (right tape) 'g)])]
              [(equal? state 'h) (cond [(equal? (read tape) 'w) (se (right (print tape '0)) 'h)]
                                       [(equal? (read tape) 'q) (se (right (print tape '1)) 'h)]
                                       [(equal? (read tape) '0) (se (left (print tape 'w)) 'i)]
                                       [else (se (right tape) 'h)])]
              [(equal? state 'i) (cond [(equal? (read tape) '0) (se (print tape 'p) 'k)]
                                       [else (se (left tape) 'i)])]
              [(equal? state 'j) (cond [(equal? (read tape) '0) (se (print tape 'p) 'f)]
                                       [else (se (left tape) 'j)])]
              [(equal? state 'k) (cond [(equal? (read tape) '0) (se (print tape 'q) 'm)]
                                       [else (se (right tape) 'k)])]
              [(equal? state 'm) (cond [(equal? (read tape) '1) (se (print tape 's) 'n)]
                                       [(equal? (read tape) 'p) (se tape 'f)]
                                       [else (se (left tape) 'm)])]
              [(equal? state 'n) (cond [(equal? (read tape) '0) (se (print tape 'q) 'm)]
                                       [else (se (right tape) 'n)])]
              [(equal? state 'begin) (se (print (right (print (right (print (right (right (print (right (print tape 'S)) '1))) '1)) '1)) 'w) 'i)]))
        machine)))

(define (prime-gen n)
  (prime-step (se (word '^ ((repeated (lambda (x) (word x "0")) n) "")) 'begin)))
