#!/usr/bin/env newlisp


(load "Sitebeagle.lsp")

;
; start of tests and variable definitions
;
;(set 'url "http://www.google.com/")
;(set 'url "http://jimbarcelona.com/")

(println "----[ testing Sitebeagle ]----")
(new Sitebeagle 'snoopy)
(set 'snoopy:url "http://www.codebelay.com/")


(println snoopy:url)
(snoopy:pollurl)


