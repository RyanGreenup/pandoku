#!/usr/bin/env python

"""
Pandoc filter to convert all level 2+ headings to paragraphs with
emphasized text.
"""

from pandocfilters import toJSONFilter, Emph, Para

def raw_to_para(key, value, format, meta):
  if key == 'RawBlock' and value[0] == 'latex':
    math_content = value[1]
    math_value=[{
            "t": "Str",
            "c": math_content
                }]

    return Para(math_value)

if __name__ == "__main__":
  toJSONFilter(raw_to_para)