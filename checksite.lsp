#!/usr/bin/newlisp


(load "sitebeagle.lsp")
(load "twitter.lsp");

(set 'params (main-args))
(if (< (length params) 3)
  (begin
    (println "USAGE: checksite.lsp url")
    (exit)
  )
)

(set 'url (nth 2 params))
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
(set 'tweet:user "noobwatcher")
(set 'tweet:pass "PASS")

;
; EDIT BELOW: this is the account you use to receive tweets
;
; TODO: change code to support a list of twitter accounts
(set 'tweet:recipient "barce")

;
; send the tweet
;
(tweet:dm (string "something changed: " snoopy:url))
(println "something changed: " snoopy:url)
(println "startdate:")
(println startdate)
(println "enddate:")
(println (date))


(exit)
