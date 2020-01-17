#lang sicp
(define (celsius-fahrenheit-converter c f)
  (let ((u (make-connector))
        (v (make-connector))
        (w (make-connector))
        (x (make-connector))
        (y (make-connector)))
    (multiplier c w u)
    (multiplier v x u)
    (adder v y f)
    (constant 9 w)
    (constant 5 x)
    (constant 32 y)
'ok))

(define (has-value? c)
  ())

(define (get-value c)
  ())

(define (set-value! c value informant)
  ())

(define (forgot-value! c retractor)
  ())

(define (get-value c new)
  ())

(define (adder a1 a2 sum)
  ;; 同步关联值
  ((define (process-new-value)
     (cond ((and (has-value? a1) (has-value? a2))
            (set-value! sum (+ (get-value a1) (get-value a2)) me))
           ((and (has-value? a1) (has-value? sum))
            (set-value! a2 (- (get-value sum) (get-value a1)) me))
           ((and (has-value? a2) (has-value? sum))
            (set-value! a1 (- (get-value sum) (get-value a2)) me)))))
  ;; 清除值
  (define (process-forget-value)
    (forget-value! sum me) (forget-value! a1 me)
    (forget-value! a2 me) (process-new-value))
  ;; 返回过程
  (define (me request)
    (cond ((eq? request 'I-have-a-value) (process-new-value))
          ((eq? request 'I-lost-my-value) (process-forget-value))
          (else (error "Unknown request -- ADDER" request))))
  ;; 建立连接
  (connect a1 me) (connect a2 me)
  (connect sum me)
me)


