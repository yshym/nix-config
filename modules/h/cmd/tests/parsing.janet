# Tests for `parse-args` on valid input: positional arguments, options, and
# variadic collectors.

(use judge)
(use ..)

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

(deftest parse-args-option-value
  (test (parse-args (build-argspec [--name name]) ["--name" "Bob"])
        {:args @{}
         :opts @{--name "Bob"}}))

# A boolean option before another option is fine: it needs no value.
(deftest parse-args-bool-option-before-option
  (test (parse-args (build-argspec [--verbose verbose? --name name]) ["--verbose" "--name" "Bob"])
        {:args @{}
         :opts @{--verbose true --name "Bob"}}))

# A trailing boolean option is `true`.
(deftest parse-args-trailing-bool-option
  (test (parse-args (build-argspec [--on on?]) ["--on"])
        {:args @{}
         :opts @{--on true}}))

(deftest parse-args-variadic
  (test (parse-args (build-argspec [foo & rest]) ["foo" "a" "b" "c"])
        {:args @{foo "foo" rest @["a" "b" "c"]}
         :opts @{}})
  (test (parse-args (build-argspec [& rest]) ["a" "b"])
        {:args @{rest @["a" "b"]}
         :opts @{}})
  (test (parse-args (build-argspec [& rest]) [])
    {:args @{rest @[]} :opts @{}})
  (test (parse-args (build-argspec [name & rest]) ["hello"])
    {:args @{name "hello" rest @[]}
     :opts @{}}))
