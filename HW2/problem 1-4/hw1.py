# -*- coding: utf-8 -*-
"""
Created on Sat Sep  9 14:05:43 2017

@author: smvaz
"""
#importing the library
import numpy
import fitpoly
#reading the data from the folder data
A=fitpoly.read_data('data/mens100.csv', d=',')
#seperating the columns
x=(A[:,0])
t=A[:,1]
#printing the reasults for checking
print('x=%s' % (x))
print('t=%s' % (t))
#plot the data
fitpoly.plot_data(x, t, title='Data')
print('-----------------------fitpoly')
#calculation and printing of w
w=fitpoly.mfitpoly(x, t, 1)
print('w')
print(w)
#plot w
plot_model(x, w)