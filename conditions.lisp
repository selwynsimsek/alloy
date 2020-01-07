#|
 This file is a part of Alloy
 (c) 2019 Shirakumo http://tymoon.eu (shinmera@tymoon.eu)
 Author: Nicolas Hafner <shinmera@tymoon.eu>
|#

(in-package #:org.shirakumo.alloy)

(define-condition alloy-condition (condition) ())

(defmacro define-alloy-condition (name superclasses format &body slotsargs)
  (let ((slots (loop for slot in slotsargs
                     unless (listp slot)
                     collect (list slot :initarg (intern (string slot) "KEYWORD") :reader slot)))
        (args (loop for arg in slotsargs
                    collect (if (listp arg) arg `(,arg c)))))
    `(define-condition ,name (,@superclasses alloy-condition)
       ,slots
       ,@(when format
           `((:report (lambda (c s) (format s ,format ,@args))))))))

(define-alloy-condition argument-missing (error)
    "The initarg ~s is required but was not passed."
  initarg)

(defun arg! (initarg)
  (error 'argument-missing :initarg initarg))

(define-alloy-condition index-out-of-range (error)
    "The index ~d is outside of [~{~d~^,~}[."
  index range)

(define-alloy-condition hierarchy-error (error)
    NIL container bad-element)

(define-alloy-condition element-has-different-parent (hierarchy-error)
    "Cannot perform operation with~%  ~s~%on~%  ~s~%as it is a parent on~%  ~s"
  bad-element container parent)

(define-alloy-condition element-not-contained (hierarchy-error)
    "The element~%  ~s~%is not a child of~%  ~s"
  bad-element container)

(define-alloy-condition element-has-different-root (hierarchy-error)
    "The element~%  ~s~%comes from the tree~%  ~s~%which is not~%  ~s"
  bad-element (focus-tree (element c)) container)

(define-alloy-condition root-already-established (error)
    "Cannot set~%  ~a~%as the root of~%  ~a~%as it already has a root in~%  ~a"
  bad-element tree (root (tree c)))

(define-alloy-condition layout-condition ()
    NIL layout)

(define-alloy-condition place-already-occupied (layout-condition error)
    "Cannot enter~%  ~a~%at ~a into~%  ~a~%as it is already occupied by~%  ~a"
  bad-element place layout existing)

(define-alloy-condition element-has-different-ui (error)
    "The element~%  ~s~%cannot be used with~%  ~s~%as it is set-up with~%  ~s"
  bad-element ui (ui (element c)))

(define-alloy-condition allocation-failed (error)
    "The allocation of the renderer~%  ~s~%failed."
  renderer)
