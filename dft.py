import numpy as np
import matplotlib.pyplot as plt
import scipy as sp
# % matplotlib widget


# 1.1 average signal power
# 1.1.a create a column vector of length 1000 containing random elements, distribute accrdoign to a Gaussian probability density function with mean 0 and variance 1
x = np.random.normal(0, 1, 1000) # A Normal Distribution is also known as a Gaussian distribution or famously Bell Curve.
#  legnth = 1000, std_dev = np.sqrt(1), mean = 0
#  x = np.random.normal(mean, std_dev, (length.1))
# 1.1.b compute the average signal power (= variance) of x in three different ways
# 1.1.b.i by performing only additions and multiplications of the vector elements

def average_signal_power(x):
    return np.sum(x ** 2) / len(x)

# 1.1.b.ii by computing the vector inner product
def average_signal_power_2(x):
    return np.dot(x, x) / len(x)

# 1.1.b.iii by computing the vector norm
def average_signal_power_3(x):
    return np.linalg.norm(x,2) ** 2 / len(x)


print("1.1.a")
power1 = average_signal_power(x)
power2 = average_signal_power_2(x)
power3 = average_signal_power_3(x)
print("power1: ", power1, "power2: ", power2, "power3: ", power3)


# 1.2 linear filtering of a signal
# 1.2.a creat a column vector of length 3, containing the impulse response coefficients of the linear filter with transfer function H(z) = 1 + 0.18z^-1 + 0.81z^-2
h = np.array([1, 0.18, 0.81])
# 1.2.b compute the output signal of this filter when using the Gaussian noise signal from 1.1.a as input signal, and perform this computation in two different ways
# 1.2.b.i by applying the NumPy function convolve
y1 = np.convolve(x, h)
# 1.2.b.ii by computing a matrix-vector product to realize the matrix form of the convolution using scipy.linalg.convolution_matrix
y2 = sp.linalg.convolution_matrix(h, len(x), mode='full').dot(x)
# 1.2.c create a figure in which the DFT magnitude of the output signal is plotted as a function of the frequency index for both computation methods
# compare if the result is the same in both cases, show the two plots side by side and show the title and name of the axis of each subplot
# plot the magnitude in decibels (dB) using the function 20*log10 and place grids in both subplots
print("1.2.b")
plt.figure()
plt.subplot(1, 2, 1)
plt.plot(20 * np.log10(np.abs(np.fft.fft(y1))))
plt.title("convolve")
plt.xlabel("frequency index")
plt.ylabel("DFT magnitude (dB)")
plt.xlim(0, len(y1)/2)
plt.grid()
plt.subplot(1, 2, 2)
plt.plot(20 * np.log10(np.abs(np.fft.fft(y2))))
plt.title("convolution_matrix")
plt.xlabel("frequency index")
plt.ylabel("DFT magnitude (dB)")
# plot only the first half of the DFT magnitude vector, since the second half is a mirror image of the first half
plt.xlim(0, len(y2)/2)
plt.grid()
plt.show()

#  compare if the result is the same by computing the difference between the two output signals
# print("1.2.c")
# y_diff = y1 - y2
# print("y_diff: ", y_diff)

# 1.2.d what filter type is this (lowpass, highpass, bandpass, bandstop)? how do you know?
# this is a bandpass filter

# 1.3 discrete fourier transform of a signal
# 1.3.a compute the discrete fourier transform magnitude of a 128-sample sinusoidal signal having a self-chosen amplitude, frequency, and phase in two different ways
sine_amplitude = 1
sine_frequency = 1000
sine_phase = 0
n = np.arange(0, 128)
x = sine_amplitude * np.sin(2 * np.pi * sine_frequency * n + sine_phase)
# 1.3.a.i by using the NumPy function fft
y1 = np.fft.fft(x)
# 1.3.a.ii by computing the matrix-vector product, making use of the matrix definition of the DFT
y2 = sp.linalg.dft(128).dot(x)
# 1.3.b create a figure in which the DFT magnitude is plotted as a function of the frequency index for both computation methods
# compare if the result is the same in both cases, show the two plots side by side and show the title and name of the axis of each subplot
print("1.3.b")
plt.figure()
plt.subplot(1, 2, 1)
plt.plot(np.abs(y1))
plt.title("fft")
plt.xlabel("frequency index")
plt.ylabel("DFT magnitude")
plt.grid()
plt.subplot(1, 2, 2)
plt.plot(np.abs(y2))
plt.title("dft")
plt.xlabel("frequency index")
plt.ylabel("DFT magnitude")
plt.grid()
plt.show()

# 1.4 matrix decomposition and rank
# 1.4.a create 3 vectors of length 8 containing random elements, distributed according to Gaussian probability density function with mean 0 and variance 0.1, 0.5, and 1, respectively
x1 = np.random.normal(0, 0.1, 8)
x2 = np.random.normal(0, 0.5, 8)
x3 = np.random.normal(0, 1, 8)
# 1.4.b compute the outer product of eah of the three vectors with itself
y1 = np.outer(x1, x1)
y2 = np.outer(x2, x2)
y3 = np.outer(x3, x3)

# 1.4.c create a matrix containing the sum of these three outer products using the NumPy function sum
z = np.sum([y1, y2, y3], axis=0)
# z = y1 + y2 + y3
# 1.4.d compute the rank of this matric in two differnet ways
# 1.4.d.i by computing the eigenvalue decomposition (Numpy function np.linalg.eigvals) and counting the number of non-zero eigenvalues
rank1 = np.count_nonzero(np.linalg.eigvals(z) > 1e-10)
# 1.4.d.ii by applying Numpy function np.linalg.matrix_rank
rank2 = np.linalg.matrix_rank(z)
# 1.4.e check if the result is the same in both cases
print("1.4.e")
print("rank1: ", rank1, "rank2: ", rank2)


