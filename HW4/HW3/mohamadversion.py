# -*- coding: utf-8 -*-
"""
Created on Sat Nov 11 16:20:03 2017

@author: smvaz
"""

# -*- coding: utf-8 -*-


"""
Created on Tue Nov  7 00:40:09 2017

@author: mohammad
"""
from scipy.stats  import norm
from scipy.misc import comb
from scipy.stats import beta
from scipy import integrate
import matplotlib.pyplot as plt
import numpy 
import math
import pylab 
alpha=[5,3,1]   # define alpha pars for inverse gamma dist
betaa=[5,15,30] # define beta pars for inverse gamma dist
y_value=[10,3,3] # number of heads
N=[20,10,10]    #number of tosses 
x=numpy.linspace(-0.25,1,100)  # intervals for r ( it can't be megative, but negative r is considered  for visul purposeis )
for i in range( len(alpha)):
    a=' Inverse Gamma :alpha={}   beta={}'.format(alpha[i],betaa[i])
    b=' Laplace Approx :alpha={}   beta={}'.format(alpha[i],betaa[i])
    real_dist= lambda x : comb(N[i],y_value[i])*(x**y_value[i])*((1-x)**(N[i]-y_value[i]))*beta.pdf(x,alpha[i],betaa[i]) # prior * liklihood
    marginal_liklihood=integrate.quad(real_dist, x[0], x[-1])[0]  # calculating marginal liklihood (i.e, normalization tep)
    map_r=(y_value[i]+alpha[i]-1)/(alpha[i]+N[i]+betaa[i]-2)  # MAP for r 
    print('r={}',format(map_r))
    g_2d=((-alpha[i]-y_value[i]+1)/(map_r**2))+((-betaa[i]-N[i]+y_value[i]+1)/(1-map_r)**2)  # calculating hessian matrix
    variance_laplace=-(1/g_2d)
    plt.plot(x,norm.pdf(x,map_r, math.sqrt(variance_laplace)),label=b)
    print('sigma={}',format(math.sqrt(variance_laplace)))
    plt.plot(x,real_dist(x)/marginal_liklihood,label=a)
    pylab.legend(loc='upper right')
    #normal_pdf=norm.pdf(x,map_r, math.sqrt(variance_laplace))
   # real_dist=comb(N[i],y_value[i])*(x**y_value[i])*((1-x)**(N[i]-y_value[i]))*beta.pdf(x,alpha[i],betaa[i])
plt.xlabel('r value')    
plt.ylabel('p(r)')  
