(context 'NOODLES)
(define (url-encode s) (replace "([^a-zA-z0-9\-_\.~])" s (format "%%%X" (char $1)) 0))
(define (url-decode s) (replace "%([0-9A-F][0-9A-F])" s (char (int $1 0 16)) 0))
(context 'MAIN)
