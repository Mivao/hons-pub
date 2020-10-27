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

min_x = 10000000
for y in data_points:
    if y[0] < min_x:
        min_x = y[0]

entry = min_x - 1
print(entry)

point_poly = Polyhedron(vertices = data_points)
center = point_poly.center()
dimension = len(data_points[0])
number_tuple = (entry,-1)
zero_tuple = (0,)*(dimension - 1)
zero = (0,)*dimension
default_half = number_tuple + zero_tuple

regex_string = '\(' + '([-]?[0-9]+), '*(dimension - 1) + '([-]?[0-9]+)\)'
tuple_regex = re.compile(regex_string)

testing = Polyhedron(ieqs = [default_half])
points_in_testing = []
for x in data_points:
    if testing.contains(x):
        points_in_testing +=[x]

print(points_in_testing)

check_list = [default_half]

i = 0
maximal_halves = []
while i < len(check_list):
    new_planes = []
    poly_points = []
    current_half = check_list[i]
    poly_to_check = Polyhedron(ieqs = [current_half])
    for y in data_points:
        if poly_to_check.contains(y):
            poly_points +=[y]
    for y in data_points:
        if not poly_to_check.contains(y):
            new_poly = Polyhedron(vertices = (poly_points + [y]))
            new_halves = new_poly.Hrepresentation()
            j = 0
            while j < len(new_halves):
                h = new_halves[j]
                if h.is_inequality():
                    check_half = Polyhedron(ieqs = [h])
                    if not check_half.contains(zero):
                        new_planes = new_planes + [h]
                else:
                    new_ineq = Polyhedron(ieqs = [tuple(h.vector())]).Hrepresentation()
                    new_halves = new_halves + new_ineq
                    new_ineq = Polyhedron(ieqs = [tuple(-1 * (h.vector()))]).Hrepresentation()
                    new_halves = new_halves + new_ineq
                j += 1
    if new_planes == []:
        maximal_halves = maximal_halves + [current_half]
    for h in new_planes:
        if h not in check_list:
            check_list = check_list + [h]
    i += 1

number_list = []
bad_ineqs = []
j = 0
for h in maximal_halves:
    ieq_regex = tuple_regex.search(str(h))
    ieq_tuple = ieq_regex.groups()
    ieq_list = list(ieq_tuple)

    k = len(ieq_list)
    m = k/3
    ieq_list_1 = []
    ieq_list_2 = []
    ieq_list_3 = []

    i = 0

    while i < m:
        ieq_list_1 += [ieq_list[i]]
        i+=1
    while i < (2*m):
        ieq_list_2 += [ieq_list[i]]
        i+=1
    while i < (3*m):
        ieq_list_3 += [ieq_list[i]]
        i+=1

    i = 0
    while i < len(ieq_list_1):
        ieq_list_1[i] = int(ieq_list_1[i])
        i +=1
    sorted_list_1 = sorted(ieq_list_1)
    print(sorted_list_1)
    i = 0
    while i < len(ieq_list_2):
        ieq_list_2[i] = int(ieq_list_2[i])
        i +=1

    sorted_list_2 = sorted(ieq_list_2)

    i = 0
    while i < len(ieq_list_3):
        ieq_list_3[i] = int(ieq_list_3[i])
        i +=1
    sorted_list_3 = sorted(ieq_list_3)

    ieq_list = [sorted_list_1, sorted_list_2, sorted_list_3]
    same_elts = False
    sorted_list = sorted(ieq_list)
    
    for l in number_list:
        if l == sorted_list:
            same_elts = True
            bad_ineqs +=[h]
            break       
    if same_elts == False:
        number_list += [sorted_list]

    j+=1

maximal_halves = [ele for ele in maximal_halves if ele not in bad_ineqs]

message = " contains points "
print(len(maximal_halves))
for h in maximal_halves:
    j = Polyhedron(ieqs =[h])
    points_in = []
    for x in data_points:
        if j.contains(x):
            points_in +=[x]
    str_h = str(h)
    str_pts = str(points_in)
    print(str_h + message + str_pts)

print("--- %s seconds ---" % (time.time() - start_time))
