; calculates cube root using Newton's method of approximation
; number of iterations is controlled by {@code ratio}
;
; only difference between 1_7.scm and this one is definition of improve and good-enough?
;
; @param ratio ratio between previous and current guess below which computation should stop
(define (cbrt x)
  (cbrt-iter 1.0 0.00000001 x)
)

(define (cbrt-iter guess ratio x)
  (if (good-enough? guess ratio x)
    guess
    (cbrt-iter (improve guess x) ratio x)
  )
)

; declares guess a good enough if
;
;   |1 - (guess * guess * guess) / x| < ratio
;
(define (good-enough? guess ratio x)
  (<
    (abs
      (-
        1
        (/
          (cube guess)
          x
        )
      )
    )
    ratio
  )
)

(define (improve guess x)
  (/ (+ (/ x (square guess)) guess guess ) 3)
)

(define (square x)
  (* x x)
)

(define (cube x)
  (* x x x)
)

(write (cbrt 27e306) (current-output-port))
(newline (current-output-port))
