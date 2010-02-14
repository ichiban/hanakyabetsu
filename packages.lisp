;;;; package.lisp

(in-package :cl-user)

(defpackage :gs.ichiban.twitter
  (:use :common-lisp
	:drakma)
  (:export :*statuses-update-url*
	   :*username*
	   :*password*
	   :update))

(defpackage :gs.ichiban.text-generator
  (:use :common-lisp)
  (:export :make-matrix
	   :learn
	   :generate))

(defpackage :gs.ichiban.bot
  (:use :common-lisp
	:sb-ext
	:gs.ichiban.twitter
	:gs.ichiban.text-generator)
  (:export :*interval*
	   :make-bot
	   :bot-p
	   :bot-username
	   :bot-password
	   :bot-action
	   :bot-timer
	   :bot-run
	   :bot-stop))

   