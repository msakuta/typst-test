# typst-test

A test repository to store [typst](https://typst.app/) source code examples and its products.

Check an example output PDF [here](https://github.com/msakuta/typst-test/blob/gh-pages/euler-lagrange.pdf), generated from [this source](euler-lagrange.typ)!

## How to build

Install [typst CLI](https://github.com/typst/typst).
I recommend installing it via cargo since it is the most cross-platform method:

    cargo install --git https://github.com/typst/typst

Build a source:

    typst compile euler-lagrange.typ

or run a watcher to hot update:

    typst watch euler-lagrange.typ

The output file will be produced with the name `euler-lagrange.pdf`