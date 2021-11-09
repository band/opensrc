#!/usr/bin/env python

# retrieve and print co2 trend values from NOAA
# all this to replace curl -q ftp://inFile > outFile
#   and tail, tr, grep, awk printf
# retrieve file from NOAA
# read the file, display data from the three lines we care about
#   read and store the data lines as a list of dictionaries
#   retrieve date on the last line
#   use that date to find the 1-year and 10-year old trend values
#   - on leap days only that day's value is printed
#   pretty print the info
# clean up: remove the downloaded file

import os
import re
import shutil
import urllib.request as request
from contextlib import closing

def build_datalist(datafile):
    dlist=[]
    with open(datafile, newline='') as f:
        for line in f:
            if re.search('^(?!.*#)', line):
                dlist.append(dict(zip(['year','month','day','cycle','trend'], line.split())))
    return dlist

def print_data(dlist):
    dr0 = dlist[len(dlist)-1]
    y, m, d  = dr0.get('year'), dr0.get('month'), dr0.get('day')
    print(f"Latest ({y}-{m.zfill(2)}-{d.zfill(2)}) \
average global co2 trend value (NOAA): {dr0.get('trend')}")

    for dr1 in [x for x in dlist \
                if (x.get('year') == str(int(y)-1) and x.get('month') == m and x.get('day') == d)]:
        print(f"One year ago \
({dr1.get('year')}-{dr1.get('month').zfill(2)}-{dr1.get('day').zfill(2)}) \
average global co2 trend value (NOAA): {dr1.get('trend')}")

    for dr10 in [x for x in dlist \
                 if (x.get('year') == str(int(y)-10) and x.get('month') == m and x.get('day') == d)]:
        print(f"Ten years ago \
({dr10.get('year')}-{dr10.get('month').zfill(2)}-{dr10.get('day').zfill(2)}) \
average global co2 trend value (NOAA): {dr10.get('trend')}")

    return

def main():

    try:
        with closing(request.urlopen('ftp://aftp.cmdl.noaa.gov/products/trends/co2/co2_trend_gl.txt')) as r:
            with open('co2_trend_gl.txt', 'wb') as f:
                shutil.copyfileobj(r, f)

        print_data(build_datalist('co2_trend_gl.txt'))
        os.remove('co2_trend_gl.txt')

    except Exception as e:
        traceback.print_exc(e)

if __name__ == "__main__":
    exit(main())

