# -*- coding: utf-8 -*-
"""
Created on Sat Sep  9 14:05:43 2017

@author: smvaz
"""
#calling the library
import numpy
import fitpoly
import cv_demo
#calling the data
A=fitpoly.read_data('data/synthdata2017.csv', d=',')
#shuffling the data
RandomA=cv_demo.permute_rows(A, P=None)
TrainA=RandomA[0:20,:]
TestA=RandomA[20:25,:]
#printing the output for checking
print('RandomA=\n %s \n' % (RandomA))
print('TrainA=\n %s \n' % (TrainA))
print('TestA=\n %s \n' % (TestA))
#calling required function from cv demo
maxorder=4
#cv_demo.run_cv( 5, maxorder, TrainA[:,0], TrainA[:,1], TestA[:,0], TestA[:,1], randomize_data=False, title='CV' )
best_poly, min_mean_log_cv_loss, w=cv_demo.run_cv( 5, maxorder, RandomA[:,0], RandomA[:,1], RandomA[:,0], RandomA[:,1], randomize_data=False, title='CV' )


#calculation and drawing pertinent to the best fitted data
cv_demo.plot_data(RandomA[:,0], RandomA[:,1])
cv_demo.plot_model(RandomA[:,0], w, color='r')
print('w=%s' %(w))