# janet-generate-structs
PoC for generating a bunch of C structs

No dependencies should be needed, but the C compilation currently only works on linux (ubuntu).

## dependencies for example `trystuff.janet`

- freja installed (doesn't work from source)

only tested on ubuntu

## try it

```
git clone https://github.com/saikyun/janet-generate-structs
freja trystuff.janet
```

Hit ctrl+l

You should now see a lot of noise.

## description

`trystuff.janet` -- uses jpm's cgen to generate code for structs, then allocates a bunch of them and renders them  \
`cgen.janet` -- copied and modified from jpm, functions to generate c-code  \
`import-c.janet` -- compiles and imports C libraries during runtime
