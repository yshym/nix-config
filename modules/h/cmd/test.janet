(use judge)
(use ./cmd)

(deftest macros
  (test-macro (build-argspec [hello --bye bye?])
    (let [<1> {:args @[] :opts @{}}]
      (var <2> nil)
      (var <3> false)
      (each arg
        (quote [hello --bye bye?])
        (def [arg arg-type] (if (tuple? arg) [(splice arg)] [arg nil]))
        (cond (= arg (quote &opt))
          (set <3> true)
          (option-name? arg)
          (set <2> arg)
          (cond (not (nil? <2>))
            (do
              (put-in <1> [:opts <2>] (make-opt (or (bool-name? arg) <3>) (if (bool-name? arg) :bool arg-type)))
              (set <2> nil))
            (array/push (get <1> :args) (make-arg arg <3> arg-type)))))
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

(deftest build-argpsec
  (test (build-argspec [hello --bye bye?])
    {:args @[{:name hello
              :optional? false
              :type :string}]
     :opts @{--bye {:optional? true :type :bool}}})
  (test (build-argspec [--foo foo bar --on on?])
    {:args @[{:name bar
              :optional? false
              :type :string}]
     :opts @{--foo {:optional? false :type :string}
             --on {:optional? true :type :bool}}})
  (test (build-argspec [--foo foo? --bar bar baz --on on?])
    {:args @[{:name baz
              :optional? false
              :type :string}]
     :opts @{--bar {:optional? false :type :string}
             --foo {:optional? true :type :bool}
             --on {:optional? true :type :bool}}})
  (test (build-argspec [foo &opt bar --baz baz])
    {:args @[{:name foo
              :optional? false
              :type :string}
             {:name bar
              :optional? true
              :type :string}]
     :opts @{--baz {:optional? true :type :string}}})
  (test (build-argspec [foo [bar :int] --baz [baz :int]])
    {:args @[{:name foo
              :optional? false
              :type :string}
             {:name bar :optional? false :type :int}]
     :opts @{--baz {:optional? false :type :int}}}))

(deftest required-args
  (test (get-required-args (get (build-argspec [foo bar &opt baz --qux qux]) :args)) @[foo bar]))

(deftest parse-args
  (test (parse-args (build-argspec [foo bar baz]) ["foo" "bar" "baz"])
        {:args @{bar "bar" baz "baz" foo "foo"}
         :opts @{}})
  (test (parse-args (build-argspec [--foo foo bar --on on?]) ["--foo" "foo" "bar" "--on"])
    {:args @{bar "bar"}
     :opts @{--foo "foo" --on true}})
  (test (parse-args (build-argspec [--foo foo? --bar bar baz --on on?]) ["--foo" "--bar" "bar" "baz" "--on"])
    {:args @{baz "baz"}
     :opts @{--bar "bar" --foo true --on true}}))

(deftest runcmd
  (defcmd hello [name]
    (printf "Hello, %s!" name))

  (test (cmd 'hello)
    {:argspec {:args @[{:name name
                        :optional? false
                        :type :string}]
               :opts @{}}
     :fn "<function 0x1>"
     :name hello})

  (with-dyns [:args ["<bin>" "World"]]
    (test-stdout (runcmd 'hello) `
      Hello, World!
    `)))

(deftest runcmd-opt-arg
  (defcmd multi-hello [name &opt name2]
    (printf "Hello, %s and %s!" name name2))

  (test (cmd 'multi-hello)
    {:argspec {:args @[{:name name
                        :optional? false
                        :type :string}
                       {:name name2
                        :optional? true
                        :type :string}]
               :opts @{}}
     :fn "<function 0x1>"
     :name multi-hello})

  (with-dyns [:args ["<bin>" "World" "World2"]]
    (test-stdout (runcmd 'multi-hello) `
      Hello, World and World2!
    `)))
