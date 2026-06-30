#!/usr/bin/env janet
# Usage: ./run.janet CMD [ARG...]
# Commands:
#   hello
#   add

(use ./cmd)

(defcmd hello [world &opt other --bye bye? --ciao ciao? -d dup?]
  (default other "Other name")
  (def greeting (cond bye? "Bye"
                      ciao? "Ciao"
                      "Hello"))
  (each _ (range (if dup? 2 1))
    (printf "%s, %s! (%s)" greeting world other)))

(defcmd add [[a :int] &opt [b :int]]
  (default b 0)
  (def res (+ a b))
  (print res))

(defcmd help []
  (print (help)))

# (pp (cmd 'hello))

(defn main [& args]
  (dispatch [[:hello :h] (cmd 'hello)
             [:add :a]   (cmd 'add)
             [:help :h]  (cmd 'help)]
            args))
