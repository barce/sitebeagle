#!/usr/bin/env newlisp

; usage: sitebeagle.lsp url seconds

; change this to where your install of crypto.lsp is
(load "/usr/share/newlisp/modules/crypto.lsp")



;
; furl: create a diskspace friendly url
;
(define (furl url)
  (set 'aList (regex "http(s)*://(.*)" url))
  (dotimes (x 6) (pop aList))
  (set 'fqdn (first aList))
  (replace "/" fqdn "")
)

(define (getmd5 url)
  (println "in getmd5: " url)
  ;(set 's_url (furl url))
  (set 's_url (append url ".txt"))
  (set 'socket (net-connect url 80))
  (if socket
    (net-send socket "GET / HTTP/1.0\r\n\r\n"))
  (net-receive socket str 65536 "</html>")
  (print "\n" str "\n")
  (net-close socket)
  (println s_url)
)

;
; start of tests and variable definitions
;
(set 'url "http://www.google.com/")

; test for furl
(set 'fileurl (furl url))
(println "getmd5")

(getmd5 fileurl)


(println fileurl)

(exit)
