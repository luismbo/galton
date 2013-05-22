(in-package :galton)

;;;; Form Display

(defgeneric display-form-item (type &key))

(defpage main ("")
  (<:html
   (<:head
    (<:title (<:ah (form :title)))
    (<:link :href (genurl 'css :file "form") :type "text/css" :rel "stylesheet"))
   (<:body
    (<:div :class "ss-form-container"
           ;; header
           (<:div :class "ss-top-of-page"
                  (<:div :class "ss-form-heading"
                         (<:h1 :class "ss-form-title"
                               (<:ah (form :title)))
                         (<:div :class "ss-form-desc"
                                (<:p (<:ah (form :description))))))

           ;; form
           (<:div :class "ss-form"
                  (<:form :action (genurl 'submit)
                          :method :post
                          :id "ss-form"
                          :target "_self"
                          ;; items
                          (dolist (item (form :contents))
                            (apply #'display-form-item item))
                          ;; submit
                          (<:div :class "ss-item ss-navigate"
                                 (<:div :class "ss-form-entry"
                                        (<:input :type :submit
                                                 :id "ss-submit")))))))))


;;;; Form Display

;; TODO: use something like
;; http://daringfireball.net/2009/11/liberal_regex_for_matching_urls
;; to linkify URLs in user-provided text.
(defun form-text (text)
  (when text
    (<:ah text)))

(defun call-with-question (kind title hint fn)
  (<:div :class "ss-form-question errorbox-good"
         (<:div :class (format nil "ss-item~@[ ~a~]" kind)
                (<:div :class "ss-form-entry"
                       (<:label :class "ss-q-item-label"
                                (<:div :class "ss-q-title"
                                       (form-text title))
                                (when hint
                                  (<:div :class "ss-q-help ss-secondary-text"
                                         (form-text hint))))
                       (funcall fn)))))

(defmacro with-question ((kind title hint) &body body)
  `(call-with-question ,kind ,title ,hint (lambda () ,@body)))


(defmethod display-form-item ((type (eql :month)) &key title hint)
  (with-question ("ss-date" title hint)
    (<:input :type :month :value "" :class "ss-q-date" :name title)))


(defmethod display-form-item ((type (eql :text)) &key title hint)
  (with-question ("ss-text" title hint)
    (<:input :type :text :value "" :class "ss-q-short" :name title)))

(defmethod display-form-item ((type (eql :section)) &key title description)
  (<:div :class "errorbox-good"
         (<:div :class "ss-item ss-section-header"
                (<:div :class "ss-form-entry"
                       (<:h2 :class "ss-section-title"
                             (form-text title))
                       (<:div :class "ss-section-description"
                              (form-text description))))))

(defun display-choice (type name text)
  (check-type type (member :radio :checkbox))
  (<:li :class "ss-choice-item"
        (<:label (<:span :class "ss-choice-item-control goog-inline-block"
                         (<:input :type type
                                  :value text
                                  :class (ecase type
                                           (:radio "ss-q-radio")
                                           (:checkbox "ss-q-checkbox"))
                                  :name name))
                 (<:span :class "ss-choice-label"
                         (<:ai "&nbsp;") (form-text text)))))

(defmethod display-form-item ((type (eql :multichoice)) &key title hint choices)
  (with-question ("ss-radio" title hint)
    (<:ul :class "ss-choices"
          (mapc (curry #'display-choice :radio title) choices))))

(defmethod display-form-item ((type (eql :checkboxes)) &key title hint choices)
  (with-question ("ss-checkbox" title hint)
    (<:ul :class "ss-choices"
          (mapc (curry #'display-choice :checkbox title) choices))))


;;;; Form Submission

(defpage submit ("/submit" :method :post)
  (check-answers (hunchentoot:post-parameters*))
  (bt:with-lock-held (*results-lock*)
    (push (list :address (hunchentoot:remote-addr*)
                :timestamp (get-universal-time)
                :response (hunchentoot:post-parameters*))
          *results*)
    (with-open-file (out (form :output) :direction :output
                                        :if-exists :supersede)
      (print *results* out)))
  (redirect 'results))

(defun valid-answer-p (question answer)
  (ecase (question-type question)
    ((:month :text) t)
    ((:multichoice :checkboxes)
     (member answer
             (question-getf question :choices)
             :test #'string=))))

(defun check-answers (answers)
  (loop for (key . value) in answers
        for question = (find key (form :contents)
                             :key (rcurry #'question-getf :title)
                             :test #'string=)
        do (assert (and question (valid-answer-p question value)))
           (unless (eq (question-type question) :checkboxes)
             (assert (eql 1 (count key answers :test #'equal :key #'car))))
           (assert (eql 1 (count (cons key value) answers :test #'equal)))))
