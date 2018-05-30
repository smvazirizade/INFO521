# -*- coding: utf-8 -*-
"""
Created on Sat Sep  9 14:05:43 2017

@author: smvaz
"""

import numpy
import fitpoly
A=fitpoly.read_data('data/womens100.csv', d=',')
x=(A[:,0])
t=A[:,1]
print('x=%s' % (x))
print('t=%s' % (t))
fitpoly.plot_data(x, t, title='Data')
print('-----------------------fitpoly')
w=fitpoly.mfitpoly(x, t, 1)
print('w')
print(w)
plot_model(x, w)