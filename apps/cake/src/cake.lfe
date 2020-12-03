;;;; -------------------------------------------------------------------------
;;;;
;;;;      _/_/_/    _/_/    _/    _/  _/_/_/_/
;;;;   _/        _/    _/  _/  _/    _/
;;;;  _/        _/_/_/_/  _/_/      _/_/_/
;;;; _/        _/    _/  _/  _/    _/
;;;;  _/_/_/  _/    _/  _/    _/  _/_/_/_/
;;;;
;;;; A game engine to encourage conversation on complex issues.
;;;;
;;;; @copyright 2020 Dennis Drown and Ostrich Ideas
;;;; -------------------------------------------------------------------------
(defmodule cake
  (behaviour gen_server)
  (export
    ;; gen_server implementation
    (start_link 0)
    (stop 0)
    ;; callback implementation
    (init 1)
    (handle_call 3)
    (handle_cast 2)
    (handle_info 2)
    (terminate 2)
    (code_change 3)
    ;; server API
    (pid 0)
    (echo 1)
    (fizzbuzz 0) (fizzbuzz 1) (fizzbuzz 2))
  (import (from lists (foldl 3) (foldr 3))
          (from maps  (fold 3) (get 2))))



;;; --------------------------------------------------------------------------
;;; config functions
;;; --------------------------------------------------------------------------
(defun SERVER () (MODULE))
(defun initial-state () '#())
(defun genserver-opts () '())
(defun unknown-command () #(error "Unknown command."))


;;; --------------------------------------------------------------------------
;;; gen_server implementation
;;; --------------------------------------------------------------------------
(defun start_link ()
  (gen_server:start_link `#(local ,(SERVER))
                         (MODULE)
                         (initial-state)
                         (genserver-opts)))

(defun stop ()
  (gen_server:call (SERVER) 'stop))



;;; --------------------------------------------------------------------------
;;; callback implementation
;;; --------------------------------------------------------------------------
(defun init (state)
  `#(ok ,state))


(defun handle_cast (_msg state)
  `#(noreply ,state))


(defun handle_call
  (('stop _from state)
    `#(stop shutdown ok state))
  ((`#(echo ,msg) _from state)
    `#(reply ,msg state))
  ((message _from state)
    `#(reply ,(unknown-command) ,state)))


(defun handle_info
  ((`#(EXIT ,_from normal) state)
   `#(noreply ,state))
  ((`#(EXIT ,pid ,reason) state)
   (io:format "Process ~p exited! (Reason: ~p)~n" `(,pid ,reason))
   `#(noreply ,state))
  ((_msg state)
   `#(noreply ,state)))


(defun terminate (_reason _state)
  'ok)


(defun code_change (_old-version state _extra)
  `#(ok ,state))


;;; --------------------------------------------------------------------------
;;; Server API
;;; --------------------------------------------------------------------------
(defun pid ()
  (erlang:whereis (SERVER)))


(defun echo (msg)
  (gen_server:call (SERVER) `#(echo ,msg)))


(defun fizzbuzz ()
  "There is no good reason to have this here..."
  (fizzbuzz 100))


(defun fizzbuzz
  "There is no good reason to have this here..."
  ((n) (when (is_integer n))
  (fizzbuzz n '()))

  ((words)
  (fizzbuzz 100 words)))


(defun fizzbuzz
  ;"There is no good reason to have this here..."
  ((n words) (when (is_map words))
  (fizzbuzz n
            (maps:to_list words)))

  ((n words)
  ;; With a proplist, the user can control the word order
  (flet ((gen-check (((tuple word x))
           ;; Function to check when the count is divisible by x
           (tuple word
                  (lambda (cnt)
                    (=:= 0 (rem cnt x))))))

         (wordify (cnt checks)
           ;; Build (compound) word(s) according to what divides it
           (lists:flatten
             (foldr (match-lambda (((tuple word check) acc)
                      (if (funcall check cnt)
                          (io_lib:format "~s~s" `(,word ,acc))
                           acc)))
                    ""
                    checks))))

    (let ((checks (lists:map #'gen-check/1
                           (++ '(#(fizz 3)
                                 #(buzz 5))
                               words))))
      (lists:map (lambda (cnt)
                   (case (wordify cnt checks)
                     (""   cnt)
                     (word word)))
                 (lists:seq 1 n))))))
