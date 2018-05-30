# -*- coding: utf-8 -*-
"""
Created on Sat Sep  9 13:55:28 2017

@author: smvaz
"""
import numpy
import matplotlib.pyplot as plt


# -------------------------------------------------------------------------
a=list()
j=0
for  i in range(10,100,10):
    print(i/10)
    a.append(i)
    print( a[int(i/10)-1])
    print(a)        


a=numpy.zeros(10)
for i in range(10,100,10):
 print(i/10)
 a[int(i/10)]=i
 print(a)