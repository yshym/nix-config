# Matches a leading `#` and at most one following space, so help comments can
# be written either as `# text` or `#text`.
(def- help-comment-peg (peg/compile '(* "#" (between 0 1 " "))))

# Reads the leading run of `#` comment lines from a script's source.
(defn read-help [file]
  (if (nil? file)
    ""
    (let [f (file/open file :rn)]
      (defer (file/close f)
        (var line (file/read f :line))
        (if (nil? line)
          ""
          (do
            (unless (string/has-prefix? "#!/" line)
              (errorf "Not a script: %s" file))
            # Skip shebang — don't include it in help output.
            (set line (file/read f :line))
            (def lines @[])
            (while line
              (if (string/has-prefix? "#" line)
                (array/push lines (peg/replace help-comment-peg "" line))
                (break))
              (set line (file/read f :line)))
            (string/trim (string/join lines))))))))

# Wraps `read-help` and calls it at compile time, baking the result into the
# compiled binary as a string.
(defmacro help []
  (read-help (dyn :current-file)))

(def- *commands* @{})
(setdyn :parsed-args {:args @{} :opts @{}})

(defn option-name? [arg]
  (string/has-prefix? "-" arg))

(defn special-name? [arg]
  (def s (string arg))
  (or (= s "&opt") (= s "&")))

(defn argument-name [arg]
  (if (tuple? arg) (first arg) arg))

(defn argument-name? [arg]
  (def arg (if (tuple? arg) (first arg) arg))
  (and (not (option-name? arg))
       (not (special-name? arg))))

(defn bool-name? [arg]
  (string/has-suffix? "?" arg))

(defn make-arg [name optional? &opt type variadic?]
  (default type :string)
  (default variadic? false)
  {:name name :optional? optional? :type type :variadic? variadic?})

(defn make-opt [optional? &opt type]
  (default type :string)
  {:optional? optional? :type type})

(defn convert-to [value type]
  (case type
    :int  (int/s64 value)
    :bool (let [v (string/ascii-lower value)]
            (cond
              (find |(= $ v) ["true" "1" "on" "yes"]) true
              (find |(= $ v) ["false" "0" "off" "no"]) false
              (errorf "Invalid boolean value \"%s\"" value)))
    value))

# Builds argspec struct based on argument list
# :opts - @{<option-name> -> <requires-value>}
# :args - @[{:name <arg-name> :optional? <optional?>}]
(defmacro build-argspec [args]
  (with-syms [$argspec $cur-opt $after-opt? $variadic?]
    (def processed-args (map |(if (tuple? $) $ [$ nil]) args))
    ~(let [,$argspec ,(struct :opts @{} :args @[])]
       (var ,$cur-opt nil)
       (var ,$after-opt? false)
       (var ,$variadic? false)
       (each [arg arg-type] ',processed-args
         (cond
           # &opt -> following args are optional
           (= arg '&opt) (set ,$after-opt? true)
           # & -> next arg is the variadic collector (only one allowed)
           (= arg '&) (if ,$variadic?
                         (error "Multiple variadic collectors not allowed")
                         (set ,$variadic? true))
           # option -> remember option
           (option-name? arg) (set ,$cur-opt arg)
           # argument ->
           (cond
             # set option value requirement depending on the argument type
             (not (nil? ,$cur-opt)) (do
                                      (put-in ,$argspec [:opts ,$cur-opt] (make-opt (or (bool-name? arg) ,$after-opt?)
                                                                                    (if (bool-name? arg) :bool arg-type)))
                                      (set ,$cur-opt nil))
             # push argument to the list of arguments
             (do
               (when ,$variadic? (set ,$after-opt? true))
               (array/push (get ,$argspec :args) (make-arg arg ,$after-opt? arg-type ,$variadic?))))))
       ,$argspec)))

(defn get-required-args [args]
  (def required-args @[])
  (each arg args
    (if (get arg :optional?) (break))
    (array/push required-args (get arg :name)))
  required-args)

(defn- validate-args [argspec parsed-args]
  (def required-args (get-required-args (get argspec :args)))

  # Name the first required argument that did not receive a value.
  (def missing-arg
    (find |(nil? (get-in parsed-args [:args $])) required-args))
  (when missing-arg
    (errorf "Missing required argument \"%s\"" missing-arg))

  (eachp [name opt] (get argspec :opts)
    (def value (get-in parsed-args [:opts name]))
    (if (and (not (get opt :optional?)) (nil? value))
      (errorf "No value provided for option \"%s\"" name))))

(defn parse-args [argspec args]
  (def pos-args @{})
  (def opts @{})
  (var pos-arg-i 0)
  (var cur-opt nil)

  # Pre-initialize the variadic collector to an empty array
  (each spec (get argspec :args)
    (when (get spec :variadic?)
      (put pos-args (symbol (get spec :name)) @[])))

  (each arg args
    (cond
      # &opt -> the following arguments are optional
      (= arg '&opt) nil
      # option -> remember option if requires value
      #           otherwise set it to either `true` or `nil` depending on the type
      (option-name? arg) (do
                           # A pending value-requiring option cannot take another
                           # option as its value.
                           (when cur-opt
                             (def pending-type (get-in argspec [:opts (symbol cur-opt) :type]))
                             (unless (= pending-type :bool)
                               (errorf "Option \"%s\" requires a value" cur-opt)))
                           (def opt (get-in argspec [:opts (symbol arg)]))
                           (unless opt
                             (errorf "Unknown option \"%s\"" arg))
                           (if (get opt :optional?)
                             (do
                               (def value (if (= (get opt :type) :bool) true nil))
                               (put opts (symbol arg) value)))
                           (set cur-opt arg))
      # argument ->
      (if (nil? cur-opt)
        # add positional argument
        (do
          (def pos-arg (get (get argspec :args) pos-arg-i))
          (unless pos-arg
            (errorf "Too many arguments, unexpected \"%s\"" arg))
          (def arg-name (symbol (get pos-arg :name)))
          (def arg-type (get pos-arg :type))
          (def variadic? (get pos-arg :variadic?))
          (if variadic?
            # variadic: collect this and all remaining args into an array
            (array/push (get pos-args arg-name) (convert-to arg arg-type))
            (do
              (put pos-args arg-name (convert-to arg arg-type))
              (++ pos-arg-i))))
        # set option value
        (do
          (def opt-type (get-in argspec [:opts (symbol cur-opt) :type]))
          (put opts (symbol cur-opt) (convert-to arg opt-type))
          (set cur-opt nil)))))

  # Handle option as last argument: only boolean options can stand alone,
  # a value-requiring option left without a value is an error.
  (when cur-opt
    (def opt-type (get-in argspec [:opts (symbol cur-opt) :type]))
    (if (= opt-type :bool)
      (put opts (symbol cur-opt) true)
      (errorf "Option \"%s\" requires a value" cur-opt)))

  (def parsed {:args pos-args :opts opts})
  (validate-args argspec parsed)
  parsed)

(defn filter-pos-arg-names [args]
  (def arg-names @[])
  (each arg args
    # Handle arg type
    (def arg (if (tuple? arg) (first arg) arg))
    (cond
      (option-name? arg) (break)
      (argument-name? arg) (array/push arg-names arg)
      nil))
  arg-names)

(defn filter-opt-names [args]
  (def opt-names @[])
  (each arg args
    # Handle arg type
    (def arg (if (tuple? arg) (first arg) arg))
    (if (option-name? arg)
      (array/push opt-names arg)
      (argument-name? arg)))
  opt-names)

(defmacro cmdfn [args & body]
  (with-syms [$argbinds $optbinds]
    ~(fn []
       (def ,$argbinds ',(filter-pos-arg-names args))
       (def ,$optbinds ',(filter-opt-names args))
       (let [[,;(map |(argument-name $) (filter |(argument-name? $) args))]
             (tuple ;(map |(get-in (dyn :parsed-args) [:args $]) ,$argbinds)
                    ;(map |(get-in (dyn :parsed-args) [:opts $]) ,$optbinds))]
         ,;body))))

(defn save-command [name cmd]
  (put *commands* name cmd))

(defmacro defcmd [name args & body]
  (unless body
    (error "Missing command body"))
  (with-syms [$argspec]
    ~(let [,$argspec (build-argspec ,args)]
       (save-command ',name {:name ',name :argspec ,$argspec :fn (cmdfn [,;args] ,;body)}))))

(defn cmd [name]
  (get *commands* name))

# (dyn :args) is [program alias arg...]: index 1 is the command alias and
# command arguments start at index 2. These offsets are derived from one place
# so the alias lookup and the argument slice can never drift apart.
(def- alias-index 1)
(def- args-index 2)

(defn cmd-alias [&opt offset args]
  (default offset 0)
  (default args (dyn :args))
  (get args (+ alias-index offset)))

(defn cmd-args [&opt args]
  (default args (dyn :args))
  (array/slice args args-index))

(defn runcmd [name &opt args]
  (default args (dyn :args))
  (def cmd-entry (cmd name))
  (unless cmd-entry
    (errorf "Unknown command \"%s\"" name))
  (def argspec (get cmd-entry :argspec))
  (setdyn :parsed-args (parse-args argspec (cmd-args args)))
  ((get cmd-entry :fn)))

(defn commands []
  *commands*)

(defn- chunk [tup n]
  (var chunks @[])
  (var start 0)
  (def len (length tup))
  (while (< start len)
    (var end (min (+ start n) len))
    (array/push chunks (tuple/slice tup start end))
    (set start (+ start n)))
  chunks)

(defn dispatch [&opt rules args]
  (default args (dyn :args))
  (def alias-to-cmd (struct ;(mapcat (fn [[aliases cmd]] (mapcat |(tuple $ cmd) aliases))
                                     (chunk rules 2))))
  (def alias (keyword (cmd-alias 0 args)))
  (def cmd-name (get-in alias-to-cmd [(keyword alias) :name]))
  (if (nil? cmd-name)
    (errorf "Unknown command \"%s\"" alias))
  (runcmd (symbol cmd-name) args))
