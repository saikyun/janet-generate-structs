(import ./import-c :as ic :fresh true)
(import ./cgen :fresh true)

(def src
  (with-dyns [:out @""]
    (cgen/ir
      (@ include "<janet.h>")
      (@ include "<raylib.h>")
      (@ include `"types.h"`)
      #(@ include "\"../../freja-jaylib/src/types.h\"")

      (deft Tile [struct
                  x int
                  y int
                  color Color])

      (def [static const] AT_Tile JanetAbstractType
        [array "freja/tile"
         JANET_ATEND_NAME])

      (deft TileHolder [struct
                        tiles Tile**
                        size size_t
                        used size_t])

      (def [static const] AT_TileHolder JanetAbstractType
        [array "freja/tile-holder"
         JANET_ATEND_NAME])

      (defn create_tile
        [[argc int32_t]
         [argv [* Janet]]]
        Janet
        (def box Tile* (janet_abstract &AT_Tile (sizeof Tile)))
        (set box->y (janet_getinteger argv 0))
        (set box->x (janet_getinteger argv 1))
        (set box->color (jaylib_getcolor argv 2))
        (janet_wrap_abstract box))

      (defn create_tile_holder
        [[argc int32_t]
         [argv [* Janet]]]
        Janet
        (def box TileHolder* (janet_abstract &AT_TileHolder (sizeof TileHolder)))
        (def n int (janet_getinteger argv 0))
        (set (-> box tiles) (malloc (* n (sizeof Tile*))))
        (set (-> box size) n)
        (set (-> box used) 0)
        (janet_wrap_abstract box))

      (defn insert_tile_holder
        [[argc int32_t]
         [argv [* Janet]]]
        Janet
        (def th TileHolder* (janet_getabstract argv 0 &AT_TileHolder))

        (def t Tile* (janet_getabstract argv 1 &AT_Tile))

        (if (== (-> th used) (-> th size))
          (do
            (set (-> th size) (* 2 (-> th size)))
            (set (-> th tiles) (realloc (-> th tiles) (* (-> th size) (sizeof Tile*))))))

        (def t2 Tile* (malloc (sizeof Tile)))
        (set t2->y t->y)
        (set t2->x t->x)
        (set t2->color t->color)

        (set (index (-> th tiles) (-> th used)) t2)
        (++ (-> th used))

        (janet_wrap_abstract th))

      (defn render_tile_holder
        [[argc int32_t]
         [argv [* Janet]]]
        Janet
        (def th TileHolder* (janet_getabstract argv 0 &AT_TileHolder))

        (def i int 0)

        (def size int 1)

        (while (< i 1000)
          (do
            (def t Tile* (index (-> th tiles) i))
            (if (and (< (-> t x) 100)
                    (< (-> t y) 100))
              (DrawRectangle (* size (-> t x))
                             (* size (-> t y))
                             size
                             size
                             (-> t color)))
            (++ i)))

        (janet_wrap_nil))

      (defn print_tile
        [[argc int32_t]
         [argv [* Janet]]]
        Janet
        (def t Tile* (janet_getabstract argv 0 &AT_Tile))
        (janet_wrap_number [-> t x]))

      (defn render_tile
        [[argc int32_t]
         [argv [* Janet]]]
        Janet
        (def t Tile* (janet_getabstract argv 0 &AT_Tile))

        (DrawRectangle (* 100 (-> t x))
                       (* 100 (-> t y))
                       100
                       100
                       (-> t color))

        (janet_wrap_nil))

      (defn get_screen_width
        [[argc int32_t]
         [argv [* Janet]]]
        Janet
        (janet_wrap_number (GetScreenWidth)))

      (def [static const] "cfuns[]" JanetReg
        [array
         [array "get-screen-width" get_screen_width ""]
         [array "create-tile" create_tile ""]
         [array "create-tile-holder" create_tile_holder ""]
         [array "insert-tile-holder" insert_tile_holder ""]
         [array "render-tile-holder" render_tile_holder ""]
         [array "print-tile" print_tile ""]
         [array "render-tile" render_tile ""]
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

#(doc "test/")

(print "call: " (test/get-screen-width))
(def th (test/create-tile-holder 100))
(loop [x :range [0 10000]
       y :range [0 5000]
       :let [t (test/create-tile x y [(math/random) (math/random) (math/random)])]]
  (test/insert-tile-holder th t))

(use freja/flow)

(defn render2
  [_]
  #(rl-pop-matrix)
  #(rl-load-identity)
  (test/render-tile-holder th)
  #  (draw-rectangle 100 100 100 100 :red)
  #  (test/render-tile t)
  #(rl-push-matrix)
)

(start-game {:render render2})
