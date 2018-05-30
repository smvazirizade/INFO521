# -*- coding: utf-8 -*-
"""
Created on Tue Aug 29 10:35:48 2017

@author: smvaz
"""
import numpy as np
def exercise10(Seed):
    """
    This is a function for generating two sets of 3D random numbers.
    """
    import numpy as np
    np.random.seed(seed=Seed)
    RandomAll1=np.random.rand(3)
#    print('The first 3D random verctor is \n %s' %RandomAll1)
    RandomAll2=np.random.rand(3)
#    print('The second 3D random verctor is \n %s' %RandomAll2)
    return(RandomAll1,RandomAll2)


#this is just a flag
print('mohsen')
a,b=exercise10(5)
print('The first 3D random verctor is \n %s' %a)
print('The second 3D random verctor is \n %s' %b)

print('a+b= \n %s' %(a+b))
print('a.*b= \n %s' %(np.multiply(a,b)))
print('transpose(a)*b= \n %s' %(np.dot(np.transpose(a),b)))