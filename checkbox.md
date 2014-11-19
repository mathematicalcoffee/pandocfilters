---
title: checkbox test
---

Run it like:

```
pandoc --filter ./checkbox.hs checkbox.md
```

A checkbox list:

* [ ] it's a bit slow, I've probably made inefficient code
* [ ] start of a paragraph

      second paragraph
* [x] done!
    - [ ] nested **checkbox**
    - [x] nested complete
    - non-checkbox item.
