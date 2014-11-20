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

## Some Other Examples

Here are some repositories I found with Haskell pandoc filters to look at:

* https://github.com/aphorisme/AphoFilters/blob/master/src/Text/Pandoc/AphoFilters/MathThm.hs
  - Replaces LaTeX code blocks with attributes "descr", "env" with the corresponding LaTeX environment e.g. `\begin{theorem}[description]`
  - Pretty neatly done - nice example.
* https://github.com/kisonecat/ximera-pandoc-filter
  - Check out [Ximera](http://ximera.osu.edu/) which appears to take TeX code and convert it into an online interactive activity (with hints and solutions)
  - this filter ... is quite complicated. It might convert a document to ximera-format including drawing/uploading pictures (?). The efunction `mergeAdjacent` may be of interest to me.
* https://gist.github.com/crzysdrs/11414475
  - splits on end of sentences (?) using regex
* https://github.com/lyokha/styleFromMeta
  - define some HTML/LaTeX code that you want to be used for images, links or some paragraphs and it will do that instead of whatever Pandoc does by default.
* https://github.com/Davorak/PandocFilters/tree/master/filters
  - `pandocCmdFilter`: replaces a code block with attribute `cmdBlock="<command>"` with the result of running `<command>`, and various formatting options.
  - `pandocDiagramFilter`: replaces code block with class "diagram" with the image caused by running the haskell code in the block (?)
  - `pandocDotFilter`: replaces a code block with the `showDot` or `showDotCode` class with the image produced by running `dot` (diagram drawer) on the code contained (?)
* https://github.com/jgm/pandoc-highlight/blob/master/Text/Pandoc/Highlighting.hs
  - filter (library, I think) for using pandoc with highlighting-kate
* https://github.com/balachia/pandoc-filters
  - `pandoc-internalref`: adds labels/ids to images (if specified in a particular way) in order to be able to link back to them.
  - `pandoc-dropinenv` (filter) with `pandoc-postprocess` (script): replaces one environment with another environment (?), particularly `figure` -> `sidewaysfigure`.
* https://github.com/boisgera/ext-pandoc
  - `tex_filter`: converts a latex `RawBlock` to a HTML RawBlock (same with Inline tex to HTML). `RawBlock` are blocks of embedded LaTeX code (or HTML code), e.g. if I had `\eqref{..}` in my text it would be `RawInline`. For use with MathJax (?).
  - `patch_html`: adds (modifies?) the mathjax script header to a HTML document (they wanted different configuration to what Pandoc puts in)
* https://github.com/kbonne/pandoc-plantuml-filter
  - Replaces (`CodeBlock`s with the `plantumuml` class), with PlantUML-generated diagrams.

Here is a repository with Python pandoc filters:

* https://github.com/jgm/pandocfilters

## Filters in this repository

### Checkbox

File: `checkbox.{py, hs}`

```
pandoc --filter ./checkbox.hs checkbox.md
```

Convert github-style checkbox lists by replacing the `[ ]` and `[x]` with unicode U+2610 and U+2611 resp (&#x2610; and &#x2611;).

Todo:

* I don't have the font in Chrome so they don't render right. Replace with format-specific (e.g. HTML checkbox, latex tickmark)


### Todo

Extracts all TODOs from the document (syntax: `(@TODO stuff to do)` or `@TODO <rest of line>`) and creates an index of them, along with a link from each `TODO` marker in the text to its entry in the index.
