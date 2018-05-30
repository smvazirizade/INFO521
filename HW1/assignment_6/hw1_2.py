# -*- coding: utf-8 -*-
"""
Created on Mon Aug 28 10:51:45 2017

@author: smvaz
"""

import numpy as np
import matplotlib.pyplot as plt
Data=np.loadtxt('data/humu.txt')
print('Type of Data is %s ' % type(Data))
print('Total size of Data is %i ' %Data.size)
Size1,Size2=Data.shape
print('The number of columns and rows are %i and %i, respetively' % (Size1, Size2))
Min, Max =Data.min(), Data.max()
print('The min and max vaules are %f and %f, respetively' % (Min, Max))
DataScaled=(Data-Min)/(Max-Min)
SizeScaled1,SizeScaled2=DataScaled.shape
print('The number of columns and rows are %i and %i, respetively' % (SizeScaled1, SizeScaled2))
MinScaled, MaxScaled =DataScaled.min(), DataScaled.max()
print('The min and max vaules of DataScaled are %f and %f, respetively' % (MinScaled, MaxScaled))

print('Do they have the same number of elements? %s'  %(Data.size==DataScaled.size))
print('Do they have the same number of rows and columns, respectively? %s %s'  % (Size1==SizeScaled1,Size2==SizeScaled2)) 

#Producing to uniformly random data with the same dimensions of previous part.
Radnom1=np.random.random((Size1,Size2))
Radnom2=np.random.random((Size1,Size2))


print('original shape')
plt.figure()
plt.imshow(Data)
plt.show()
print('Gray Scale')
plt.figure()
plt.imshow(Data, cmap='gray')
plt.show()

print('Radnom1')
plt.figure()
plt.imshow(Radnom1)
plt.show()

print('Radnom2')
plt.figure()
plt.imshow(Radnom2)
plt.show()

print('Difference between Radnom2 and Radnom1')
plt.figure()
plt.imshow(Radnom2-Radnom1)
plt.show()



plt.close()

