# -*- coding: utf-8 -*-
"""
Created on Sat Nov  4 14:45:00 2017

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

#total  number of itterations
a=10000000
#defining seed number
np.random.seed(seed=1)

#generating two columns of uniform random number between -1 and 1
Random=np.random.uniform(-1,1,(a,2))
Inside=[0,0]
Outside=[0,0]
print('All sample pairs \n{}'.format(Random))
#based on the circle fomula, x^2+Y^2=1, we catagorize our dots based on their distance to center as inside and outside
for j in range(0,a):
    Radius=(Random[j,0]**2+Random[j,1]**2)
    if Radius<1:
        #print('Inside point \n {} {}'.format(Random[j,:],Radius ))
        Inside=np.vstack((Inside,Random[j,:]))
        #print('Inside \n {}'.format(Inside))
        
    else:
        #print('Outside point \n {} {}'.format(Random[j,:],a ))
        Outside=np.vstack((Outside,Random[j,:]))
        #Outside=(Random[j,:])
#just eliminating the first row which is zero        
Inside=np.delete(Inside,0,0)
print('Inside \n {}'.format(Inside))
Outside=np.delete(Outside,0,0)
print('Outside \n {}'.format(Outside))
#Now we have to calculate the total number of members in each category
NumberofInside=Inside.shape[0]
NumberofOutside=Outside.shape[0]
#calcuation of pi
PI=NumberofInside/(NumberofInside+NumberofOutside)
print('Calculated value for Pi is {:01.6f}'.format(4*PI))
#drawing each catogory with different color
plt.figure()
plt.scatter(Inside[:,0], Inside[:,1], color='r', edgecolor='k',label='Inside')
plt.scatter(Outside[:,0], Outside[:,1], color='b', edgecolor='k',label='Outside')
plt.xlabel('x1')
plt.ylabel('x2')
plt.legend()
plt.title('Estimation of Pi')
plt.axis('equal')
plt.show()

