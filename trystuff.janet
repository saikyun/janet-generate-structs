(import ./import-c :as ic :fresh true)
(import ./cgen :fresh true)

(def src
  (with-dyns [:out @""]
    (cgen/ir
      (@ include "<janet.h>")
      (@ include "<raylib.h>")

      (defn get_screen_width
        [[argc int32_t]
         [argv [* Janet]]]
        Janet
        (janet_wrap_number (GetScreenWidth)))

      (def [static const] "cfuns[]" JanetReg
        [array
         [array "get-screen-width" get_screen_width ""]
         [array NULL NULL NULL]])

      (inline
        ``
        JANET_MODULE_ENTRY(JanetTable *env) {
          janet_cfuns (env, "get-screen-width", cfuns);
        }
        ``)
      #
)
    (dyn :out)))

(print src)

(ic/import-c* "test" src :target "cgen")

(print "call: " (test/get-screen-width))
