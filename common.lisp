(in-package :galton)

;;;; Global Variables

;;; TODO: figure out a better way to store these.
(defvar *form*)
(defvar *results*)
(defvar *results-lock*)


;;;; Manipulating the Form

(defun form (indicator &optional default)
  (getf *form* indicator default))

(defun question-type (question)
  (first question))

(defun question-getf (question indicator)
  (getf (rest question) indicator))


;;;; Routes for Static Files

(define-route css ("/:(file).css")
  (assert (member file '("form" "results") :test #'string=))
  (asdf:system-relative-pathname :galton file :type "css"))

(define-route js ("/:(file).js")
  (let ((path (cond ((string= file "highcharts")
                     "vendor/highcharts.js")
                    ((string= file "jquery.min")
                     "vendor/jquery.min.js")
                    ((string= file "results")
                     "results.js")
                    (t
                     (error "unknown file")))))
    (asdf:system-relative-pathname :galton path)))


;;;; Utilities

(defmacro defpage (name args &body body)
  `(define-route ,name ,args
     (yaclml:with-yaclml-output-to-string
       ,@body)))

(defun yyyy-mm-to-year-timestamp (date)
  "Parses a date in YYYY-MM format to a Javascript timestamp for YYYY-01-01."
  (* 1000
     (- (encode-universal-time 0 0 0 1 1 (parse-integer date :end 4))
        (encode-universal-time 0 0 0 1 1 1970))))
