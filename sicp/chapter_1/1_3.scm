; Calculates sum of squares of two biggest numbers among a, b and c
(define (exercise a b c)
  (define d (min a b c))
  (+
    (* a a)
    (* b b)
    (* c c)
    (- (* d d) )
  )
)

(write (exercise 9 1 2) (current-output-port))
(newline (current-output-port))