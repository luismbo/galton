(defsystem :galton
  :author "Luis Oliveira  <loliveira@common-lisp.net>"
  :description "Toy webapp for publishing questionnaires."
  :depends-on (:restas :yaclml :alexandria :cl-ppcre :st-json)
  :serial t
  :components ((:file "module")
               (:file "common")
               (:file "form")
               (:file "results")
               (:file "run")))
