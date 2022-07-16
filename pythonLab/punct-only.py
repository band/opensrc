#!/usr/bin/env python

import argparse
import string
import traceback

from pathlib import Path

# set up argparse
def init_argparse():
    parser = argparse.ArgumentParser(description='print punctuation only from text file')
    parser.add_argument('--filename', '-f', required=True, help='name of plain text or markdown file')
    return parser

def main():
    try:
        argparser = init_argparse()
        args = argparser.parse_args()

        file_text = (Path.cwd() / args.filename).read_text()
        trans_dict={char: '' for char in (string.ascii_letters + string.digits + string.whitespace)}
        table=file_text.maketrans(trans_dict)

        print(file_text.translate(table))

    except Exception as e:
        traceback.print_exc(e)

if __name__ == "__main__":
    exit(main())


