#! C:\Users\yurts\AppData\Local\Microsoft\WindowsApps\python3.exe

import sys
import re

lines = []
for line in sys.stdin:
    lines.append(line)

def natural_sort( l ): 
    alphanum_key = lambda key: int(key.split('\t')[0])
    return sorted(l, key = alphanum_key, reverse=True)

try:
    for line in natural_sort(lines):
        sys.stdout.write(line)
except IOError as e:
    pass