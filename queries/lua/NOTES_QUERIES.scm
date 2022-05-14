

; MODULE QUERIES

;; in module queries it might make sense to only capture the base
;; nodes for each module component, because we are still going to
;; have to parse it top down so that we know whether there is a function
;; in a table that is huge, you never know and therefore you have to go
;; top down, and then binary search find cursor position within the tree
