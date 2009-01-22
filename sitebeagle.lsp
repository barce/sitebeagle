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
  ;(set 'socket (net-connect url 80))
  ;(if socket
  ;  (net-send socket "GET / HTTP/1.0\r\n\r\n"))
  ;(net-receive socket str 65536 "</html>")
  ;(net-close socket)
  ;(print "\n" str "\n")
  ; 
  ; convert web page into md5
  ;
  (set 'get-stuff (append "curl -s " url))
  ;(println get-stuff)

  ; html is the web page turned into a list of lines
  (set 'html (exec get-stuff))
  ;(println (nth 0 html))
  (set 'bigstring "")
  (dolist (line html)
    (set 'bigstring (append bigstring line "\n"))
  )
  ;(print "\n(" bigstring ")\n")
  (crypto:md5 bigstring)

)

;
; start of tests and variable definitions
;
;(set 'url "http://www.google.com/")
(set 'url "http://jimbarcelona.com/")

; test for furl
(set 'fileurl (furl url))
(println "getmd5")

(set 'mymd5 (getmd5 url))
(set 'tmpmd5 mymd5)

(println mymd5)
(println tmpmd5)

(println "url: " url)
(println "fileurl: " fileurl)

(do-while (= mymd5 tmpmd5) 
  (set 'tmpmd5 (getmd5 url))
  (println mymd5)
  (println tmpmd5)
  (sleep 5000)
)

(exit)
