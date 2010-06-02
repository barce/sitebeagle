#!/usr/bin/newlisp


(load "sitebeagle.lsp")
(load "twitter.lsp");

(set 'params (main-args))
(if (< (length params) 4)
  (begin
    (println "USAGE: checksite.lsp url repeats myregex")
    (exit)
  )
)

(set 'url (nth 2 params))
; repeats - # of repeat alerts to send once an alert is tripped
(set 'repeats (nth 3 params))
(set 'myregex (nth 4 params))
(set 'startdate (date))

(println "----[ Sitebeagle is checking your site ]----")
(new Sitebeagle 'snoopy)
(set 'snoopy:url (string url))
(println snoopy:url)
(println (snoopy:getmd5))
(snoopy:pollurl)

(println "sending tweet...")
(new Twitter 'tweet)

;
; TODO: find a way to just put this info into YAML
;

;
; EDIT BELOW: this is the account you use to send tweets
;
(set 'tweet:user "sitebeagle")
(set 'tweet:pass "PASS")

;
; EDIT BELOW: this is the account you use to receive tweets
;
; TODO: change code to support a list of twitter accounts
(set 'tweet:recipient "barce")

;
; send the tweet
;
(until (> iter (int repeats))
	(tweet:dm (string "sequnce (" (int iter) ") something changed: " snoopy:url))
  (println "sending tweet alert sequence: " (int iter))
	(println "something changed: " snoopy:url)
	(println "startdate:")
	(println startdate)
	(println "enddate:")
	(println (date))
  (inc iter)
  (sleep 15000)

) ; end until

(exit)
