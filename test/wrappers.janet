(import ../import-c/import-c :as ic :fresh true)
(import ../import-c/cgen :fresh true)


(def src
  (cgen/ir-janet-str*
    'double-module
    [(cgen/defnj
       double_num
       [[x float]]
       float
       (+ x x))]))

(ic/import-c* "double-module" src)

(assert (= 10 (double-module/double_num 5)))
