; calculates square root using Newton's method of approximation
; number of iterations is controlled by {@code ratio}
;
; @param ratio ratio between previous and current guess below which computation should stop
(define (sqrt x)
  (sqrt-iter 1.0 0.00000001 x)
)

(define (sqrt-iter guess ratio x)
  (if (good-enough? guess ratio x)
    guess
    (sqrt-iter (improve guess x) ratio x)
  )
)

; declares guess a good enough if
;
;   |1 - (guess * guess) / x| < ratio
;
(define (good-enough? guess ratio x)
  (<
    (abs
      (-
        1
        (/
          (square guess)
          x
        )
      )
    )
    ratio
  )
)

(define (improve guess x)
  (average guess (/ x guess))
)

(define (average x y)
  (/
    (+ x y)
    2
  )
)

(define (square x)
  (* x x)
)

(write (sqrt 9e306) (current-output-port))
(newline (current-output-port))
