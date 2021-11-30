(import ../import-c/import-c :as ic :fresh true)
(import ../import-c/cgen :fresh true)

(def src
  (cgen/ir-janet-str
    "raymath"
    (@ include "<raymath.h>")

    (defn lerp [[argc int32_t]
                [argv [* Janet]]]
      Janet
      
      (janet_wrap_number (Lerp (janet_getnumber argv 0)
                               (janet_getnumber argv 1)
                               (janet_getnumber argv 2))))))

(ic/import-c* "raymath" src)

(pp (raymath/lerp 5 10 0.5))
