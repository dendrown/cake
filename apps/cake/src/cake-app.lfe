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
  (llog:start)
  (logger:set_application_level 'cake 'all)
  (llog:notice "Let us eat cake...")
  (cake-sup:start_link))


(defun stop (_)
  (cake-sup:stop)
  'ok)
