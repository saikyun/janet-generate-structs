# janet-generate-structs
PoC for generating a bunch of C structs

## dependencies

- freja installed (doesn't work from source)
- *nix

## try it

```
git clone https://github.com/saikyun/janet-generate-structs
freja trystuff.janet
```

Hit ctrl+l

## description

`trystuff.janet` -- uses jpm's cgen to generate code for structs, then allocates a bunch of them and renders them  \
`cgen.janet` -- copied and modified from jpm, functions to generate c-code  \
`import-c.janet` -- compiles and imports C libraries during runtime
