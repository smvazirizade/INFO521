# -*- coding: utf-8 -*-
"""
Created on Mon Aug 28 10:51:45 2017

@author: smvaz
"""
def exercise6(infile, outfile):
    '''
    This fucntion is written on 8/28/2017
    The fist argument is the exact address and format of the input file, which is an image the user wants to draw
    The second argument is the exact address for saving the output file
    '''
    #calling numpy and matplotlib.pyplot
    import numpy as np
    import matplotlib.pyplot as plt
    #calling the resource data and showing of interest values
    Data=np.loadtxt(infile)
    print('Type of Data is %s ' % type(Data))
    print('Total size of Data is %i ' %Data.size)
    Size1,Size2=Data.shape
    print('The number of columns and rows are %i and %i, respetively' % (Size1, Size2))
    #Rescaling according the problem statement and printing the values
    Min, Max =Data.min(), Data.max()
    print('The min and max vaules are %f and %f, respetively' % (Min, Max))
    DataScaled=(Data-Min)/(Max-Min)
    SizeScaled1,SizeScaled2=DataScaled.shape
    print('The number of columns and rows are %i and %i, respetively' % (SizeScaled1, SizeScaled2))
    MinScaled, MaxScaled =DataScaled.min(), DataScaled.max()
    print('The min and max vaules of DataScaled are %f and %f, respetively' % (MinScaled, MaxScaled))
    #verify the resaults
    print('Do they have the same number of elements? %s'  %(Data.size==DataScaled.size))
    print('Do they have the same number of rows and columns, respectively? %s %s'  % (Size1==SizeScaled1,Size2==SizeScaled2)) 
    
    #Producing to uniformly random data with the same dimensions of previous part.
    Radnom1=np.random.random((Size1,Size2))
    np.savetxt(outfile, Radnom1)
    
    #printing
    print('original shape')
    plt.figure()
    plt.imshow(Data)
    plt.show()
    
    print('Gray Scale')
    plt.figure()
    plt.imshow(Data, cmap='gray')
    plt.show()
    
    print('outfile')
    DataRandom1=np.loadtxt(outfile)
    plt.figure()
    plt.imshow(DataRandom1)
    plt.show()
    
    
    plt.close()
    
    #(For fun: Anyone know what `humu' is? Give the full name!)

    print('The very last part asks about what Humu means. This is the short form of Humuhumunukunukuapua which is a name of a fish species, the one you can see above')


help(exercise6)
exercise6('data/humu-2.txt','data/random1.txt')
