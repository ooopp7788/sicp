#### 简要代码
```scheme
(define (eval exp env)
  (cond
    ; 特殊情况: 关键字、基本类型
    ;; 自求值表达式: 值
    ((self-evaluating? exp) exp)
    ;; 变量
    ((variable? exp) (lookup-variable-value exp env))
    ;; 被引用值
    ((quoted? exp) (text-of-quotation exp))
    ;; lambda
    ;;; 生成形如 ('SOME-TYPE args proc-body) 表
    ((lambda? exp) (make-procedure (lambda-parameters exp) (lambda-body exp) env))
    ;; cond 条件语句
    ((cond? exp) (eval (cond->if exp) env))
    ; 一般情况，(proc args)
    ; 先 (eval proc env) 和 (list-of-values args env)
    ; 然后 (apply proc args)
    ;; 过程应用
    ((application? exp) (apply (eval (operator exp) env) (list-of-values (operands exp) env)))
    (else (error "Unknown expression type -- EVAL" exp))))

;; apply 过程应用
(define (apply procedure arguments)
  (cond ((primitive-procedure? procedure)
         ;; 基本过程(+ - * / ...)，直接调用
         (apply-primitive-procedure procedure arguments))
        ;; 复合过程，建立新环境，在新环境求值
        ((compound-procedure? procedure)
         (eval-sequence
          (procedure-body procedure)
          (extend-environment
           ;; 新环境，包括 复合过程参数、当前参数、复合过程环境
           (procedure-parameters procedure)
           arguments
           (procedure-environment procedure))))
        (else
         (error "Unknown procedure type -- APPLY" procedure))))
```

##### eval
- 区分各种case，对表达式求值
- lambda 表达式时，将 lambda 表达式转为
- 形如 (proc args) 的一般情况(combanation)时，

##### apply
