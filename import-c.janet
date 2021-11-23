(import spork/path)

(defn import-c*
  [module-name src &keys {:target target
                          :dir dir}]

  (default dir ".temp")

  (os/mkdir dir)

  (def target (and target
                   (string target path/sep)))
  (default target "")

  (def so-name (string target dir path/sep module-name "-" (hash src) ".so"))

  (unless (os/stat so-name)
    (spit (string target module-name ".c") src)

    (os/execute ["cc"
                 "-I" "/usr/local/include/janet"
                 "-shared"
                 "-fPIC"
                 "-o" so-name
                 (string target module-name ".c")
                 #"-lraylib"
                 "/usr/local/lib/janet/freja-jaylib.so"] :p))

  (import* (string "./" dir path/sep module-name "-" (hash src)) :as module-name))


(comment
  #
  (def c-src
    (string
      ``
  #include <janet.h>
  
  static Janet print_hello(int32_t argc, Janet *argv) {
    printf("hello\n");
    return janet_wrap_nil();
  }

  static const JanetReg cfuns[] = {
    {"print-hello", print_hello, ""},
    {NULL, NULL, NULL}
  };
  
  JANET_MODULE_ENTRY(JanetTable *env) {
    janet_cfuns (env, "hello", cfuns);
  }
  ``))

  (import-c* "hello" c-src)

  (hello/print-hello)
  #
)
