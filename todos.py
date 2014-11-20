#! /usr/bin/env python

import sys
import.re

fn = sys.argv[1]
if not f:
    fn = "/dev/stdin"

# Bah: if the TODO is in a caption, we don't want to go beyond that caption
#  that's something that Pandoc did good.
todoregex = re.compile('\(@TODO[: ]{1,5}(.*)\)|@TODO')
with open(fn) as f:
    for line in f:
        # ...
