(restas:define-module :galton
  (:use :cl :restas :iterate)
  (:import-from :alexandria
                #:curry #:rcurry #:plist-hash-table #:when-let)
  (:import-from :st-json #:jso #:write-json-to-string)
  (:export #:run))
