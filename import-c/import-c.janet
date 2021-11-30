(import spork/path)

(defn import-c*
  [module-name src &keys {:target target
                          :dir dir}]

  (def hostos (os/which))
  (def iswin (= :windows hostos))
  (def win-prefix (os/getenv "JANET_WINDOWS_PREFIX"))
  (def prefix (dyn :prefix (os/getenv "JANET_PREFIX" (os/getenv "PREFIX" "/usr/local"))))

  (def headerpath (dyn :headerpath (os/getenv "JANET_HEADERPATH" (if win-prefix
                                                                   (string win-prefix "/C")
                                                                   (string prefix "/include/janet")))))

  (def cc (if iswin "cl.exe" "cc"))

  (def dynamic-cflags (case hostos
                        :windows @["/LD"]
                        @["-fPIC"]))
  (def dynamic-lflags (case hostos
                        :windows @["/DLL"]
                        :macos @["-shared" "-undefined" "dynamic_lookup" "-lpthread"]
                        @["-shared" "-lpthread"]))

  (default dir ".temp")

  (os/mkdir dir)

  (def target (and target
                   (string target path/sep)))
  (default target "")

  (def so-name (string target dir path/sep module-name "-" (hash src) ".so"))

  (unless (os/stat so-name)
    (spit (string target module-name ".c") src)

    (os/execute [cc # "cc"
                 "-I" headerpath
                 ;dynamic-cflags
                 "-o" so-name
                 (string target module-name ".c")
                 ;dynamic-lflags
                 ### using freja from source, or just using janet, you need the below row
                 #"/usr/local/lib/janet/freja-jaylib.so"
                 # or with janet you can just do
                 #"-lraylib"
] :p))

  (import* (string "/" dir path/sep module-name "-" (hash src)) :as module-name))


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
