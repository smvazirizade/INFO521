# -*- coding: utf-8 -*-
"""
Created on Tue Aug 29 10:35:48 2017

@author: smvaz
"""
import numpy as np
def exercise7(itterations):
    """
    This is a function for generating two sets of N random dices and counting the number of double six.
    """
    import numpy as np
    RandomAll=[0]*itterations
    for j in range(0,itterations):
     RandomAll[j]=[np.random.randint(1,7) for i in range(0,2)]
    i=0
    for j in range(0,itterations):
        if RandomAll[j][1]==RandomAll[j][0]==6:
            i=1+i
    print(i)           
    #print(RandomAll)        
np.random.seed(seed=8)    
for j in range(0,10):
 #np.random.seed(seed=8)
 #help(exercise7)
 exercise7(1000)
   