(in-package :cl-user)

(ql:quickload :galton)

(galton:run
 '(:title "Questionnaire"
   :description "Random questions for lispers."
   :output "responses.data"
   :contents
   ((:text
     :title "Name"
     :hint "(optional)")

    (:month
     :title "When did you start working at your company?")

    (:multichoice
     :title "Have you programmed in Lisp at your company some time over the
             last 12 months?"
     :choices ("yes"
               "no"))


    (:section :title "Lisp")

    (:multichoice
     :title "Did you know how to program in Lisp before joining your company?"
     :choices ("yes"
               "no"))

    (:multichoice
     :title "Lisp: great language or the greatest language?"
     :choices ("great"
               "the greatest"
               "not particularly fond of Lisp"))

    (:multichoice
     :title "Do you use LOOP?"
     :choices ("yes, I use it whenever it's the most convenient solution"
               "never used it"
               "sometimes, but I don't master it"
               "no, I don't like it"))

    (:multichoice
     :title "How many macros have you written and committed?"
     :choices ("0"
               "1"
               "]1, 5]"
               "]5, 10]"
               "]10, +∞["))


    (:section :title "Lisp outside of your company")

    (:multichoice
     :title "How do you perceive the impact of your Lisp experience
             in your CV?"
     :choices ("positive"
               "negative"
               "neutral"))

    (:checkboxes
     :title "Do you participate within or follow the Common Lisp community?"
     :choices ("Planet Lisp"
               "comp.lang.lisp (Usenet)"
               "#lisp (IRC)"
               "reddit.com/r/lisp"
               "cliki.net"
               "stackoverflow.com/questions/tagged/lisp"
               "other"))

    (:multichoice
     :title "Did you use Lisp (or a dialect thereof) at university?"
     :choices ("yes"
               "no"))

    (:multichoice
     :title "Have you ever used Lisp outside of your company or university?"
     :choices ("yes"
               "no"))

    (:checkboxes
     :title "Which contemporary CL compilers have you tried outside of your company?"
     :choices ("ABCL"
               "Allegro CL"
               "CLISP"
               "CMUCL"
               "Clozure CL"
               "Corman CL"
               "ECL"
               "GNU CL"
               "JSCL"
               "Lispworks"
               "MCL"
               "SBCL"
               "Scieneer CL"
               "XCL"
               "other"))

    (:multichoice
     :title "Have you ever used an open-source Lisp library?"
     :choices ("yes"
               "no"))

    (:multichoice
     :title "Have you ever used Quicklisp?"
     :choices ("yes"
               "no"
               "I don't know what Quicklisp is"))

    (:checkboxes
     :title "Have you ever used other Lisp dialects?"
     :hint "Let's define \"use\" as having written more than a page of code."
     :choices ("Scheme"
               "Racket"
               "ISLISP"
               "Zeta Lisp (Lisp Machine Lisp)"
               "MacLisp"
               "Clojure"
               "Emacs Lisp"
               "other"))

    (:checkboxes
     :title "Which Lisp books have you read in full or in part?"
     :choices ("ANSI Common Lisp (Paul Graham)"
               "On Lisp (Paul Graham)"
               "Practical Common Lisp (Peter Seibel)"
               "The Art of the Metaobject Protocol (Gregor Kiczales)"
               "Structure and Interpretation of Computer Programs (Abelson and Sussman)"
               "Lisp in Small Pieces (Christian Queinnec)"
               "Common Lisp: A Gentle Introduction to Symbolic Computation (David S. Touretzky)"
               "Paradigms of Artificial Intelligence Programming: Case Studies in Common Lisp (Peter Norvig)"
               "other"))


    (:section :title "Lesser languages")

    (:checkboxes
     :title "Have you ever used other, lesser programming languages?"
     :hint "Let's define \"use\" as having written more than a page of code."
     :choices ("Java"
               "C"
               "C++"
               "Python"
               "Ruby"
               "C#"
               "Javascript"
               "Perl"
               "PHP"
               "Objective-C"
               "Visual Basic"
               "Haskell"
               "ML"
               "OCaml"
               "Prolog"
               "Scala"
               "Erlang"
               "F#"
               "Smalltalk"
               "other"))

    (:multichoice
     :title "Would you prefer to have your company's main language be something
             else other than Lisp?"
     :choices ("no"
               "no way!"
               "Java"
               "C"
               "C++"
               "Python"
               "Ruby"
               "C#"
               "Javascript"
               "Perl"
               "PHP"
               "Objective-C"
               "Visual Basic"
               "Haskell"
               "ML"
               "OCaml"
               "Prolog"
               "Scala"
               "Erlang"
               "F#"
               "Smalltalk"
               "other"))


    (:section :title "Editors")

    (:multichoice
     :title "Emacs: great editor or the greatest editor?"
     :choices ("great"
               "the greatest"
               "pining for the Lisp Machine's venerable Zmacs"
               "not particularly fond of Emacsen"))

    (:multichoice
     :title "Do you use SLIME or ELI?"
     :choices ("SLIME"
               "ELI"
               "don't know what SLIME is"
               "don't know what SLIME or ELI are")))))
