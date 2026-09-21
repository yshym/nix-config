# Tests for command registration and execution: `runcmd`, `cmd`,
# `cmd-alias`/`cmd-args`, and `dispatch`.

(use judge)
(use ..)

(deftest runcmd
  (defcmd hello [name]
    (printf "Hello, %s!" name))

  (test (cmd 'hello)
    {:argspec {:args @[{:name name
                        :optional? false
                        :type :string
                        :variadic? false}]
               :opts @{}}
     :fn "<function 0x1>"
     :name hello})

  (with-dyns [:args ["<bin>" "hello" "World"]]
    (test-stdout (runcmd 'hello) `
      Hello, World!
    `)))

(deftest runcmd-opt-arg
  (defcmd multi-hello [name &opt name2]
    (printf "Hello, %s and %s!" name name2))

  (test (cmd 'multi-hello)
    {:argspec {:args @[{:name name
                        :optional? false
                        :type :string
                        :variadic? false}
                       {:name name2
                        :optional? true
                        :type :string
                        :variadic? false}]
               :opts @{}}
     :fn "<function 0x1>"
     :name multi-hello})

  (with-dyns [:args ["<bin>" "multi-hello" "World" "World2"]]
    (test-stdout (runcmd 'multi-hello) `
      Hello, World and World2!
    `)))

(deftest runcmd-variadic
  (defcmd vari-hello [name & rest]
    (printf "Hello, %s! (%p)" name rest))

  (test (cmd 'vari-hello)
    {:argspec {:args @[{:name name
                        :optional? false
                        :type :string
                        :variadic? false}
                       {:name rest
                        :optional? true
                        :type :string
                        :variadic? true}]
               :opts @{}}
     :fn "<function 0x1>"
     :name vari-hello})

  (with-dyns [:args ["<bin>" "vari-hello" "World" "a" "b" "c"]]
    (test-stdout (runcmd 'vari-hello) `
      Hello, World! (@["a" "b" "c"])
    `))

  (with-dyns [:args ["<bin>" "vari-hello" "World"]]
    (test-stdout (runcmd 'vari-hello) `
      Hello, World! (@[])
    `)))

# A required option that is supplied must validate.
(deftest runcmd-required-option-supplied
  (defcmd validate-ok [--name name]
    name)

  (with-dyns [:args ["<bin>" "validate-ok" "--name" "Bob"]]
    (test (runcmd 'validate-ok) "Bob")))

# Supplying required positionals validates.
(deftest runcmd-required-positional-supplied
  (defcmd validate-pos-ok [first second]
    [first second])

  (with-dyns [:args ["<bin>" "validate-pos-ok" "a" "b"]]
    (test (runcmd 'validate-pos-ok) ["a" "b"])))

# An optional option that is omitted must validate.
(deftest runcmd-optional-option-omitted
  (defcmd validate-optional [--name name?]
    (if name? "yes" "no"))

  (with-dyns [:args ["<bin>" "validate-optional"]]
    (test (runcmd 'validate-optional) "no"))

  (with-dyns [:args ["<bin>" "validate-optional" "--name"]]
    (test (runcmd 'validate-optional) "yes")))

(deftest cmd-alias-and-args
  (with-dyns [:args ["<bin>" "hello" "a" "b"]]
    (test (cmd-alias) "hello")
    (test (cmd-args) @["a" "b"]))
  (with-dyns [:args ["<bin>" "hello"]]
    (test (cmd-args) @[])))

# runcmd accepts an explicit argument list, independent of (dyn :args).
(deftest runcmd-explicit-args
  (defcmd explicit [name]
    name)

  (with-dyns [:args ["<bin>" "something-else"]]
    (test (runcmd 'explicit ["<bin>" "explicit" "Bob"]) "Bob")))

(deftest dispatch-uses-given-args
  (defcmd dispatched [name]
    name)
  (def rules [[:dispatched :d] (cmd 'dispatched)])
  (test (dispatch rules ["<bin>" "d" "Bob"]) "Bob"))

(deftest dispatch-unknown-command
  (defcmd dispatched-2 [name]
    name)
  (def rules [[:dispatched-2 :d2] (cmd 'dispatched-2)])
  (test-error (dispatch rules ["<bin>" "nope"])
              "Unknown command \"nope\""))
