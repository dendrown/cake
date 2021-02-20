;;;; -------------------------------------------------------------------------
;;;;
;;;;      _/_/_/    _/_/    _/    _/  _/_/_/_/
;;;;   _/        _/    _/  _/  _/    _/
;;;;  _/        _/_/_/_/  _/_/      _/_/_/
;;;; _/        _/    _/  _/  _/    _/
;;;;  _/_/_/  _/    _/  _/    _/  _/_/_/_/
;;;;
;;;; LFE wrapper for Erlang's lager logger
;;;;
;;;; @copyright 2020 Dennis Drown and Ostrich Ideas
;;;; -------------------------------------------------------------------------
(defmodule llog
  (export
    (start 0)
    (log 3)
    (log 4))
  (export-macro debug info notice warning error critical alert emergency))


;; Log level commands must be macros so we pull the MODULE of the caller
(defmacro logger (level)
  "Creates a log level command called via (llog:level ...)"
  `(defmacro ,level args
     `(llog:log ',',level (MODULE) ,@args)))


;; Shortcuts for standard lager levels (and RFC-3164/syslog keywords)
(logger emergency)
(logger alert)
(logger critical)
(logger error)
(logger warning)
(logger notice)
(logger info)
(logger debug)


;;; --------------------------------------------------------------------------
;;; API
;;; --------------------------------------------------------------------------
(defun start ()
  "Quick-start for an application's logging needs."
  (application:ensure_all_started 'lager)
  (lager:start))


(defun log (level entity fmt)
  "Handles log messages via lager."
  (log level entity fmt ()))


(defun log (level entity fmt args)
  "Handles log messages via lager."
  (lager:log level (self)
             (++ "<~s> " fmt)
             (cons entity args)))

