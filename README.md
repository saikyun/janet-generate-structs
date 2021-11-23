# janet-generate-structs
PoC for generating a bunch of C structs

Currently not possible to run as-is on other machines.

`trystuff.janet` -- uses jpm's cgen to generate code for structs, then allocates a bunch of them and renders them  \
`cgen.janet` -- copied and modified from jpm, functions to generate c-code  \
`import-c.janet` -- compiles and imports C libraries during runtime
