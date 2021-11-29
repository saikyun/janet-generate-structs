(import ../import-c/import-c :as ic :fresh true)
(import ../import-c/cgen :fresh true)

(def src
  (cgen/ir-janet-str
    double-module
    (defn double_num [[arcg int32_t]
             [argv [* Janet]]]
      Janet
      (def x int (janet_getinteger argv 0))
      (janet_wrap_number (+ x x)))))

(ic/import-c* "double-module" src)

(assert (= 10 (double-module/double_num 5)))
