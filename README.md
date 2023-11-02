# Dynamic Auralization Interpolation Algorithm for Immersive Extended Reality

## Research Question

How does the spatial resolution of Spatial Room Impulse Response (SRIR) measurements relate to the objective and perceived quality of dynamic auralization?

## Introduction

Dynamic auralization is the process of creating or recreating sound fields that change according to the listener's position and orientation. SRIR, or spatial room impulse response, is a set of acoustic parameters that describe sound propagation within a room. This project aims to investigate how the spatial resolution of SRIR measurements affects the quality of dynamic auralization, both from an objective and subjective perspective.

The Spatial Decomposition Method (SDM) will be employed to calculate SRIRs from multichannel room impulse response measurements. SDM encodes information about the directions of arrival of acoustic reflections to the microphone array.

Currently, most binaural auralization applications only use three degrees of freedom (3DOF) related to the orientation of the listener's head. This project's research aims to achieve six degrees of freedom (6DOF) by including the location of the head in 3D space, in addition to its orientation.

## Work Plan

### Dataset Collection
#### RIR Measurements
* Utilize a cart to move the microphone along a predefined trajectory.
* Make RIR measurements with a vector probe at different discrete positions along the trajectory.
* Use a vector probe to capture acoustic reflections.
* Record RIR measurements at discrete positions with a fixed distance between them.
#### Reverberant Speech/Music Measurement
* Record reverberant speech/music signal using either the vector probe or a dummy head.
* The recording captures variations in the sound field as the listener moves in the room.
#### Positioning Microphone-Array and Loudspeaker
* Place the microphone-array and loudspeaker at the assumed choir position.

### SRIR Synthesization
* Measure the Spatial Room Impulse Response (SRIR) using an exponential sine-swept signal.
* Use an acoustic measurement setup in the KUL ESAT acoustic lab
* Calculate SRIR
* Position matching:
* * Match discrete positions to time stamps in a continuous trajectory.
* Dataset evaluation: 
* * Evaluate the difference between omnidirectional measured and simulated speech/music signals using different quality metrics such as interaural cross correlation
* Implement the Spatial Decomposition Method (SDM) to obtain spatial RIRs at discrete measurement positions.

### SRIR interpolation
* Investigate interpolation methods to obtain continuous spatial RIRs along the trajectory.

### Binaural Auralization
* Compute binaural signals by mapping spatial RIRs to binaural RIRs using dummy head HRTFs.
* Convolve binaural RIRs with the speech/music signal, resulting in a set of binaural signals representing dynamic auralization of the sound field.
#### Method Evaluation
* Evaluate the difference between binaural measured and auralized speech/music signals using different spatial resolutions and with/without interpolation.
* Subjectively evaluate binaural auralization quality by listening with headphones and create listening examples.
* Objectively evaluate differences using various quality metrics.

## Deliverables
* Conference paper-style report summarizing the research project.
* Follow the guidelines and format of a IEEE scientific conference
* Prepare the measurement data for publication by organizing, documenting, and archiving it in a suitable format and platform.

## References
* Spatial Decomposition Method (SDM)
* Vector Probe Information
* Matlab Toolbox for SDM
* Spatial Room Impulse Response (SRIR)
* Interpolation Methods for SRIRs
* Head-Related Transfer Function (HRTF)# Auralization_for_Immersive_Extended_Reality
