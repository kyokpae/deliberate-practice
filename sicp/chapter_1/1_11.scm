; f(n) = g(n) = f(n-1) + 2f(n-2) + 3f(n-3)

; recursive version
(define (f n)
  (cond
    ((= n 2) 2)
    ((= n 1) 1)
    ((= n 0) 0)
    (else
      (+
        (f (- n 1))
        (* (f (- n 2)) 2)
        (* (f (- n 3)) 3)
      )
    )
  )
)

; iterative version
(define (g n)
  (define (g-iter a b c n)
    (if (= n 0)
      c
      (g-iter
        (+ a (* b 2) (* c 3))
        a
        b
        (- n 1)
      )
    )
  )
  (g-iter 2 1 0 n)
)

(write (list "iterative " (g 25)) (current-output-port))
(newline (current-output-port))
(write (list "recursive " (f 25)) (current-output-port))
(newline (current-output-port))
