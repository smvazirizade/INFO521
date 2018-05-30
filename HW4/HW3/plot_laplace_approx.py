# -*- coding: utf-8 -*-
"""
Created on Sun Nov  5 09:53:08 2017

@author: smvaz
"""

def clear_all():
    """Clears all the variables from the workspace of the spyder application."""
    gl = globals().copy()
    for var in gl:
        if var[0] == '_': continue
        if 'func' in str(globals()[var]): continue
        if 'module' in str(globals()[var]): continue

        del globals()[var]


if __name__ == "__main__":
    clear_all()





import numpy as np
import matplotlib.pyplot as plt
import scipy.stats as stats
#defining each of three states
for i in range(0,3):
    if i==0:
        Alpha=5
        Beta=5
        N=20
        y=10
    if i==1:
        Alpha=3
        Beta=15
        N=10
        y=3
    if i==2:
        Alpha=1
        Beta=30
        N=10
        y=3
    #caclulating Variance (Standard Deviation) and mean based on previous problem
    Variance=(y+Alpha-1)*(N-y+Beta-1)/(Alpha+N+Beta-2)**2/(Alpha+N+Beta-2)
    print( 'Variance', Variance)
    SD=Variance**0.5
    r=(y+Alpha-1)/(Alpha+N+Beta-2)
    print('r',r)
    R=np.linspace(0, 1, 101)
    #drawing the figures
    plt.figure()
    plt.plot(R,stats.norm.pdf(R, loc=r, scale=SD),color='r',label='Normal')
    plt.plot(R,stats.beta.pdf(R, Alpha+y, Beta+N-y),color='b',label='Beta')
    plt.xlabel('r')
    plt.ylabel('p(r)')
    plt.legend()
    ti = 'Plot of Posterior Dist with alpha={} Beta={} N={} y={} '.format(Alpha,Beta,N,y)
    plt.title(ti)
    plt.show()