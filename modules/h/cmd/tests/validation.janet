# Tests for input validation and rejection: malformed arguments, missing
# required arguments/options, and type conversion errors.

(use judge)
(use ..)

(deftest convert-to-bool-truthy
  (test (convert-to "true" :bool) true)
  (test (convert-to "1" :bool) true)
  (test (convert-to "on" :bool) true)
  (test (convert-to "yes" :bool) true)
  (test (convert-to "TRUE" :bool) true)
  (test (convert-to "On" :bool) true))

(deftest convert-to-bool-falsy
  (test (convert-to "false" :bool) false)
  (test (convert-to "0" :bool) false)
  (test (convert-to "off" :bool) false)
  (test (convert-to "no" :bool) false)
  (test (convert-to "FALSE" :bool) false))

(deftest convert-to-bool-invalid
  (test-error (convert-to "tur" :bool) "Invalid boolean value \"tur\"")
  (test-error (convert-to "2" :bool) "Invalid boolean value \"2\"")
  (test-error (convert-to "maybe" :bool) "Invalid boolean value \"maybe\""))

# An option that is not declared in the spec is rejected by name, rather
# than swallowed or reported as a missing value for a declared option.
(deftest parse-args-unknown-option
  (test-error (parse-args (build-argspec [--name name]) ["--nope" "x"])
              "Unknown option \"--nope\"")
  # A trailing undeclared option is still unknown, not a missing value.
  (test-error (parse-args (build-argspec [--name name]) ["--nope"])
              "Unknown option \"--nope\"")
  # An undeclared option after a boolean option is rejected.
  (test-error (parse-args (build-argspec [--verbose verbose?]) ["--verbose" "--nope"])
              "Unknown option \"--nope\""))

# A value-requiring option must not swallow a following option as its
# value; that is a missing-value error, not a silent assignment.
(deftest parse-args-option-does-not-swallow-option
  (test-error (parse-args (build-argspec [--name name --other other]) ["--name" "--other" "x"])
              "Option \"--name\" requires a value"))

# A trailing option with a declared non-bool type requires a value.
(deftest parse-args-trailing-value-requiring-option
  (test-error (parse-args (build-argspec [--count [count :int]]) ["--count"])
              "Option \"--count\" requires a value"))

# Passing more positional arguments than the spec declares is an error,
# not a silently corrupt result table.
(deftest parse-args-too-many-positionals
  (test-error (parse-args (build-argspec [one]) ["a" "b" "c"])
              "Too many arguments, unexpected \"b\""))

# A missing required positional argument names the argument.
(deftest runcmd-required-positional-missing
  (defcmd validate-pos [first second]
    [first second])

  (with-dyns [:args ["<bin>" "validate-pos" "a"]]
    (test-error (runcmd 'validate-pos)
                "Missing required argument \"second\"")))

# A required option that is missing must error.
(deftest runcmd-required-option-missing
  (defcmd validate-missing [--name name]
    name)

  (with-dyns [:args ["<bin>" "validate-missing"]]
    (test-error (runcmd 'validate-missing) "No value provided for option \"--name\"")))
