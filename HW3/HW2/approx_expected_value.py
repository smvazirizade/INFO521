# approx_expected_value_sin.py
# Port of approx_expected_value.m
# From A First Course in Machine Learning, Chapter 2.
# Simon Rogers, 01/11/11 [simon.rogers@glasgow.ac.uk]
# Approximating expected values via sampling
import numpy
import matplotlib.pyplot as plt

# Turn off annoying matplotlib warning
import warnings
warnings.filterwarnings("ignore", ".*GUI is implemented.*")

print('mohsen')
# We are trying to estimate the expected value of
# $f(y) = 60-0.1*x-0.5*x**3+0.05*x**4$
##
# ... where
# $p(y)=U(-4,10)$
##
# ... which is given by:
# $\int f(y) p(y) dy$
##
# The analytic result is = 44.860...
# (NOTE: this just gives you the analytic result -- you should be able to derive it!)

# First, let's plot the function, shading the area under the curve for x=[-4,10]
# The following plot_fn helps us do this.

# Information about font to use when plotting the function
font = {'family' : 'serif',
        'color'  : 'darkred',
        'weight' : 'normal',
        'size'   : 12,
        }


def plot_fn(fn, a, b, fn_name, resolution=100):
    x = numpy.append(numpy.array([a]),
                     numpy.append(numpy.linspace(a, b, resolution), [b]))
    # for example it makes it as [0 0 1 2 3 4 5 6 7 8 9 10 10]
    # x = numpy.linspace(x_begin, x_end, resolution)
    y = fn(x)
    y[0] = 0 # the first
    y[-1] = 0   # the last
    plt.figure()
    plt.fill(x, y, 'b', alpha=1)
    # plt.fill_between(x, y, y2=0, color='b', alpha=0.3)
    fname, x_tpos, y_tpos = fn_name()
    plt.text(x_tpos, y_tpos, fname, fontdict=font)
    plt.title('Area under function')
    plt.xlabel('$y$')
    plt.ylabel('$f(y)$')

    x_range = b - a

    plt.xlim(a-(x_range*0.1), b+(x_range*0.1))


# Define the function y that we are going to plot
def y_fn(x):
    c=60-0.1*x-0.5*x**3+0.05*x**4
    return c


def y_fn_name():
    """
    Helper for displaying the name of the fn in the plot
    Returns the parameters for plotting the y function name,
    used by approx_expected_value
    :return: fname, x_tpos, y_tpos, year
    """
    fname = r'$f(y) = 60-0.1*y-0.5*y**3+0.05*y**4$'  # latex format of fn name
    x_tpos = -3  # x position for plotting text of name
    y_tpos = 100  # y position for plotting text of name
    return fname, x_tpos, y_tpos


# Plot the function!
plot_fn(y_fn, -4, 10, y_fn_name)


# Now we'll approximate the area under the curve using sampling...

# Sample 5000 uniformly random values in [-4..10]
numpy.random.seed(seed=1)
ys = numpy.random.uniform(low=-4.0, high=10.0, size=5000)
# compute the expectation of y, where y is the function that squares its input
ey2 = numpy.mean(60-0.1*ys-0.5*ys**3+0.05*ys**4)
print('\nSample-based approximation for 5000 samples: {:f}'.format(ey2))
# Store the evolution of the approximation, every 100 samples
sample_sizes = numpy.arange(100, ys.shape[0], 100)
ey2_evol = numpy.zeros((sample_sizes.shape[0]))  # storage for the evolving estimate...
# the following computes the mean of the sequence up to i, as i iterates
# through the sequence, storing the mean in ey2_evol:
for i in range(sample_sizes.shape[0]):
    ey2_evol[i] = numpy.mean(60-0.1*ys[0:sample_sizes[i]]-0.5*ys[0:sample_sizes[i]]**3+0.05*ys[0:sample_sizes[i]]**4)  
    print('\nSample-based approximation for {:4d} sample: {:f}'.format(sample_sizes[i],ey2_evol[i]))

# Create plot of evolution of the approximation
plt.figure()
# plot the curve of the estimation of the expected value of f(x)=y^2
plt.plot(sample_sizes, ey2_evol)
# The true, analytic result of the expected value of f(y)=y^2 where y ~ U(0,1): $\frac{1}{3}$
# plot the analytic expected result as a red line:
plt.plot(numpy.array([sample_sizes[0], sample_sizes[-1]]),
         numpy.array([44.860, 44.860]), color='r')
plt.xlabel('Sample size')
plt.ylabel('Approximation of expectation')
plt.title('Approximation of expectation of $f(y) = 60-0.1*x-0.5*x**3+0.05*x**4$')
plt.pause(.1)  # required on some systems so that rendering can happen

plt.show()  # keeps the plot open



