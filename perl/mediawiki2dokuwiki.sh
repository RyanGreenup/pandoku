    #! /bin/sh
    # Mediawiki2Dokuwiki Converter
    # originally by Johannes Buchner <buchner.johannes [at] gmx.at>
    # License: GPL (http://www.gnu.org/licenses/gpl.txt)


#       perl -pe 's/^[ ]*=([^=])/<h6> ${1}/g' | \
#       perl -pe 's/([^=])=[ ]*$/${1} <\/h6>/g' | \
#       perl -pe 's/^[ ]*==([^=])/<h5> ${1}/g' | \
#       perl -pe 's/([^=])==[ ]*$/${1} <\/h5>/g' | \
#       perl -pe 's/^[ ]*===([^=])/<h4> ${1}/g' | \
#       perl -pe 's/([^=])===[ ]*$/${1} <\/h4>/g' | \
#       perl -pe 's/^[ ]*====([^=])/<h3> ${1}/g' | \
#       perl -pe 's/([^=])====[ ]*$/${1} <\/h3>/g' | \
#       perl -pe 's/^[ ]*=====([^=])/<h2> ${1}/g' | \
#       perl -pe 's/([^=])=====[ ]*$/${1} <\/h2>/g' | \
#       perl -pe 's/^[ ]*======([^=])/<h1> ${1}/g' | \
#       perl -pe 's/([^=])======[ ]*$/${1} <\/h1>/g' \
#       |
     
    # Headings
       perl -pe 's/^[ ]*=([^=])/<h6> /g' | \
       perl -pe 's/([^=])=[ ]*$/${1} /g' | \
       perl -pe 's/^[ ]*==([^=])/<h5> /g' | \
       perl -pe 's/([^=])==[ ]*$/${1} /g' | \
       perl -pe 's/^[ ]*===([^=])/<h4> /g' | \
       perl -pe 's/([^=])===[ ]*$/${1} /g' | \
       perl -pe 's/^[ ]*====([^=])/<h3> /g' | \
       perl -pe 's/([^=])====[ ]*$/${1} /g' | \
       perl -pe 's/^[ ]*=====([^=])/<h2> /g' | \
       perl -pe 's/([^=])=====[ ]*$/${1} /g' | \
       perl -pe 's/^[ ]*======([^=])/<h1> /g' | \
       perl -pe 's/([^=])======[ ]*$/${1} /g' \
       |
       
     
       perl -pe 's!<\/?h1>!*!g' | \
       perl -pe 's!<\/?h2>!**!g' | \
       perl -pe 's!<\/?h3>!***!g' | \
       perl -pe 's!<\/?h4>!****!g' | \
       perl -pe 's!<\/?h5>!*****!g' | \
       perl -pe 's!<\/?h6>!******!g' | \
     
    # lists
    # First Level Unordered Heading
    perl -pe 's/^[\ #]{2}\*/\ \ + /g' |\
    # Second Level Unordered Heading
    perl -pe 's/^[\ #]{4}\*/\ \ \ \ + /g' |\
    # Third Level Unordered Heading
    perl -pe 's/^[\ #]{6}\*/\ \ \ \ \ \ + /g' |\
    # Fourth Level Unordered Heading
    perl -pe 's/^[\ #]{8}\*/\ \ \ \ \ \ \ \ + /g' |\
    # Fifth Level Unordered Heading
    perl -pe 's/^[\ #]{10}\*/\ \ \ \ \ \ \ \ \ \ + /g' |\
    # Sixth Level Unordered Heading
    perl -pe 's/^[\ #]{12}\*/\ \ \ \ \ \ \ \ \ \ \ \ + /g' |\

    # First Level ordered Heading
    perl -pe 's/^[\ #]{2}\-/\ \ 1. /g' |\
    # Second Level ordered Heading
    perl -pe 's/^[\ #]{4}\-/\ \ \ \ 1. /g'  |\
    # Third Level ordered Heading
    perl -pe 's/^[\ #]{6}\-/\ \ \ \ \ \ 1. /g'  |\
    # Fourth Level ordered Heading
    perl -pe 's/^[\ #]{8}\-/\ \ \ \ \ \ \ \ 1. /g' |\
    # Fifth Level ordered Heading
    perl -pe 's/^[\ #]{10}\-/\ \ \ \ \ \ \ \ \ \ 1. /g'  |\
    # Sixth Level ordered Heading
    perl -pe 's/^[\ #]{12}\-/\ \ \ \ \ \ \ \ \ \ \ \ 1. /g' |\

    # Code
    perl -pe 's!<code\ rsplus>!#+BEGIN_SRC r!g' |\
    perl -pe 's!<code\ (.+)>!#+BEGIN_SRC $1!g' |\
    perl -pe 's!</code>!#+END_SRC $1!g' |\

    # Quotes
    # We have the luxury of expecting quotes to be only on one line,
    # Dokuwiki interpretes newlines as verbatim, this is a bit rough though.
    # Nah I'll
#    perl -pe 's!^>\ (.+)\n!#+begin_quote\n$1\n#+end_quote\n!g' |\
#    perl -pe 's!^>>\ (.+)\n!#+begin_quote\n\ \ #+begin_quote\n\ \ $1\n\ \ #+end_quote\n#+end_quote\n!g' |\
#    perl -pe 's!^>>>\ (.+)\n!#+begin_quote\n\ \ #+begin_quote\n\ \ \ \ #+begin_quote\n\ \ \ \ $1\n\ \ \ \ #+end_quote\n\ \ #+end_quote\n#+end_quote\n!g'


    #[link] => [[link]]
      perl -pe 's!\[\[(.*)\|![[${1}][!g'
      perl -pe 's/([^\[])\[([^\[])/${1}[[${2}/g' |
      perl -pe 's/^\[([^\[])/[[${1}/g' |
      perl -pe 's/([^\]])\]([^\]])/${1}]]${2}/g' |
      perl -pe 's/([^\]])\]$/${1}]]/g' \
      |
     
    #[[url text]] => [[url|text]]
      perl -pe 's/(\[\[[^| \]]*) ([^|\]]*\]\])/${1}|${2}/g' \
      |
     
    # bold, italic
      perl -pe "s/'''/**/g" |
      perl -pe "s/''/\/\//g" \
      |
     
    # talks
      perl -pe "s/^[ ]*:/>/g" |
      perl -pe "s/>:/>>/g" |
      perl -pe "s/>>:/>>>/g" |
      perl -pe "s/>>>:/>>>>/g" |
      perl -pe "s/>>>>:/>>>>>/g" |
      perl -pe "s/>>>>>:/>>>>>>/g" |
      perl -pe "s/>>>>>>:/>>>>>>>/g" \
      |
     
      perl -pe "s/<pre>/<code>/g" |
      perl -pe "s/<\/pre>/<\/code>/g" \
      
     

