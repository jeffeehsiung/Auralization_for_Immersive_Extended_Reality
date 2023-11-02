%% Example usage of SDM toolbox for analysis of B-format impulse responses. 
% The data is a measurement from a class room
% The documentation of the measurement is found at 
% http://legacy.spa.aalto.fi/projects/poririrs/

% SDM toolbox : demoBformat
% Sakari Tervo & Jukka Patynen, Aalto University, 2016
% Sakari.Tervo@aalto.fi and Jukka.Patynen@aalto.fi

%% Load the impulse response. 

% % 4s long impulse response measured at 48 kHz
% 
% % Download an B-format room impulse response from spa.aalto.fi
% ir_filename = 'sndfld.zip';
% if ~exist([ir_filename],'file')
%     disp(['Downloading an example IR ' ir_filename ' from the database.'])
%     url_ir = ['http://legacy.spa.aalto.fi/projects/poririrs/wavs/sndfld.zip'];
%     websave([ir_filename],url_ir);
%     unzip(ir_filename)
% end

%% Read the data
% Read impulse response
[ir_bformat1,fs] = audioread("IRs_valerio/pos_0_speaker_2/ir_pos_0_speaker_2_mic1.wav");
[ir_bformat2,fs] = audioread("IRs_valerio/pos_0_speaker_2/ir_pos_0_speaker_2_mic2.wav");
[ir_bformat3,fs] = audioread("IRs_valerio/pos_0_speaker_2/ir_pos_0_speaker_2_mic3.wav");
[ir_bformat4,fs] = audioread("IRs_valerio/pos_0_speaker_2/ir_pos_0_speaker_2_mic4.wav");
[ir_bformat5,fs] = audioread("IRs_valerio/pos_0_speaker_2/ir_pos_0_speaker_2_mic5.wav");
[ir_bformat6,fs] = audioread("IRs_valerio/pos_0_speaker_2/ir_pos_0_speaker_2_mic6.wav");

%% Create a length of samples by 6 matrix
ir_bformat = [ir_bformat1,ir_bformat2,ir_bformat3,ir_bformat4,ir_bformat5,ir_bformat6];

%% Create SDM struct for analysis with a set of parameters
% Parameters required for the calculation
% Load default array and define some parameters with custom values
% fs = 48e3;
a = createSDMStruct('DefaultArray','Bformat','fs',fs,'winLen',15);

%% Calculate the SDM coefficients
% Solve the DOA of each time window assuming wide band reflections, white
% noise in the sensors and far-field (plane wave propagation model inside the array)
DOA{1} = SDMbf(ir_bformat, a);
DOA{2} = SDMbf(ir_bformat, a);
DOA{3} = SDMbf(ir_bformat, a);
DOA{4} = SDMbf(ir_bformat, a);
DOA{5} = SDMbf(ir_bformat, a);
DOA{6} = SDMbf(ir_bformat, a);

% Here we are using the pressure in the b-format as the estimate for the
% pressure in the center of the array
P{1} = ir_bformat(:,1);
P{2} = ir_bformat(:,2);
P{3} = ir_bformat(:,3);
P{4} = ir_bformat(:,4);
P{5} = ir_bformat(:,5);
P{6} = ir_bformat(:,6);

%% Create a struct for visualization with a set of parameters
% Load default setup for very small room and change some of the variables
v = createVisualizationStruct('DefaultRoom','LargeRoom',...
    'name','Pori, Concert Hall','fs',fs,'t',[2 5 10 20 50 100 200 2000]);
% For visualization purposes, set the text interpreter to latex
set(0,'DefaultTextInterpreter','latex')

%% Draw analysis parameters and impulse responses
parameterVisualization(P, v)
%% Draw  time frequency visualization
timeFrequencyVisualization(P, v)
%% Draw the spatio temporal visualization for each section plane
v.plane = 'lateral';
spatioTemporalVisualization(P, DOA, v)
v.plane = 'transverse';
spatioTemporalVisualization(P, DOA, v)
v.plane = 'median';
spatioTemporalVisualization(P, DOA, v)

% <----- EOF demoBFormat