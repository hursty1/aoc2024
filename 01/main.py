import io
import pandas as pd
import csv
import math
left = []
right = []


with open('01/data.csv', newline='') as f:
    csvread = csv.reader(f, delimiter=' ')
    for line in csvread:
        left.append(line[0])
        right.append(line[-1])

print( len(left) == len(right))
print(len(left))

left.sort()
right.sort()

running_total = 0
for i in range(0, len(left)):
    running_total+= abs(int(left[i]) - int(right[i]))

print(running_total)