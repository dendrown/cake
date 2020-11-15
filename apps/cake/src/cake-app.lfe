(defmodule cake-app
  (behaviour application)
  (export
    ;; app implementation
    (start 2)
    (stop 0)))

;;; --------------------------
;;; application implementation
;;; --------------------------

(defun start (_type _args)
  (logger:set_application_level 'cake 'all)
  (logger:info "Starting cake application ...")
  (cake-sup:start_link))

(defun stop ()
  (cake-sup:stop)
  'ok)
