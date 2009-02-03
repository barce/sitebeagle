#!/usr/bin/env newlisp

;
; class Twitter
; -------------
;
; used for messaging users on twitter
;
; curl --basic --user user:pass -d "user=barce&text=blah"  http://twitter.com/direct_messages/new.xml



;
; load noodles.lsp for url-encoding
;
(load "noodles.lsp")
(set 'N NOODLES)

(context 'Twitter)
(set 'user nil)
(set 'pass nil)
(set 'recipient nil)

; dm : send a direct message
(define (dm message)

  (set 'direct-message (append "curl --basic --user " user ":" pass " -d  \"user=" recipient "&text=" (N:url-encode message) "\"  http://twitter.com/direct_messages/new.xml"))
  ;(println direct-message)
  (exec direct-message)

)


(context MAIN)

(new Twitter 'tweet)
(set 'tweet:user "noobwatcher")
(set 'tweet:pass "PASS")
(set 'tweet:recipient "barce")

(println (tweet:dm "test 123 test"))

(exit)
