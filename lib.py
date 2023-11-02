"""
Author: Hannes Rosseel

This library contains functions to generate Exponential Sine Sweeps (ESS)
according to Farina [1] and to process them into Room Impulse Responses (RIRs).

Do not disseminate this code without permission.
"""

from typing import Tuple

import numpy as np
from scipy import signal as sig


def ess_gen_farina(f_start: int, f_final: int, t_sweep: float, t_idle: float,
                   fs: int, fade_in: int = 0, cut_zerocross: bool = False
                   ) -> Tuple[np.ndarray, np.ndarray]:
    """
    Generate a single Exponential Sine Sweep (ESS) and the inverse signal,
    which is used to calculate Room Impulse Responses (RIRs) according to
    Farina [1].

    Parameters
    ----------
        f_start: int
            Starting frequency in Hz.
        f_final: int
            Final frequency in Hz.
        t_sweep: float
            Duration of the sweep in seconds.
        fs: int
            Sampling frequency in Hz.
        fade_in: int, optional
            Number of window length fade in samples. Defaults to zero.
        cut_at_zerocross: bool, optional
            If this flag is set to `True`, cut ESS at the last zero-crossing,
            reducing the signal duration. This is done to prevent abrupt
            termination of the ESS (resulting in pulsive sound). Defaults to
            `False`.
    Returns
    -------
        sweep: np.ndarray
            Generated Exponential Sine Sweep.
        inverse: np.ndarray
            Inverse signal, which is the scaled time-inverse of the ESS.
    """
    R = f_final / f_start
    w1 = 2 * np.pi * f_start
    w2 = 2 * np.pi * f_final

    t = np.arange(0, int(t_sweep * fs)) / fs

    sweep = np.sin(((w1 * t_sweep) / np.log(R)) * (
                   np.exp((t / t_sweep) * np.log(R)) - 1))

    if (fade_in > 0):
        sweep[0:fade_in] = sweep[0:fade_in] * np.sin(np.arange(0, fade_in) * (
                            np.pi / (2 * fade_in)))

    if (cut_zerocross):
        margin = int(0.002 * fs)  # Change this if zerocut is not accurate
        # Find index of min_val
        min_val_arg = np.argmin(abs(sweep[sweep.shape[0] - margin:]))
        # cut sweep at min_val
        num_samples_to_cut = margin - min_val_arg
        sweep[-num_samples_to_cut:] = np.zeros(num_samples_to_cut)

        max_freq = (f_start * np.exp((t[sweep.shape[0] - num_samples_to_cut]
                                      / t_sweep) * np.log(R)))
        print("Warning: sweep cutoff at last zero-crossing. Final "
              f"frequency is: {int(max_freq)} Hz")

    C = 2 * (w2 * np.log(R)) / ((w2 - w1) * t_sweep)
    inverse = C * np.exp(-(t/t_sweep) * np.log(R)) * np.flip(sweep)

    # Add idle time after ESS
    sweep = np.append(sweep, np.zeros(t_idle * fs))
    return (sweep, inverse)


def ess_parse_farina(sweep: np.ndarray, inverse: np.ndarray, t_sweep: float,
                     t_idle: float, fs: int, causality: bool = False
                     ) -> np.ndarray:
    """
    Process the input Exponential Sine Sweep (ESS) and output the
    resulting Room Impulse Response (RIR) according to Farina [1].

    Parameters
    ----------
        sweep: np.ndarray
            Input Exponential Sine Sweep (ESS).
        inverse: np.ndarray
            Inverse signal of the ESS.
        t_sweep: float
            Duration of the active sweep in seconds.
        t_idle: float
            Idle time in seconds following a single ESS.
        fs: int
            Sampling frequency in Hz
        causality: bool, optional
            If this flag is set to `True`, only return the causal part of the
            RIR. Otherwise, return the full RIR. Defaults to `False`.
    Returns
    -------
        rir: np.ndarray
            The resulting Room Impulse Response.
    """
    if sweep.ndim > 1:
        raise Exception("Input has more than one dimension. Please input"
                        "a one dimensional vector containing the ESS.")
    duration = int(np.floor((t_sweep + t_idle) * fs))
    rir = np.array(sig.fftconvolve(sweep[:duration], inverse,
                                   mode='full'))
    if causality:
        rir = rir[int(t_sweep * fs - 1):duration - 1]
    return rir.real
