#!/usr/bin/env runhaskell
-- extract `@TODO: ...`
-- These take a few forms:
-- (@TODO: thing to do)
-- (@TODO thing to do)
-- @TODO rest of line (in all other cases, although it doesn't always make sense)
-- Note: probably doesn't make sense to do this with the AST, just use a regex!
-- \(@TODO[: ]{1,3}(.+)\)|(?<!`)@TODO[: ]{1,3}(.+)$ >> ([@TODO](#todo-section) ...) + a TODO section.
-- TODOS:
-- - failure when **@TODO**: the todo text is interpreted as what is in the bold only
-- - TODO in link text
-- - TODO in code blocks

import Text.Pandoc.JSON
import Text.Pandoc.Definition

-- Oh my God, Haskell has no regex substitute. How broken!
import qualified Data.Text as T

startmarker = "@TODOBLKJSDF"
endmarkertxt = "@ENDTODOBLKJSDF"
endmarker = Str endmarkertxt

-- THIS BIT DESIGNED TO WORK FOR `pandoc -f markdown-citations ...
-- ahh too bad, it works good, but then I have to run again to get the citations.
-- like so: pandoc -f markdown-citations --filter todo.hs -t markdown todo.md  | pandoc
-- chaining --filter pandoc-citeproc.hs after the --filter todo.hs don't work.
main = toJSONFilter findTodos
        where findTodos (Para x) = Para $ findTodosInline2 x
              findTodos (Plain x) = Plain $ findTodosInline2 x
              findTodos (Header i attr x) = Header i attr $ findTodosInline2 x
              findTodos (Table x algn dbl hd cls) = Table (findTodosInline2 x) algn dbl hd cls
              -- CodeBlock Attr String ; RawBlock Format String; BlockQuote [Block];
              -- OrderedList ListAttributes [[Block]]; BulletList [[Block]]; DefinitionList [([Inline], [[Block]])]
              -- Header Int [Inline]
              -- HorizontalRule
              -- Table [Inline caption] [Alignment] [Double] [TableCell headers] [[TableCell rows]]
              findTodos x = x

findTodosInline2 :: [Inline] -> [Inline]
findTodosInline2 (Str "(@TODO" : xs) = [Str ("(" ++ startmarker)] ++ (toLastBracket xs)
findTodosInline2 (Str "@TODO" : xs) = [Str startmarker] ++ xs ++ [endmarker]
findTodosInline2 (a:xs) = findInElement a : findTodosInline2 xs
findTodosInline2 [] = []

-- THE BELOW ONLY WORKS FOR `pandoc --filter=.. ...`, i.e. with `citations` enabled (even without `pandoc-citeproc`).
main2 = toJSONFilter findTodos
        where findTodos (Para x) = Para $ findTodosInline x
              findTodos (Plain x) = Plain $ findTodosInline x
              findTodos (Header i attr x) = Header i attr $ findTodosInline x
              findTodos (Table x algn dbl hd cls) = Table (findTodosInline x) algn dbl hd cls
              -- CodeBlock Attr String ; RawBlock Format String; BlockQuote [Block];
              -- OrderedList ListAttributes [[Block]]; BulletList [[Block]]; DefinitionList [([Inline], [[Block]])]
              -- Header Int [Inline]
              -- HorizontalRule
              -- Table [Inline caption] [Alignment] [Double] [TableCell headers] [[TableCell rows]]
              findTodos x = x


findTodosInline :: [Inline] -> [Inline]
-- (@TODO ... )
findTodosInline (Str "(" : (Cite [Citation "TODO" [] [] AuthorInText 0 0] [Str "@TODO"]) : xs) = [Str "(@TODOSTARTBRACKET"] ++  (toLastBracket xs)
-- @TODO <rest of line(/paragraph??)>
findTodosInline ((Cite [Citation "TODO" [] [] AuthorInText 0 0] [Str "@TODO"]) : xs) = [Str startmarker] ++  xs ++ [endmarker]
-- recursive (if the citation is no the first element, keep going)
findTodosInline (a:xs) = findInElement a : findTodosInline xs
findTodosInline [] = []

findInElement :: Inline -> Inline
findInElement (Emph x) = Emph $ findTodosInline2 x
findInElement (Strong x) = Strong $ findTodosInline2 x
findInElement (Strikeout x) = Strikeout $ findTodosInline2 x
findInElement (Superscript x) = Superscript $ findTodosInline2 x
findInElement (SmallCaps x) = SmallCaps $ findTodosInline2 x
findInElement (Quoted q x) = Quoted q $findTodosInline2 x
findInElement (Link x tgt) = Link (findTodosInline2 x) tgt
findInElement (Image x tgt) = Image (findTodosInline2 x) tgt
-- Note [Block] ?
findInElement x = x

-- inserts the endmarker at the last bracket
toLastBracket :: [Inline] -> [Inline]
toLastBracket x | length lastbits > 0 = firstbits ++ toadd ++ findTodosInline rest
    where (firstbits, lastbits) = (break (findBracket) x)
          rest | length lastbits > 0 = tail lastbits
               | otherwise = []
          (Str bckt) | length lastbits > 0 = head lastbits
          toadd | length lastbits > 0 = [replaceLastBracket bckt]
                | otherwise = []
toLastBracket x = x

findBracket :: Inline -> Bool
findBracket (Str s) = ')' `elem` s
findBracket x = False

-- replaces the last-occuring bracket with @ENDMARKER)
-- Stupid because Haskell doesn't seem to have regex substitute or substituteLast
replaceLastBracket (txt) = Str $ T.unpack $ T.concat [T.init f, T.pack endmarkertxt, T.singleton ')', l]
    where (f, l) = T.breakOnEnd (T.singleton ')') (T.pack txt)
