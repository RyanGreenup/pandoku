#!/bin/bash

# * Headings

sd '^====== (.*) ======\n' '* $1\n'      |\
sd  '^===== (.*) =====\n'  '** $1\n'     |\
sd   '^==== (.*) ====\n'   '*** $1\n'    |\
sd    '^=== (.*) ===\n'   '**** $1\n'    |\
sd     '^== (.*) ==\n'    '***** $1\n'   |\
sd      '^= (.*) =\n'      '****** $1\n' |\

# * Font
# space followed by a bold **word** followed by a space or punctuation
sd ' \*\*([a-zA-Z0-9]+)\*\*([\s,.])' ' *$1*$2 ' |\
# sed -e 's/\ __([a-zA-Z0-9]+)__([\s,\.])/\ \1 //g' |\
perl -pe 's/__/ll/g'
sd ' //([a-zA-Z0-9]+)//([\s,.])' ' /$1/$2 '
# sd -s ' **(\w)** ' ' *$1* '
# sd ' //(\w)// ' ' /$1/ ' |\
# sd ' __(\w)__ ' ' _$1_ '
