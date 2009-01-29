#!/usr/bin/env newlisp

;
; class Twitter
; -------------
;
; used for messaging users on twitter
;
; curl --basic --user user:pass -d "user=barce&text=blah"  http://twitter.com/direct_messages/new.xml
(context 'Twitter)
(set 'user nil)
(set 'pass nil)
(set 'recipient nil)

; dm : send a direct message
(define (dm message))


(context MAIN)

