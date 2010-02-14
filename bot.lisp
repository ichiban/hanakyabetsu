;;;; bot.lisp

(in-package :gs.ichiban.bot)

(defun nop () (values))

(defun mins (mins) (* mins 60))

(defstruct bot
  username
  password
  (matrix (make-matrix))
  timer)

(defvar *interval* (mins 10))
(defvar *bots* nil)

(defun tweet (bot)
  (let ((*username* (bot-username bot))
	(*password* (bot-password bot)))
    (let ((status (generate (bot-matrix bot))))
      (if (and status (<= (length status) 140))
	  (update status)
	  (values)))))

(defun run (bot)
  (let ((timer (make-timer #'(lambda () (tweet bot)))))
    (setf (bot-timer bot) timer)
    (schedule-timer timer *interval*)))
  
(defun stop (bot)
  (unschedule-timer (bot-timer bot)))

(defun resume (bot)
  (schedule-timer (bot-timer bot) *interval*))