"""
Author: Hannes Rosseel

This demo file shows how to generate an Exponential Sine Sweep (ESS) and its
inverse filter according to Farina [1] and how to calculate a Room Impulse
Response (RIR) from a measured sweep.

Do not disseminate this code without permission.
"""

###############################################################################
# Import required libraries
###############################################################################
import numpy as np
import matplotlib.pyplot as plt
import soundfile as sf

from lib import ess_gen_farina, ess_parse_farina

###############################################################################
# Create Exponential Sine Sweep from parameters
###############################################################################
fs = 48000  # Sampling Frequency [Hz]

f1 = 20  # Initial frequency [Hz]
f2 = fs // 2  # Final frequency [Hz]

T_sweep = 10  # Sweep duration [sec.]
T_idle = 3  # Idle duration [sec.]

fade_in = int(0.100 * fs)  # fade-in window of 100 ms [samples]

t_sweep = np.arange(0, (T_sweep + T_idle) * fs) / fs  # Time vector [sec.]

###############################################################################
# Generate exponential sine sweep and its inverse filter
###############################################################################
sweep, inverse = ess_gen_farina(f1, f2, T_sweep, T_idle, fs,
                                fade_in=fade_in,
                                cut_zerocross=True)

###############################################################################
# Plot the generated sweep and inverse filter
###############################################################################
fig, axs = plt.subplots(2, 1, figsize=(10, 5), sharex=True)
axs[0].plot(t_sweep, sweep)
axs[0].set_title('Exponential Sine Sweep $x(t)$')
axs[0].set_xlabel('Time [s]')
axs[0].set_ylabel('Amplitude')
axs[0].grid()

axs[1].plot(np.arange(0, int(T_sweep * fs)) / fs, inverse)
axs[1].set_title('Inverse Filter $\\tilde{x}(t)$')
axs[1].set_xlabel('Time [s]')
axs[1].set_ylabel('Amplitude')
axs[1].grid()
fig.tight_layout()

###############################################################################
# Perform deconvolution with measured sweep
# For this demo, we use the generated sweep as measured sweep
###############################################################################
measured_sweep = sweep

h = ess_parse_farina(measured_sweep, inverse, T_sweep, T_idle, fs,
                     causality=True)

###############################################################################
# Plot the calculated impulse response
###############################################################################
plt.figure()
t = np.arange(0, T_idle * fs) / fs
plt.plot(t, h)
plt.title('Impulse Response $\\delta(t)$')
plt.xlabel('Time [s]')
plt.ylabel('Amplitude')
plt.grid()
plt.show()

###############################################################################
# Save the sweep and inverse filter to a file for later use
###############################################################################
sf.write('sweep.wav', sweep, fs, subtype='PCM_24')
sf.write("inverse.wav", inverse, fs, subtype='PCM_24')
