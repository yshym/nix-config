# Tests for argspec construction: `build-argspec`, `get-required-args`, and
# the macros that turn a spec into a command (`defcmd`/`cmdfn`).

(use judge)
(use ..)

(deftest build-argspec
  (test (build-argspec [hello --bye bye?])
    {:args @[{:name hello
              :optional? false
              :type :string
              :variadic? false}]
     :opts @{--bye {:optional? true :type :bool}}})
  (test (build-argspec [--foo foo bar --on on?])
    {:args @[{:name bar
              :optional? false
              :type :string
              :variadic? false}]
     :opts @{--foo {:optional? false :type :string}
             --on {:optional? true :type :bool}}})
  (test (build-argspec [--foo foo? --bar bar baz --on on?])
    {:args @[{:name baz
              :optional? false
              :type :string
              :variadic? false}]
     :opts @{--bar {:optional? false :type :string}
             --foo {:optional? true :type :bool}
             --on {:optional? true :type :bool}}})
  (test (build-argspec [foo &opt bar --baz baz])
    {:args @[{:name foo
              :optional? false
              :type :string
              :variadic? false}
             {:name bar
              :optional? true
              :type :string
              :variadic? false}]
     :opts @{--baz {:optional? true :type :string}}})
  (test (build-argspec [foo [bar :int] --baz [baz :int]])
    {:args @[{:name foo
              :optional? false
              :type :string
              :variadic? false}
             {:name bar
              :optional? false
              :type :int
              :variadic? false}]
     :opts @{--baz {:optional? false :type :int}}})
  (test (build-argspec [foo & rest])
    {:args @[{:name foo
              :optional? false
              :type :string
              :variadic? false}
             {:name rest
              :optional? true
              :type :string
              :variadic? true}]
     :opts @{}})
  (test (build-argspec [& rest])
    {:args @[{:name rest
              :optional? true
              :type :string
              :variadic? true}]
     :opts @{}}))

(deftest required-args
  (test (get-required-args (get (build-argspec [foo bar &opt baz --qux qux]) :args)) @[foo bar]))

(deftest macros
  (test-macro (build-argspec [hello --bye bye?])
    (let [<1> {:args @[] :opts @{}}]
      (var <2> nil)
      (var <3> false)
      (var <4> false)
      (each [arg arg-type]
        (quote @[(hello nil) (--bye nil) (bye? nil)])
        (cond (= arg (quote &opt))
          (set <3> true)
          (= arg (quote &))
          (if <4>
            (error "Multiple variadic collectors not allowed")
            (set <4> true))
          (option-name? arg)
          (set <2> arg)
          (cond (not (nil? <2>))
            (do
              (put-in <1> [:opts <2>] (make-opt (or (bool-name? arg) <3>) (if (bool-name? arg) :bool arg-type)))
              (set <2> nil))
            (do
              (when <4>
                (set <3> true))
              (array/push (get <1> :args) (make-arg arg <3> arg-type <4>))))))
      <1>))

  (test-macro (defcmd hello [world universe]
                ($ echo world))
    (let [<1> (build-argspec [world universe])]
      (save-command (quote hello) {:argspec <1> :fn (cmdfn [world universe] ($ echo world)) :name (quote hello)})))

  (test-macro (cmdfn [name]
                     (def greeting "Hello")
                     (printf "%s, %s!" greeting world))
    (fn []
      (def <1> (quote @[name]))
      (def <2> (quote @[]))
      (let [[name] (tuple (splice (map (short-fn (get-in (dyn :parsed-args) [:args $])) <1>)) (splice (map (short-fn (get-in (dyn :parsed-args) [:opts $])) <2>)))]
        (def greeting "Hello")
        (printf "%s, %s!" greeting world))))

  (test-macro (cmdfn [name &opt --bye bye? -d dup?]
                     (def greeting (if bye? "bye" "hello"))
                     (printf "%s, %s" greeting name))
    (fn []
      (def <1> (quote @[name]))
      (def <2> (quote @[--bye -d]))
      (let [[name bye? dup?] (tuple (splice (map (short-fn (get-in (dyn :parsed-args) [:args $])) <1>)) (splice (map (short-fn (get-in (dyn :parsed-args) [:opts $])) <2>)))]
        (def greeting (if bye? "bye" "hello"))
        (printf "%s, %s" greeting name)))))
