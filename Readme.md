Some pandoc filters, in haskell or python (whichever I was trying to learn).

Only just started learning Haskell but am trying to favour it for the filters (since pandoc is Haskell), but code is pretty raw.

Usage:

```
pandoc --filter path/to/filter  intputfile
```

In python, an element is like this:

```
{'t': (type, e.g. 'Str'), 'c': (content)}
```

## Checkbox

File: `checkbox.{py, hs}`

```
pandoc --filter ./checkbox.hs checkbox.md
```

Convert github-style checkbox lists by replacing the `[ ]` and `[x]` with unicode U+2610 and U+2611 resp (&#x2610; and &#x2611;).

Todo:

* I don't have the font in Chrome so they don't render right. Replace with format-specific (e.g. HTML checkbox, latex tickmark)
