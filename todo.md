Here is an example with the `@TODO` tag embedded. Note that the verbatim `@TODO` should not be added.
However we will permit `@TODO` in code blocks, like so:

```
code to do stuff # @TODO: blah
```

And a TODO in a quote:

> @TODO or not to do, that is the question.
>
> and a second paragraph.

Thinks like this (@TODO find a reference) or that (@TODO: find another reference).

We should also ensure that TODOs inside other inlines (like SmallCaps, Subscript, Strong, Note(footnote)) are handled: **bold text (@TODO do stuff)**.
Sometimes I also bold the TODO for emphasis like this (**@TODO**: make sure we handle this).

And ensure that a [@TODO in link text](http://todo.com) is handled.

In the absence of the brackets, I guess we shall just grab everything from the marker to the end.

We want to produce:

* a table with the `@TODO` text (@TODO: a checkbox list?)
* a link to the location the todo occurs
* probably some idea of the context in which the TODO occured.
* @TODO something to do.

What is the "rest of the line"?

We also need to get there before pandoc-citeproc does (or do we?)

Here's a trick @TODO with an opening but no closing bracket.

And finally, a reference (@McLachlan2000).
