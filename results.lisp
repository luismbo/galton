(in-package :galton)

;;;; Displaying Response Summary

;; The `results' page is powered by results.js which gets JSON data
;; via the `data' route.
(defpage results ("/results")
  (<:html
   (<:head
    (<:title (format nil "~a - Results" (form :title)))
    (<:link :href (genurl 'css :file "results") :type "text/css" :rel "stylesheet")
    (<:script :src "jquery.min.js")
    (<:script :src "highcharts.js"))
   (<:body
    (<:h1 (<:ah (format nil "~a responses" (length *results*))))
    (<:div :id "contents")
    (<:script :src "results.js"))))

;; Returns a JSON object with the following format:
;;   { "type": <one of 'section', 'month', 'checkboxes', 'multichoice'>,
;;     "title": <some title>,
;;     "chart": <an highchart option object, if applicable> }
(defgeneric make-json-data (type question))

(define-route data ("/data" :content-type "application/json")
  (write-json-to-string
   (iter (for question :in (form :contents))
         (let ((type (question-type question)))
           (unless (eq type :text)
             (collect (make-json-data type question)))))))

(defun collect-results (type title choices)
  (let ((answers (make-hash-table :test #'equal)))
    (dolist (choice choices)
      (setf (gethash choice answers) 0))
    (dolist (result *results*)
      (let ((response (getf result :response)))
        (dolist (pair (remove-if-not (curry #'string= title) response :key #'car))
          (incf (gethash (if (eq type :month)
                             (yyyy-mm-to-year-timestamp (cdr pair))
                             (cdr pair))
                         answers
                         0)))))
    (sort (iter (for (answer count) :in-hashtable answers)
                (collect (list answer count)))
          #'>= :key #'second)))

(defmethod make-json-data ((type (eql :section)) question)
  (jso "type" "section" "title" (question-getf question :title)))

(defmethod make-json-data ((type (eql :multichoice)) question)
  (let* ((title (question-getf question :title))
         (choices (question-getf question :choices))
         (data (collect-results :multichoice title choices)))
    (jso "type" "multichoice"
         "title" title
         "chart" (jso "title" (jso "text" :null)
                      "series" (list (jso "type" "pie"
                                          "data" data))))))

(defmethod make-json-data ((type (eql :checkboxes)) question)
  (let* ((title (question-getf question :title))
         (choices (question-getf question :choices))
         (data (collect-results :checkboxes title choices)))
    (jso "type" "checkboxes"
         "title" title
         "chart" (jso "title" (jso "text" :null)
                      "yAxis" (jso "title" (jso "text" :null))
                      "xAxis" (jso "categories" (mapcar #'first data)
                                   "allowDecimals" :false)
                      "series" (list (jso "type" "bar"
                                          "data" data))))))

(defmethod make-json-data ((type (eql :month)) question)
  (let* ((title (question-getf question :title))
         (data (collect-results :month title nil)))
    (jso "type" "month"
         "title" title
         "chart" (jso "title" (jso "text" :null)
                      "xAxis" (jso "type" "datetime")
                      "yAxis" (jso "title" (jso "text" :null)
                                   "allowDecimals" :false)
                      "series" (list (jso "type" "column"
                                          "data" data))))))
