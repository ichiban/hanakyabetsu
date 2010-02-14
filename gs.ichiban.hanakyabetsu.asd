;;;; hanakyabetsu.asd

(defpackage gs.ichiban.hanakyabetsu.system (:use :cl :asdf))
(in-package :gs.ichiban.hanakyabetsu.system)

(defsystem :gs.ichiban.hanakyabetsu
  :name "hanakyabetsu twitter bot"
  :author "Yutaka Ichiban <yichiban@gmail.com>"
  :depends-on (:drakma)
  :components ((:file "packages")
	       (:file "twitter" :depends-on ("packages"))
	       (:file "text-generator" :depends-on ("packages"))
	       (:file "bot" :depends-on ("packages"
					 "twitter"
					 "text-generator"))))