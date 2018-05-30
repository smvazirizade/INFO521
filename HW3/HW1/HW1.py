# -*- coding: utf-8 -*-
"""
Created on Sun Oct  1 12:30:35 2017

@author: smvaz
"""
#improting requeired lib
import math

def POISSON(Lambda, y):
    #define a function to calculate poisson dist
    pmf= math.exp(-Lambda) * Lambda**y / math.factorial(y)
    return pmf

# a for loop for calculation of 4=<y=<9 
Lambda=3
pmf=0
for y in range(4,10):
    pmf=POISSON(Lambda,y)+pmf
print('pmf for 4=<y=<9 and Lambda=%s is %s'  %(Lambda, pmf))
print('pmf for 9<y or y<4 and Lambda=%s is %s'  %(Lambda, 1-pmf))   



