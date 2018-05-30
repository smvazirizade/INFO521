# -*- coding: utf-8 -*-
"""
Created on Tue Aug 29 22:06:35 2017

@author: smvaz
"""


import numpy as np
import matplotlib.pyplot as plt

x = np.arange(0.0, 10, 0.01)

plt.figure()
plt.plot(x, np.sin(x))
plt.grid(True)
plt.xlabel('X')
plt.ylabel('sin(x)')
plt.axis('tight')
plt.title('Sine Function for x from 0.0 to 10.0')

plt.show()