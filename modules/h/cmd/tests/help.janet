# Tests for `read-help`.

(use judge)
(use ..)

(deftest read-help-nil
  (test (read-help nil) ""))

(deftest read-help-missing-file
  # file/open raises on a missing path; the message comes from the runtime.
  (test-error (read-help "/tmp/h-cmd-definitely-missing.janet")
              "failed to open file /tmp/h-cmd-definitely-missing.janet: No such file or directory"))

(deftest read-help-not-a-script
  (spit "/tmp/h-cmd-not-script.janet" "(print :hi)\n")
  (defer (os/rm "/tmp/h-cmd-not-script.janet")
    (test-error (read-help "/tmp/h-cmd-not-script.janet")
                "Not a script: /tmp/h-cmd-not-script.janet")))

(deftest read-help-comments
  (spit "/tmp/h-cmd-script.janet"
        "#!/usr/bin/env janet\n# Usage: thing CMD\n#\n# does stuff\n(print :body)\n")
  (defer (os/rm "/tmp/h-cmd-script.janet")
    (test (read-help "/tmp/h-cmd-script.janet")
          "Usage: thing CMD\n\ndoes stuff")))
