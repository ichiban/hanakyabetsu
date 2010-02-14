
(in-package :gs.ichiban.twitter)

(setf *drakma-default-external-format* :UTF-8)

(defvar *username*)
(defvar *password*)

(defvar *statuses-update-url* "http://twitter.com/statuses/update.json")

(defun update (status &key (status-id ""))
  (http-request *statuses-update-url*
		:method :post
		:content-length t
		:basic-authorization `(,*username* ,*password*)
		:parameters `(("status" . ,status)
			      ("in_reply_to_status_id" . ,status-id))))

			      