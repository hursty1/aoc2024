#%%
import io
import pandas as pd
import csv
import math
left = []
right = []


with open('data.csv', newline='') as f:
    csvread = csv.reader(f, delimiter=' ')
    for line in csvread:
        left.append(line[0])
        right.append(line[-1])
# %%
print(left)
# %%
running_total = 0
# %%
for i in range(0, len(left)):
    running_total += int(left[i]) * right.count(left[i])
    print(int(left[i]) * right.count(left[i]))
# %%
print(running_total)
# %%
