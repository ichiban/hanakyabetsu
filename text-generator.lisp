;;;; text-generator.lisp

(in-package :gs.ichiban.text-generator)

;;; utils

(defun shuffle (seq)
  "seqの要素の並びをシャッフルする。"
  (labels ((random-key (x)
	     (declare (ignore x))
	     (random 1.0)))
    (sort (copy-seq seq) #'> :key #'random-key)))

(defun exists (f seq)
  "seqの要素をfに適用していき、最初に返された非nilの値を返す。"
  (labels ((iter (seq)
	     (and seq
		  (or (funcall f (car seq))
		      (iter (cdr seq))))))
    (iter seq)))

;;; matrix

(defun make-matrix ()
  "テキストの生成規則を保持するマトリックスを生成する。"
    (make-hash-table :test 'equal))

(defun matrix-add (matrix prec word)
  "matrixにprecで表される先行する語の対からwordを生成する規則を追加する。"
  (let ((old (gethash prec matrix)))
    (setf (gethash prec matrix) (cons word old))))

(defun matrix-nexts (matrix prec)
  "matrix中の生成規則においてprecに後続しうるすべての遷移先を列挙する。"
  (gethash prec matrix))

(defun matrix-print (matrix)
  (maphash #'(lambda (k v) (print (list k v))) matrix))

;;; learning

(defun learn (matrix text)
  "matrixにtextで表される単語の列を学習させる。"
  (labels ((iter (words)
	     (destructuring-bind
		   (&optional one two three &rest rest) words
	       (if (and one two)
		   (progn
		     (matrix-add matrix (list one two) (or three :EOS))
		     (iter (cons two (cons three rest))))))))
    (matrix-add matrix :BOS (car text))
    (iter (cons :BOS text))))
		 

;;; generating

(defun candidates (matrix words)
  "wordsに続きうる語のリストをランダムな順にソートして返す。"
  (shuffle (matrix-nexts matrix
			 (destructuring-bind (&optional two one &rest rest)
			     words
			   (declare (ignore rest))
			   (cond ((and one two) (list one two))
				 (two (list :BOS two))
				 (t :BOS))))))

(defun prettify (words)
  "wordsに積まれた語の列を文字列にする。"
  (format nil "~{~a~}" (reverse words)))

(defun generate (matrix &optional max-length)
  "matrixに保持された生成規則からテキストを生成する。"
  (declare (ignore max-length))
  (labels ((iter (words)
	     (let ((nexts (candidates matrix words)))
	       (exists #'(lambda (next)
			   (cond ((null next)
				  nil)
				 ((equal next :EOS)
				  (prettify words))
				 (t
				  (iter (cons next words)))))
		       nexts))))
    (iter nil)))
