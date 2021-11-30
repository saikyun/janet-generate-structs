(import ../import-c/import-c :as ic :fresh true)
(import ../import-c/cgen :as c :fresh true)

(def body
  ~[(@ include "<raymath.h>")

    ,(c/defnj
       lerp
       [[start float]
        [stop float]
        [v float]]
       float
       (Lerp start stop v))

    ,(c/defnj
       lerpp
       [[start float]
        [stop float]
        [v float]]
       void
       (printf "Lerp: %f\n" (Lerp start stop v)))])

(def src
  (c/ir-janet-str*
    "raymath"
    body))

(print)
(print src)
(print)

(ic/import-c* "raymath" src)

(pp (raymath/lerp 5 10 0.5))

(pp (raymath/lerpp 5 10 0.5))
#

