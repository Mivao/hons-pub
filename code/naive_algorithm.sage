import csv
import time
import re

start_time = time.time()

data_points = []
with open('data_points.txt') as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=',')
    for row in csv_reader:
        new_point = ()
        for x in row:
            num_x = int(x)
            new_point = new_point + (num_x,)
        data_points = data_points + [new_point]

default_points = [(3,0),(2,1),(1,2),(0,3),(-1,1),(-2,-1),(-3,-3),(-1,-2),(0,0),(1,-1)]

if data_points == []:
    data_points = default_points

vertex_sets = powerset(data_points)
sets_without_zero = []

zero = (0,)*dimension

for v in vertex_sets:
    check_poly = Polyhedron(vertices = v)
    if check_poly.contains(zero) == False:
        sets_without_zero +=[v]

maximal_sets = []

for v in sets_without_zero:
    contained = False
    for w in sets_without_zero:
        if v != w:
            if set(v).issubset(w):
                contained = True
                break
    if contained == False:
        maximal_sets += [v]

print("--- %s seconds ---" % (time.time() - start_time))