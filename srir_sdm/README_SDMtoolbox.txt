SDMtoolbox is a collection of matlab functions and scripts for spatial room impulse response analysis and synthesis using Spatial Decomposition method [1]. Visualization of the spatial room impulse response is implemented as in [2]. Other examples of the visualization have been shown for example in [3],[4] and [5]. Synthesis of the spatial room impulse response is implemented as described in [4]. Binaural synthesis follows the method in [6]. 

The toolbox processes spatial room impulse responses, measured with a microphone array. The microphone array has to be specified as micLocs = microphone locations in Cartesian coordinates [numberOfMics 3] and in the order [x,y,z].

The spatial impulse response should be presented in the same order as the microphone locations IR : [N numberOfMics]

For auralization, a loudspeaker array must be defined with lspLocs = loudspeaker in Spherical coordinates [numberOfLoudSpeaker 3]. The order is Azimuth in degrees, Elevation in degrees, and Radius in meters.

There are several standard default loudspeaker setups, e.g., 5.1, in createSynthesisStruct.m, which you can use directly.

Example use cases for analysis, visualization, synthesis, and reproduction with different loudspeaker arrays or binaurally with headphones are found in:

demoCustomSetups.m 
demoDefaultSetups.m 
demoBinauralRendering.m
demoBformat.m
To run these examples, type 
> demoCustomSetups 
> demoDefaultSetups 
> demoBinauralRendering 
> demoBformat
in your Matlab command prompt.

This version has been tested with Matlab R2015b and R2014b. Some functions used in the demos are not available in older versions. For example, parula.m and websave.m are not included before R2014b.

The demos are using examples files, which you can also directly download by copy-pasting these links to your browser 
https://mediatech.aalto.fi/~tervos/IR_living_room.mat 
https://mediatech.aalto.fi/~tervos/IR_another_living_room.mat 
https://mediatech.aalto.fi/~tervos/IR_home_control_room.mat 
https://mediatech.aalto.fi/~tervos/demoJAES/samples/Song1_CR1.mp3

References 
[1] S. Tervo, J. P��tynen, A. Kuusinen, T. Lokki "Spatial decomposition method 
for room impulse responses", Journal of the Audio Engineering Society, vol. 61, no. 1/2, pp. 16-27, 2013 
[2] J. P��tynen, S. Tervo, T. Lokki, "Analysis of concert hall acoustics via visualizations of time-frequency and spatiotemporal responses", 
In J. Acoustical Society of America, vol. 133, no. 2, pp. 842-857, 2013. 
[3] S. Tervo, J. Saarelma, J. P��tynen, P. Laukkanen, I. Huhtakallio, 
"Spatial analysis of the acoustics of rock clubs and nightclubs", In the IOA Auditorium Acoustics, Paris, France, pp. 551-558, 2015 
[4] S. Tervo, J. P��tynen, N. Kaplanis, M. Lydolf, S. Bech, and T. Lokki "Spatial Analysis and Synthesis of Car Audio System and Car Cabin Acoustics with a Compact Microphone Array", Journal of the Audio Engineering Society 63 (11), 914-925, 2014 
[5] P. Laukkanen "Evaluation of Studio Control Room Acoustics with Spatial Impulse Responses and Auralization", Master's thesis, Aalto University, 2014 
[6] J. P��tynen, S. Tervo, and T. Lokki, "Amplitude panning decreases spectral brightness with concert hall auralizations", In Proc. 55th Audio Eng. Soc. conference Helsinki, Finland, Aug. 27-29 2014.

If you found a bug, have any questions, or would like us to add a feature, please contact by e-mail only at Sakari.Tervo@aalto.fi or Jukka.Patynen@aalto.fi

The toolbox includes the files

README.txt                     
SDMPar.m 			Analysis of spatial IRs, produces image-sources, i.e., SDM coeffs         
SDMbf				Analysis of spatial IRs from b-format signals
calcPolarResponse.m      	
createSDMStruct.m               
createSynthesisStruct.m        
createVisualizationStruct.m    
demoCustomSetups.m             Example use case, user-defined arguments
demoDefaultSetups.m            Example use case, default arguments
demoBinauralRendering.m        Example use case, binaural synthesis
demoBinauralRendering.m        Example use case, b-format
fftshift2.m                 
oneOver_n_OctBandFilter.m  
parameterVisualization.m       Visualization of the time indeces used in the visualizations
plotPolarResponse.m
plotFreqResponse.m          
spatioTemporalVisualization.m  Spatio-temporal visualization of image-sources
synthesizesSDMCoeffs.m	       Synthesis of image-sources, produces synthesis of SDM Coeffs for a given loudspeaker array
timeFrequencyVisualization.m   Spatio-temporal visualization a single impulse response