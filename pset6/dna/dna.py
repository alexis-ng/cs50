from sys import argv
from collections import OrderedDict
import csv
import copy
import re
import unittest


if len(argv) != 3:
    print("Try again")
    exit(1)

dnalist = []
# reads dna list
with open(argv[1], newline="") as csvfile:
    data = csv.DictReader(csvfile)
    # dat = data.read()
    for row in data:
        dnalist.append(row)

# takes in header
for row in dnalist:
    key = list(row.keys())
    key.remove("name")
    # print(key)
    break

# reads dna sequence
sequence = open(argv[2], "r")
seq = sequence.read()

# counts the occurances of a key
STR = OrderedDict()
# print(seq[0:len(key)])
for k in key:
    count = 1
    match_pos = []
    counts = []
    # for match in re.finditer(key[i], seq):
    matches = re.finditer(k, seq)
    for match in matches:
        match_pos.append(match.start())
        # print(f"{k}: {match_pos}")
        # print(f"{k}: {seq[match_pos[-1]-len(k): match_pos[-1]]}")
        # checks if consecutive
        if (k == seq[match_pos[-1]-len(k): match_pos[-1]]) and (k == seq[match_pos[-1]: match_pos[-1]+len(k)]):
            count += 1
            counts.append(match_pos[-1])

        if len(counts) > 1:
            if (counts[-1] - counts[0]) % len(k) != 0:
                count -= 1

            if (match_pos[-1] - match_pos[-2]) > len(k):
                break

        # print(f"{k}: {count}: {seq[match_pos[-1]-len(k): match_pos[-1]]} - {seq[match_pos[-1]: match_pos[-1]+len(k)]}")
        # print(match_pos[-1])
        # if len(match_pos) > 1:
        #     print(match_pos[-2])
        # if len(match_pos) > 2:
        #     print(match_pos[-3])
        # print(len(counts))
        # print()
        # # print(f"{k}: )
        # print(f"{k}: {match_pos}")
    STR[k] = str(count)

# print(STR)
# print()

for keys in dnalist:
    name = keys.pop('name')
    if keys == STR:
        print(name)
        exit(0)
        # print()
    else:
        continue

print("No match")

