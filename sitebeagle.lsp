#!/usr/bin/env newlisp

; usage: sitebeagle.lsp url seconds

; change this to where your install of crypto.lsp is


;
; class Sitebeagle
;
(context 'Sitebeagle)

(load "/usr/share/newlisp/modules/crypto.lsp")
; attribute(s)
(set 'url nil)
(set 'first_md5 nil)
(set 'current_md5 nil)

;
; furl: create a diskspace friendly url
;
(define (furl)
  (set 'aList (regex "http(s)*://(.*)" url))
  
  (dotimes (x 6) (pop aList))
  (set 'fqdn (first aList))
  (replace "/" fqdn "")
)

(define (getmd5)
  ; 
  ; convert web page into md5
  ;
  (set 'get-stuff (append "curl -s " url))

  ; html is the web page turned into a list of lines
  (set 'html (exec get-stuff))
  ;(println (nth 0 html))
  (set 'bigstring "")
  (dolist (line html)
    (set 'bigstring (append bigstring line "\n"))
  )

  ; return bigstring as md5
  (crypto:md5 bigstring)
)

(context MAIN)

;
; start of tests and variable definitions
;
;(set 'url "http://www.google.com/")
(set 'url "http://jimbarcelona.com/")

(println "----[ testing Sitebeagle ]----")
(new Sitebeagle 'snoopy)
(set 'snoopy:url "http://jimbarcelona.com")

(println snoopy:url)

; test for furl

(set 'snoopy:first_md5 (snoopy:getmd5))
(set 'snoopy:current_md5 (snoopy:getmd5))
(println snoopy:first_md5)
(println snoopy:current_md5)

(do-while (= snoopy:first_md5 snoopy:current_md5) 
  (set 'snoopy:current_md5 (snoopy:getmd5))
  (println snoopy:first_md5)
  (println snoopy:current_md5)
  (sleep 5000)
)

(exit)
