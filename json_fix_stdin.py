#!/usr/bin/env python
import sys
import json

# Read Json from STDIN
data = json.load(sys.stdin)



# for word in data['blocks']:
#     print(word)


for i in range(len(data['blocks'])):     # Go through each block, which is like a chunk of syntax
    block = data['blocks'][i]            # the current block
    block_type = block['t'] # data['blocks'][i]['t']    # what is the block i.e. math/raw/para
    if block_type=='RawBlock' and block['c'][0]=='latex':           # If it's raw and latex
        # block['c'] = block['c'][1]        # make the contents only the latex, not, a list saying it is type latex
        block['t'] = 'Para'               # Make the type just a paragraph of text
        math_content=block['c'][1]
        block['c']=[{
                    "t": "Str",
                    "c": math_content
                    }]

# print(data)
# You can't just print or json.dumps, python will print with single quotes
# json requires double quotes
# instead write to sys.stdout.
json.dump(data, sys.stdout)
# with open('/home/ryan/Sync/pandoc/file.json', 'w') as file:
#     json.dump(data, file)



sys.exit(0)