# -*- coding: utf-8 -*-
"""
Created on Mon Oct  2 14:30:26 2017

@author: smvaz
"""
import numpy
import matplotlib.pyplot as plt
# Turn off annoying matplotlib warning
import warnings
warnings.filterwarnings("ignore", ".*GUI is implemented.*")
# define required procedure
#1
def true_function(x):
    """$t = 5x+x^2-0.5x^3$"""
    return (5 * x) + x**2 - (0.5 * x**3)
#2
def sample_from_function(N=100, noise_var=1000, xmin=-5., xmax=5.):
    """ Sample data from the true function.
        N: Number of samples
        Returns a noisy sample t_sample from the function
        and the true function t. """
    x = numpy.random.uniform(xmin, xmax, N)
    t = true_function(x)
    # add standard normal noise using numpy.random.randn
    # (standard normal is a Gaussian N(0, 1.0)  (i.e., mean 0, variance 1),
    #  so multiplying by numpy.sqrt(noise_var) make it N(0,standard_deviation))
    t = t + numpy.random.randn(x.shape[0])*numpy.sqrt(noise_var)  
    return x, t
#3
#This one is for generating data without noise
def sample_from_function_main(N=100, xmin=-5., xmax=5.):
    """ Sample data from the true function.
        N: Number of samples
        Returns a noisy sample t_sample from the function
        and the true function t. """
    x = numpy.random.uniform(xmin, xmax, N)
    t = true_function(x)
    return x, t

#range of random numbers
xmin = -4.
xmax = 5.
#noise variance
noise_var = 6
#creating data for test and drawing figures
testx = numpy.linspace(xmin, xmax, 100)


xmin_remove=-2
xmax_remove=2

#polynomial orders
orders = [1, 3, 5, 9]
#number of different curves we want to draw+ the main one
numberofcurves=20+1
#number of sample point we want to use to calculate w
numberofsamples=25
for i in orders:
    #seed number
    numpy.random.seed(seed=2)
    w = numpy.zeros(shape=(i + 1,numberofcurves))
    prediction_t= numpy.zeros(shape=(testx.shape[0],numberofcurves))
    for j in range(0,numberofcurves):
        if j==0:
            #without noise
            x, t = sample_from_function_main(numberofsamples, xmin, xmax)
            #with noise
        else:
            x, t = sample_from_function(numberofsamples, noise_var, xmin, xmax)   
        #print(x)
        #print(t.shape[0])
        #print('j=',j)
        # create input representation for given model polynomial order
        X = numpy.zeros(shape=(x.shape[0], i + 1))
        testX = numpy.zeros(shape=(testx.shape[0], i + 1))
        for k in range(i + 1):
            X[:, k] = numpy.power(x, k)
            testX[:, k] = numpy.power(testx, k)
        # fit model parameters
        w[:,j] = numpy.dot(numpy.linalg.inv(numpy.dot(X.T, X)), numpy.dot(X.T, t))
        #print('w=', w)
        # calculate predictions
        prediction_t[:,j]= numpy.dot(testX, w[:,j])
        #print('prediction_t=', prediction_t)
    # Plot the data and functions
    #plt.plot(testx.T, prediction_t[:,j], color='k', edgecolor='k')  
    plt.plot(testx, prediction_t, color='b')
    plt.plot(0,0, color='b', label='Interplation with noise')
    plt.plot(testx, prediction_t[:,0], color='g',linewidth=3, label='Interplation without noise')
    x=numpy.linspace(-4, 4, 100)
    plt.plot(  x,   (5 * x) + x**2 - (0.5 * x**3), color='r',linewidth=3, label='Theoretical')
    plt.xlabel('x')
    plt.ylabel('t')   
    # find reasonable ylim bounds
    plt.xlim(xmin_remove-2, xmax_remove+2)  # (-2,4) # (-3, 3)
    min_model = min(prediction_t.flatten())
    max_model = max(prediction_t.flatten())
    min_testvar = min(min(t), min_model)
    max_testvar = max(max(t), max_model)
    plt.ylim(min_testvar, max_testvar)  # (-400,400)
    plt.legend(loc=4)
    ti = 'Plot of {0} functions '\
         .format(j) + \
         ' of model with polynomial order {1}' \
         .format(numberofsamples, i)
    plt.title(ti)
    plt.pause(.1)  # required on some systems so that rendering can happen
    plt.show()









plt.show()
