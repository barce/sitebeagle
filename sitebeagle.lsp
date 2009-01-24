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
  (if (regex "http:*" url)
    (set 'get-stuff (append "curl -s " url))
  )
  (if (regex "https:*" url)
    (set 'get-stuff (append "curl -k -s " url))
  )

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

(define (pollurl) 
	(set 'first_md5 (getmd5))
	(set 'current_md5 (getmd5))
	(println first_md5)
	(println current_md5)
	
	(do-while (= first_md5 current_md5) 
	  (set 'current_md5 (getmd5))
	  (println "first:   " first_md5)
	  (println "current: " current_md5)
	  (sleep 5000)
	)
)

(context MAIN)

