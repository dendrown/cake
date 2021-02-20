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
(defmodule cake-app
  (behaviour application)
  (export
    ;; app implementation
    (start 2)
    (stop 1)))


;;; --------------------------------------------------------------------------
;;; API
;;; --------------------------------------------------------------------------
(defun start (_type _args)
  "Main application startup."
  ;; Erlang/OTP 21 logging is reserved pending design decisions on structured logging.
  ;; We are using lager via the llog module for prototyping and initial development.
  (logger:set_application_level 'cake 'all)
  (logger:info "Starting cake application ...")
  (llog:start)
  (llog:notice "Let us eat cake...")
  (cake-sup:start_link))


(defun stop (_)
  (cake-sup:stop)
  'ok)
