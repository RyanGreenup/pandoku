#!/usr/bin/env python

import sys, getopt, json, os, subprocess
import argparse

def main(argv):
    args = get_args(argv)
    input=test_input(args)
    convert_file(args.f, args.t, input)
    


def get_args(argv):
    my_parser = argparse.ArgumentParser()
    my_parser.add_argument('-f', '--from', action='store', type=str, required=True, dest='f', help="Input Format")
    my_parser.add_argument('-t', '--to', action='store', type=str, required=True, dest='t', help ="Output Format")
    my_parser.add_argument('-i', '--input', action='store', type=str, required=False, dest='i', help ="Input File (Unused if STDIN)")

    args = my_parser.parse_args()
    return args

def test_input(args):
    if not sys.stdin.isatty(): # redirected from file or pipe
        if args.i is not None:
            print("Error! Provide only STDIN or Input File, not both.")
            sys.exit(1)
        stdin_data = sys.stdin.read()
        return(stdin_data)
    else:
        stdinQ = False
        if args.i is None:
            print("Error Provide either input with -i or pipe STDIN")
            sys.exit(1)
        with open(args.i, 'r') as file:
            in_data = str(file.read())
        return in_data

def convert_file(f, t, i):
    if t=="dokuwiki":
        if f=="org":
            i+=str('\n#+OPTIONS: H:6')
        subprocess.run(["pandoc", "-f", f, "-t", t, "--filter", "./dokuwiki_math_raw_filter.py"], input=str(i).encode())
    if f=="dokuwiki":
        # subprocess.run(["pandoc", "-f", "dokuwiki", "-t", "html", "|", "pandoc", "-f", "html", "-t", t], input=str(i).encode(), shell=True)
        dw2ht_command = "pandoc -f dokuwiki -t html"
        dw2ht_command=dw2ht_command.split(' ')
        ht2out_command = "pandoc -f html+tex_math_dollars+tex_math_single_backslash --mathjax, -t"+t
        ht2out_command = ht2out_command.split(' ')

        subprocess.run(["pandoc", "-f", f, "-t", "html", "|", "pandoc", "-f", "html+tex_math_dollars+tex_math_single_backslash", "-t", t], input=str(i).encode(), shell=True)

if __name__ == "__main__":
   main(sys.argv[1:])