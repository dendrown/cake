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
    (log 4)))


(defmacro llogger (level)
  "Generate logging macros for the specified log level."
  `(progn
     ;; Level loggers need to be macros to pick up the caller's module
     (defmacro ,level (fmt)
       (llog:log level (MODULE) fmt))

     (defmacro ,level (fmt args)
       (llog:log level (MODULE) fmt args))))


;; Shortcuts for standard lager levels (and RFC-3164/syslog keywords)
(llogger debug)
(llogger info)

;;; --------------------------------------------------------------------------
;;; API
;;; --------------------------------------------------------------------------
(defun start ()
  "Quick-start for an application's logging needs."
  (lager:start))


(defun log (level entity fmt)
  "Handles log messages via lager."
  (log level entity fmt '()))


(defun log (level entity fmt args)
  "Handles log messages via lager."
  (lager:log level (self)
             (++ "<~s> " fmt)
             (cons entity  args)))

