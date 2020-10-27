import itertools
import math
import matplotlib.pyplot as plt
import time
import copy

degree_string = input("What degree: ")
#graph_string = input("Do you want to see the graphs? Answer 'y' or 'n': ")
graph_string = 'n'

#Sets up our list of homogeneous 3 tuples
degree = int(degree_string)

range_list = list(range(degree + 1))

before_list = list(itertools.product(range_list, range_list, range_list))

tuple_list = [x for x in before_list if x[0] + x[1] + x[2] == degree]

working_list = [list(x) for x in tuple_list]

#Take our list of 3-tuples in R^3 and take the plane containing them and transform that into a copy of R^2 centered at the middle of the triangle
a = (2 * math.sqrt(3) * degree)/3

def plane_convert(list_in):
    list_in[0] = -a/(2 * degree) * list_in[0] + a/(2 * degree) * list_in[2]
    list_in[1] = list_in[1] - degree/3.0
    return list_in

def plane_inverse(list_in):
    list_in[0] = list_in[2] - ((2 * degree)/a) * list_in[0]
    list_in[1] = list_in[1] + degree/3.0
    return list_in

convert_list = [plane_convert(x) for x in working_list] 

#Set up this triangle for graphing if wanted by getting a list of x and y coordinates.
x_list = []
y_list = []
for x in convert_list:
    x_list = x_list + [x[0]]
    y_list = y_list + [x[1]]

#Since we're only checking the first 60 degrees, the bottom right quadrant will never show up so computationally we can delete it and not have to worry. This is also why we get our list of graphed points before this step.
for x in convert_list:
    if x[0] > 0 and x[1] < 0:
        convert_list.remove(x) 

x_mul = 0

#We can calculate the minimum angular distance between any two points in our triangle by looking at the bottom right and next closest outer point.
corner_point3 = plane_convert([degree, 0, 0])
near_point3 = plane_convert([degree-1 , 1, 0])
corner_point = [corner_point3[0], corner_point3[1] ]
near_point = [near_point3[0], near_point3[1]]

#long_side is the long side of the triangle, near_side is the side to the near point and between_side is the side between the two points
long_side = math.sqrt(corner_point[0]**2 + corner_point[1]**2)
near_side = math.sqrt(near_point[0]**2 + near_point[1]**2)

x_diff = corner_point[0] - near_point[0]
y_diff = corner_point[1] - near_point[1]

between_side = math.sqrt(x_diff**2 + y_diff**2)

big_value = 1/(2* long_side * near_side) * (long_side**2 + near_side**2 - between_side**2)
minimum_angle = math.acos(big_value)

extreme_x_right = (plane_convert([degree, 0, 0]))[0]
extreme_x_left = (plane_convert([0, 0, degree]))[0]

point_list = []
max_set_list = []
angle = 0

#Now, while the angle is less than 60, we check the points in the "left" halfspace generated by the line through the origin at that angle. If these points are contained in a set of points for a previous halfspace, we discard them. If not, they are added to a general list of points, the length of which tells us the number of different unstable polynomials we have.
while angle <= math.pi/3:
    for x in convert_list:
        if x[1] - x_mul*x[0] > 0:
            point_list = point_list + [x]

    if max_set_list == []:
        max_set_list = max_set_list + [point_list]
    
    for x in max_set_list:
        contains = all(elem in x for elem in point_list)
        if contains == True:
            break
        rev_contain = all(elem in point_list for elem in x)
        if rev_contain == True:
            max_set_list.remove(x)
    
    if contains == False:
        max_set_list = max_set_list + [copy.deepcopy(point_list)]


    x_listp = []
    y_listp = []
    for x in point_list:
        x_listp = x_listp + [x[0]]
        y_listp = y_listp + [x[1]]

    #Optional graphing - it's a little bit awkward at the moment since you have to close each window as it arrives.
    if graph_string == "y":
        plt.plot([extreme_x_left, extreme_x_right], [x_mul*extreme_x_left, x_mul*extreme_x_right], '-g')
        plt.plot(x_list,y_list, 'ro')
        plt.plot(x_listp, y_listp, 'bo')
        plt.axis('equal')
        plt.grid()
        plt.show()

    angle = angle + minimum_angle
    x_mul = math.tan(angle)
    point_list = []

for x in max_set_list:
    for y in x:
        y = plane_inverse(y)

print(max_set_list)



