(declare-project
 :name "h"
 :dependencies [
   {:url "https://github.com/andrewchambers/janet-sh.git"}
   {:url "https://github.com/ianthehenry/judge.git"}
 ])

(declare-executable
 :name "h"
 :entry "h.janet"
 :install true)
