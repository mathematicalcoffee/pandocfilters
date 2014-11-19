#!/usr/bin/env python

from pandocfilters import toJSONFilter, BulletList, Str

def checkbox(key, value, format, meta):
    if key == 'BulletList':
        # I think value is an array of items
        return BulletList([tocheckbox(i) for i in value])

# i is a bulletlist Item (could be anything)
# e.g. [Para [Str "[", Space, Str "]", ...], Plain [Str "second", Space, Str "paragraph"]]
# e.g. [Plain [Str "[x]", ...]]
def tocheckbox(i):
    # only look at first item
    # something like Para [...], or Plain [...].
    #bit = i['c'][0]
    bit = i[0]
    if bit['t'] == 'Para' or bit['t'] == 'Plain':
        bit = bit['c'] # contents of the paragraph/plain, e.g. [Str "[x]", Space, Str "foobar"]
        if bit[0]['t'] == 'Str':
            # two cases 'c' == '[x]' or first 3 elts are '[', Space, ']'
            if bit[0]['c'] == '[x]':
                i[0]['c'][0]['c'] = u'\u2611 '
                # bit[0]['c'] = u'\u2611'
            elif len(bit) > 2 and bit[0]['c'] == '[' and bit[1]['t'] == 'Space' and bit[2]['t'] == 'Str' and bit[2]['c'] == ']':
                i[0]['c'] = [Str(u'\u2610 ')] + bit[3:]
                # bit = [Str(u'\u2610')] + bit[3:]

    return i

if __name__ == "__main__":
    toJSONFilter(checkbox)
