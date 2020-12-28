#! /usr/bin/env bash
#
## Author: Ryan Greenup <ryan.greenup@protonmail.com>

# * Shell Settings
set -o errexit  # abort on nonzero exitstatus
set -o nounset  # abort on unbound variable
set -o pipefail # don't hide errors within pipes
DOKUWIKI_DIR="/srv/http/dokuwiki"
PHP () { php ; }


# * Main Function
main() {
    setVars
    arguments  "${@:-}" # Pass empty string if arguments are empty

}

# ** Helper Functions

# *** Set variables almost globally

setVars () {
    readonly script_name=$(basename "${0}")
             script_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
    readonly script_dir=$(realpath "${script_dir}""/""${script_name}" | xargs dirname)
    IFS=$'\t\n'   # Split on newlines and tabs (but not on spaces)
    cd "${script_dir}"
}

# *** Interpret arguments
arguments () {
    while test $# -gt 0
    do
        case "$1" in
            --help) Help
                ;;
            from) shift; from "${@:-}"
                ;;
            to)   shift; to "${@:-}"
                ;;
            to_alt)   shift; to "${@:-}"
                ;;
            --*) echo "bad option "${1}" in "${script_name}""
                ;;
            *) echo -e "argument \e[1;35m${1}\e[0m has no definition."; Help
                ;;
        esac
        shift
    done
}

# *** --> Dokuwiki <-- To the specified format from dokuwiki
function to() {

    if [[ "${1}" == "pdf" ]]; then
    # To go into PDF this function will add a style sheet
         pdf
    elif [[ "${1}" == "org" ]]; then
        pandoc -f dokuwiki -t org
    else
            php ./dokuwiki/bin/render.php |\
            pandoc -f html+raw_tex+tex_math_single_backslash+tex_math_dollars -t "${@:-}"
    fi

}

# This uses only pandoc via org-mode rather than the parser.
function to_alt() {
        pandoc -f dokuwiki -t org | \
        cat - <(echo "#+OPTIONS: H:6") |\
        pandoc -f org -t "${@:-}"
}
# *** <-- Dokuwiki --> From Specified format into dokuwiki
function from() {
    # For org mode make sure that the heading levels option is set
    if [[ "${1:-}" == "org" ]]; then
        cat - <(echo "#+OPTIONS: H:6") | \
        pandoc -f "${@:-}"   \
            -t dokuwiki --filter ./dokuwiki_math_raw_filter.py
        exit 0
    fi

    # For everything else just use the filter
    pandoc -f "${@:-}" \
        -t dokuwiki --filter ./dokuwiki_math_raw_filter.py
}

# *** Alt pathway from specified format into dokuwiki
function from_alt() {
    pandoc -f "${@:-}" \
        -t json | ./json_fix_stdin.py | pandoc -f json -t dokuwiki
}



# **** Make PDF file
function pdf() {

    FILE="$(mktemp)"

echo '
\RequirePackage{listings}
\RequirePackage{listings}
%Listings----------------------------------------


\definecolor{dkgreen}{rgb}{0,0.6,0}
\definecolor{gray}{rgb}{0.5,0.5,0.5}
\definecolor{mauve}{rgb}{0.58,0,0.82}
\lstset{
  frame=tb,
  frame=leftline,
  framesep=15pt,
  language=Java,
  aboveskip=15pt,
  belowskip=20pt,
  showstringspaces=false,
  columns=flexible,
  basicstyle={\small\ttfamily},
  numbers=none,
%  backgroundcolor=\color{Snow2},
  numberstyle=\tiny\color{gray},
  keywordstyle=\color{blue},
  commentstyle=\color{dkgreen},
  stringstyle=\color{mauve},
  breaklines=true,
  breakatwhitespace=true,
  tabsize=3,
  xleftmargin=1in,
}
' > "${FILE}.sty"

        pandoc -f dokuwiki -t html | \
        pandoc -f html+tex_math_dollars+tex_math_single_backslash -t html --mathjax -s | \
        pandoc -f html -t org | \
        pandoc -f org --pdf-engine=xelatex -H "${FILE}.sty" --listings -o "${FILE}.pdf" | \
        xdg-open "${FILE}.pdf" & disown

        exit 0
}
# *** Print Help

Help () {
        # Display Help
    echo
    echo -e "    \e[3m\e[1m    Pandoc Dokuwiki Helper \e[0m; Make Pandoc work with Dokuwiki"
    echo -e "    \e[1;31m -------------------------\e[0m "
    echo
    echo -e "This script acts as a helper for pandoc to work with dokuwiki"
    echo
    echo -e " \e[1;91m    \e[1m command \e[0m\e[0m \e[1;34m    ┊┊┊ \e[0m Description "
    echo -e " ..............\e[1;34m    ┊┊┊\e[0m........................................... "
    echo -e " \e[1;93m     from FORMAT \e[0m \e[1;34m┊┊┊ \e[0m Convert into dokuwiki from a given format"
    echo -e " \e[1;32m     to FORMAT \e[0m \e[1;34m  ┊┊┊ \e[0m Convert Dokuwiki into a given format"
    echo -e " \e[1;32m to_alt FORMAT \e[0m \e[1;34m  ┊┊┊ \e[0m Convert Dokuwiki into a given format using JSON *"
    echo
    echo "using 'to pdf' will add a custom style as well."
    echo
    echo "* The 'to' method uses py pandoc filters, in the event that this stops working"
    echo "  the to_alt method instead edits the pandoc json to make everything work."


        exit 0
}

# * Call Main Function
main "${@:-}"
