#!/usr/bin/newlisp


(load "sitebeagle.lsp")
(load "twitter.lsp");

(set 'params (main-args))
(if (< (length params) 3)
  (begin
    (println "USAGE: checksite.lsp url repeats")
    (exit)
  )
)

(set 'url (nth 2 params))
; repeats - # of repeat alerts to send once an alert is tripped
(set 'repeats (nth 3 params))
(set 'startdate (date))

(set 'iter 0)
(until (> iter (int repeats))
  (println iter)
  (println repeats)
  (inc iter)
  (sleep 1)
)
(println iter)

(exit)

