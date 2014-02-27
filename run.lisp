(in-package :galton)

(defun cleanup-whitespace (string)
  (if (stringp string)
      (ppcre:regex-replace-all "\\s+" string " ")
      string))

(defun maptree (function tree)
  (if (atom tree)
      (funcall function tree)
      (mapcar (curry #'maptree function) tree)))

(defclass logging-acceptor (restas-acceptor)
  ()
  (:default-initargs
   :access-log-destination #p"access.log"
   :message-log-destination #P"error.log"))

(defun run (form &rest args &key (port 8080))
  ;; ew...
  (setf *default-pathname-defaults*
        (make-pathname :name nil
                       :type nil
                       :defaults (asdf:system-definition-pathname :galton)))
  (setf *form* (maptree #'cleanup-whitespace form))
  (setf *results* (with-open-file (in (form :output)
                                      :if-does-not-exist nil
                                      :external-format :utf-8)
                    (read in)))
  (setf *results-lock* (bt:make-lock "results lock"))
  (apply #'start :galton
         :port port
         :acceptor-class 'logging-acceptor
         args))
