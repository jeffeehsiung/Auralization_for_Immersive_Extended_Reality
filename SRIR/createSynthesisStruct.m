function p = createSynthesisStruct(varargin)
% p = createSynthesisStruct(varargin)
% Creates a structure that includes the parameters for SDMpar.m
%
% USAGE:
% 
% If you wish to use your own loudspeaker array you can define it as
% p = createSynthesisStruct('lspLocs',mtxLocations), where
% mtxLocations includes the locations of the loudspeaker array
% in the mtxLocations(i,:) = [Azimuth,Elevation,Radius];
% The order is Azimuth [degrees], Elevation [degrees], Radius [m]
%
% You can also create binaural synthesis using pre-defined HRTFs.
% In this toolbox, CIPIC HRTF database structure is readily implemented.
% Note that the loudspeaker setup can be defined separately, thus 
% you can for example compare 5.0 and 12.0 binaurally. In this case the
% closest virtual loudspeaker locations in CIPIC database to the specified
% lpsLocs are used.
% 
% Parameter values can be given as an input with pairs 
% 'parameter',parameter_value
%
% Parameters:
% 'lspLocs', matrix  : Matrix including loudspeaker locations [n_s 3]
% 'fs': value        : Sampling frequency in Hz
% 'dimensionality', 2 or 3 : Dimensionality of the loudspeaker array
% 'snfft', value     : Length of IR
% 'c', value         : Speed of sound in m/s in the reproduction room
% 'Radius', vector   : Loudspeaker distances to sweep spot
% 'LFEcutOff', value : Cut-off frequency in Hz for LFE channel
% 'Binaural',logical : true or false, if binaural synthesis is desired
% 'hrtfData',HRTF sofa    : downloaded HRIR
%
% This also returns FIR and IIR parameters that the user currently has
% no control over. If the IIR filters become unstable, try increasing the
% cut-off frequency in the LFEcutoff variable.
% 
% [Blp,Alp] : Butterworth IIR filter coefficients for low pass filter 
% [Bhp,Ahp] : Butterworth IIR filter coefficients for high pass filter
% g         : A matrix of FIR filters coefficients for perfect 
%             reconstruction octave band filter 
%             see help oneOver_n_OctBandFilter.m for more information
% hrtindex  : HRTF indeces in CIPIC database corresponding to locations in 
%             lspLocs
% hrir_l    : left ear HRTFS
% hrir_r    : right ear HRTFs
% 


% Check if all arguments are valid
listNames = {'fs', 'c', 'dimensionality', 'snfft', ...
    'showArray', 'Radius', 'LFEcutOff', 'Binaural', ...
    'lspLocs', 'LFEchannel', 'DefaultArray', 'hrtfData'}; % Removed the extra dots

% Define default values
defaults = struct('fs', 48e3, 'c', 345, 'dimensionality', 3, 'snfft', 3*48e3, ...
                  'showArray', false, 'Radius', 3.5, 'LFEcutOff', 80, 'Binaural', false, ...
                  'hrtfData', [], 'lspLocs', [], 'LFEchannel', [], 'DefaultArray', '');
              
% Process input parameters
for i = 1:2:length(varargin)
    if ~any(strcmpi(listNames, varargin{i}))
        error(['SDM toolbox : createSynthesisStruct : Unknown parameter ' varargin{i}]);
    end
    defaults.(varargin{i}) = varargin{i+1};
end
% hrtfData = SOFAload('KU100_HRIR_FULL2DEG_Koeln.sofa');

% Now all the parameters are stored in the 'defaults' structure
p = defaults; % You can use 'p' as your parameters structure

% Perfect reconstruction octave band FIR filters
[G,p.g,p.f1,f2] = oneOver_n_OctBandFilter(2*p.snfft, 1, p.fs, 62.5, 12000);

% Cut-off filter design for LFE channel
[p.Blp,p.Alp] = butter(3,p.LFEcutOff/(p.fs/2),'low');
[p.Bhp,p.Ahp] = butter(3,p.LFEcutOff/(p.fs/2),'high');

%% below is self-modified script for KU100 (Jeffee)
if any(strcmpi('lspLocs',varargin)) % User defined loudspeaker array
    i = find(strcmpi('lspLocs',varargin));
    p.lspLocs = varargin{i+1};
    if any(strcmpi('LFEchannel',varargin))
        i = find(strcmpi('LFEchannel',varargin));
        p.LFEchannel = varargin{i+1};
    else
        p.LFEchannel = [];
    end
    if isempty(p.LFEchannel)
        disp('createSynthesisStruct:  No LFE channel')
    end
    defaultArray = [];
else
    if any(strcmpi('DefaultArray',varargin))
        i = find(strcmpi('DefaultArray',varargin));
        defaultArray = varargin{i+1};
    else
        error('createSynthesisStruct:  You must define the loudspeaker array for synthesis.')
    end
    % Standard loudspeaker array setups
    if any(strcmpi(defaultArray,'2.1'))
        % Azimuth and Elevation
        p.lspLocs(:,1:2) = ...
            [-30 0
            +30 0
            0 -30] ;% LFE
        p.LFEchannel = 3;
        % Radius
        p.lspLocs(:,3) = p.Radius;
        p.dimensionality = 2; % 2-D array
    elseif any(strcmpi(defaultArray,'5.1'))
        % Azimuth and Elevation
        p.lspLocs(:,1:2) = ...
            [-30 0 % Left
            +30 0 % Right
            0 0 % Center
            0 -30 % LFE
            -110 0 % Surround Left
            +110 0]; % Surround Right
        p.LFEchannel = 4;
        % Radius
        p.lspLocs(:,3) = p.Radius;
        p.dimensionality = 2; % 2-D array
    elseif any(strcmpi(defaultArray, '7.1'))
        % Azimuth and Elevation
        p.lspLocs(:,1:2) = ...
            [0 0
            -30 0
            +30 0
            0 -30 % LFE
            -110 0
            +110 0
            -30 0
            +30 0];
        p.LFEchannel = 4;
        % Radius
        p.lspLocs(:,3) = p.Radius;
        p.dimensionality = 2; % 2-D array
    elseif any(strcmpi(defaultArray,'9.1'))
        % Azimuth and Elevation
        p.lspLocs(:,1:2) = ...
            [0 0
            -30 0
            +30 0
            0 -30 % LFE
            -110 0
            +110 0
            -30 0
            +30 0
            -110 +30
            +110 +30];
        p.LFEchannel = 4;
        % Radius
        p.lspLocs(:,3) = p.Radius;
        p.dimensionality = 2; % 2-D array
    elseif any(strcmpi(defaultArray,'10.1')) % SAME AS 9.1 according to ITU-R BS.2266
        % Azimuth and Elevation
        p.lspLocs(:,1:2) = ...
            [0 0
            -30 0
            +30 0
            0 -30 % LFE
            -110 0
            +110 0
            -30 0
            +30 0
            -110 +30
            +110 +30];
        p.LFEchannel = 4;
        % Radius
        p.lspLocs(:,3) = p.Radius;
        p.dimensionality = 2; % 2-D array
    elseif any(strcmpi(defaultArray,'10.2'))
        % Azimuth and Elevation
        p.lspLocs(:,1:2) = ...
            [0 0
            180 30
            -30 0
            +30 0
            -90 0
            +90 0
            -30 0
            +30 0
            -135 0
            +135 0
            -45 0
            +45 0
            -45 -30 % LFE 1
            +45 -30]; % LFE 2
        p.LFEchannel = [11 12];
        % Radius
        p.lspLocs(:,3) = p.Radius;
        p.dimensionality = 2; % 2-D array
    elseif any(strcmpi(defaultArray,'22.2'))
        p.lspLocs(:,1:2) = ...
            [0 0
            -30 0
            +30 0
            -60 0
            +60 0
            -90 0
            +90 0
            -135 0
            +135 0
            +180 0
            0 +30
            -45 +30
            +45 +30
            -90 +30
            +90 +30
            -135 +30
            +135 +30
            +180 +30
            0 +90
            0 -30
            -45 -30
            +45 -30
            -45 -30  % LFE 1
            +45 -30]; % LFE 2
        p.LFEchannel = [23 24];
        p.lspLocs(:,3) = p.Radius;
        p.dimensionality = 3; % 3-D array
    elseif any(strcmpi(defaultArray,'51.2')) % All the positions in ITU-R BS.2266
        % Azimuth and Elevation
        p.lspLocs(:,1:2) = ...
            [0 0
            -22.5 0
            +22.5 0
            -30 0
            +30 0
            -45 0
            +45 0
            -60 0
            +60 0
            -90 0
            +90 0
            -110 0
            +110 0
            -135 0
            +135 0
            +180 0
            0 +30
            -22.5 +30
            +22.5 +30
            -30 +30
            +30 +30
            -45 +30
            +45 +30
            -60 +30
            +60 +30
            -90 +30
            +90 +30
            -110 +30
            +110 +30
            -135 +30
            +135 +30
            +180 +30
            0 +90
            0 -30
            -22.5 -30
            +22.5 -30
            -30 -30
            +30 -30
            -45 -30
            +45 -30
            -60 -30
            +60 -30
            -90 -30
            +90 -30
            -110 -30
            110 -30
            -135 -30
            135 -30
            +180 -30
            -45 -30  % LFE 1
            +45 -30]; % LFE 2
        p.LFEchannel = [50 51];
        p.lspLocs(:,3) = p.Radius;
        p.dimensionality = 3; % 3-D array
    elseif any(strcmpi(defaultArray,'AALTO_32'))
        % Custom 32-channel loudspeaker setup, located in Aalto University
        p.lspLocs = ...
            [0    0    1.51
            23    0    1.49
            45    0    1.48
            65    0    1.51
            90    0    1.50
            135   0    1.48
            180   0    1.48
            -135   0    1.49
            -90   0    1.52
            -67   0    1.50
            -45   0    1.50
            -22   0    1.50
            0     32   1.73
            45    32   1.72
            90    45   1.18
            135   32   1.71
            -135  32   1.70
            -90   43   1.23
            -45   33   1.71
            -23   87   1.26
            40   -35   1.63
            152  -32   1.67
            -152 -32   1.69
            -37  -35   1.67
            -77  -10   1.49
            -56  -10   1.49
            -32  -10   1.49
            -11  -10   1.49
            11   -10   1.49
            32   -10   1.49
            56   -10   1.49
            77   -10   1.49];
        p.dimensionality = 3; % 3-D array
        p.LFEchannel = [];
    elseif any(strcmpi(defaultArray,'AALTO_24'))
        % Custom 32-channel loudspeaker setup, located in Aalto University
        p.lspLocs = ...
            [0    0    1.51
            23    0    1.49
            45    0    1.48
            65    0    1.51
            90    0    1.50
            135   0    1.48
            180   0    1.48
            -135  0    1.49
            -90   0    1.52
            -67   0    1.50
            -45   0    1.50
            -22   0    1.50
            0     32   1.73
            45    32   1.72
            90    45   1.18
            135   32   1.71
            -135  32   1.70
            -90   43   1.23
            -45   33   1.71
            -23   87   1.26
            40   -35   1.63
            152  -32   1.67
            -152 -32   1.69
            -37  -35   1.67];
        p.dimensionality = 3; % 3-D array
        p.LFEchannel = [];
    elseif any(strcmpi(defaultArray, 'KU100'))
        % Example of setting up loudspeaker locations based on KU100 HRIR measurements
        % Adjust the azimuth and elevation angles to match the KU100's measurement grid
        % Here we assume regular intervals for simplicity; modify as per actual KU100 data
%         
%         % Define elevation angles in 15° steps
%         El = -90:15:90;  % Degrees
%         El = El/180*pi;  % Convert to radians
%     
%         % Define azimuth angles for each elevation
%         % The actual azimuth angles will depend on the KU100 measurement setup
%         % Here we use a placeholder setup; replace with actual angles
%         Az = -180:15:180;  % Degrees
%         Az = Az/180*pi;  % Convert to radians
%     
%         % Create a grid of loudspeaker locations
%         [A, E] = meshgrid(Az, El);
%         [x, y, z] = sph2cart(A, E, 1);
%         [A, E] = cart2sph(x, -z, y);  % Right-hand coordinate system
% 
%         % Save to matrix
%         p.lspLoc(:, 1:2) = [A(:) * 180/pi, E(:) * 180/pi];  % Degrees
%         p.lspLocs(:, 3) = 1.2;  % Assumed radius
%         p.dimensionality = 3;  % 3-D array
%         p.LFEchannel = [];
        % Example modification for KU100 HRIR setup
        % Generate loudspeaker locations based on KU100 HRIR azimuth and elevation angles
        Az = linspace(0, 358, 180); % Degrees
        El = linspace(-88.4605, 88.4605, 89); % Degrees
        [AzGrid, ElGrid] = meshgrid(Az, El);
        radius = 3.25; % Assuming this is the measurement radius
        [x, y, z] = sph2cart(deg2rad(AzGrid(:)), deg2rad(ElGrid(:)), radius);
        p.lspLocs = [rad2deg(atan2(y, x)), rad2deg(asin(z / radius)), radius * ones(size(x))];
        p.dimensionality = 3;
        p.LFEchannel = [];
    else
       error(['createSynthesisStruct: Unknown loudspeaker array ' defaultArray])
    end
end

if p.Binaural
    % Extract HRIRs for left and right ears
    hrir_l = p.hrtfData.Data.IR(:, 1, :); % Assuming SOFA format
    hrir_r = p.hrtfData.Data.IR(:, 2, :);

    % Reshape the HRIRs from the SOFA format
    hrir_l = permute(hrir_l, [3, 1, 2]);
    hrir_r = permute(hrir_r, [3, 1, 2]);

    % Alpha is an eq parameter that describes the strength of diffuse field
    % equalization [0,1]
    alpha = 0.6; % 0.5-0.7 ok value for listening

    % Define the locations of the loudspeakers used in the KU100 measurements
    % Update these ranges to match the KU100 data more precisely
    azimuths = 0:2:358; % Example: every 2 degrees from 0 to 358
    elevations = -88:2:88; % Example: every 2 degrees from -88 to 88

    % Preallocate LOCS with the correct size
    numAzimuths = length(azimuths);
    numElevations = length(elevations);
    LOCS = zeros(numAzimuths * numElevations, 3); % 3 for x, y, z coordinates
    
    % Index to keep track of the insertion point in LOCS
    currentIndex = 1;
    
    % Create a grid of loudspeaker locations in spherical coordinates
    for elevIndex = 1:numElevations
        for azimIndex = 1:numAzimuths
            elev = elevations(elevIndex);
            azim = azimuths(azimIndex);
            % Convert spherical coordinates to Cartesian
            [x, y, z] = sph2cart(deg2rad(azim), deg2rad(elev), 1.2); % Radius = 1.2 meters
            LOCS(currentIndex, :) = [x, y, z];
            currentIndex = currentIndex + 1;
        end
    end
    
    % Convert spherical coordinates to Cartesian
    radius = 1.2; % Radius of the measurement setup
    [eq_lx, eq_ly, eq_lz] = sph2cart(deg2rad(LOCS(:,1)), deg2rad(LOCS(:,2)), radius);

    % Combine into a single matrix for the LOCS variable
    LOCS = [eq_lx, eq_ly, eq_lz];

    % Apply diffuse field equalization
    [eq_hrir_l, eq_hrir_r] = diffuseFieldEQ(LOCS, hrir_l, hrir_r, alpha, p.fs);
    
    % Resample HRIRs to match the system's sampling rate
    p.hrir_l = resample(eq_hrir_l, p.fs, p.hrtfData.Data.SamplingRate);
    p.hrir_r = resample(eq_hrir_r, p.fs, p.hrtfData.Data.SamplingRate);
end
if isempty(varargin)
    disp('createSynthesisStruct: Default settings are :');
    disp(p)
else
    disp('createSynthesisStruct: User-defined settings are :');
    disp(p)
end

end

function [yl, yr] = diffuseFieldEQ(LOCS, hrir_l,hrir_r, alpha, fs)
% [yl, yr] = diffuseFieldEQ(LOCS, hrir_l,hrir_r, alpha)
% A custom "Diffuse field-equalization" for CIPIC HRTFS
% 
% USAGE
% 
% yl : equalized left channel HRTFS
% yr : equalized left channel HRTFS
% 
% LOCS   : All the locations of the loudspeakers in the CIPIC database
% hrir_l : All the left ear HRTFS in the CIPIC database
% hrir_r : All the right ear HRTFS in the CIPIC database 
% alpha  : the "amount" of equalization from 0 to 1, 0 none, 1 all
% 
% References
% [1] J. P����tynen, S. Tervo, and T. Lokki, 
% "Amplitude panning decreases spectral brightness with concert 
% hall auralizations", In Proc. 55th Audio Eng. Soc. conference Helsinki, 
% Finland, Aug. 27-29 2014.


% SDM toolbox : createSynthesisStruct
% Sakari Tervo & Jukka P����tynen, Aalto University, 2011-2016
% Sakari.Tervo@aalto.fi and Jukka.Patynen@aalto.fi
% Copyleft

diff_eq_lpsdirs =   [0 0
                    45 0
                    90 0
                    135 0
                    180 0
                    -135 0
                    -90 0
                    -45 0];
diff_eq_lpsdirs(:,3) = 1; % "1m distance to loudspeakers"
[eq_lx,eq_ly,eq_lz] = sph2cart(diff_eq_lpsdirs(:,1)*pi/180, diff_eq_lpsdirs(:,2)*pi/180, 1);

% Find best coordinate matches with knnsearch
eq_hrtf_inds = knnsearch(LOCS,[eq_lx,eq_ly,eq_lz]);

% zero padd to for best fft length
length_hrir_l = length(hrir_l); % Get the length of hrir_l
nextPowerOfTwo = 2^nextpow2(length_hrir_l); % Find the next power of two
hrir_l_padded = padarray(hrir_l, [max(0, nextPowerOfTwo-length(hrir_l)), 0], 'post');
hrir_r_padded = padarray(hrir_r, [max(0, nextPowerOfTwo-length(hrir_r)), 0], 'post');
eq_sel_hrtf = [hrir_l_padded(:,eq_hrtf_inds) hrir_r_padded(:,eq_hrtf_inds)];

fftlen = nextPowerOfTwo;

f = linspace(0,fs,fftlen)';
X = fft(eq_sel_hrtf,fftlen);

Xmean(:,1) = mean(abs(X(:,1:8)).^2,2); % left mean freq resp
Xmean(:,2) = mean(abs(X(:,9:16)).^2,2); % right mean freq resp

[fsm,Xcompsm] = oct_smooth2(f,sqrt(mean(Xmean,2)),1/3);

diff_fsm = diff(fsm);
diff_fsm(diff_fsm==0) = 0.001;
fsm2 = [0; cumsum(diff_fsm)];

Xcomp = interp1(fsm2,Xcompsm,f);

% Compensation in frequency domain
% Left
X = fft(hrir_l_padded(:,:),fftlen);
Amp = abs(X(1:end/2+1,:));
Ang = angle(X(1:end/2+1,:));

comp = repmat((Xcomp(1:end/2+1).^alpha),[1 size(X,2)]);
B = (Amp./comp).*exp(1i*Ang);

Y = [B; conj(B(end-1:-1:2,:))];
yl = real(ifft(Y));

yl = yl(1:length(hrir_l_padded),:);

% Right
X = fft(hrir_r_padded(:,:),fftlen);
Amp = abs(X(1:end/2+1,:));
Ang = angle(X(1:end/2+1,:));

comp = repmat((Xcomp(1:end/2+1).^alpha),[1 size(X,2)]);
B = (Amp./comp).*exp(1i*Ang);

Y = [B; conj(B(end-1:-1:2,:))];
yr = real(ifft(Y));

yr = yr(1:length(hrir_r_padded),:);

end

function [f,Xf] = oct_smooth2(f_orig, Xf_orig, resolution)
% Oct_smooth  Smoothing filter for frequency responses.
%    [f,Xf] = oct_smooth(f_orig, Xf_orig, resolution) calculates a 1/n octave
%    smoothing in frequency domain.
%    
% USAGE:
% 
%    Required parameters:
%    f_orig :       original f-axis values, e.g. 
%                   [0:length(Xf)/fs:(length(Xf)/2)-1]
%    Xf_orig :      original FFT, e.g.
%                   abs(fft(x)/length(x))
%    resolution :   frequency resolution, e.g.
%                   1 = octave; 1/3 thirds; 1/12 semitone
% 

% SDM toolbox : createSynthesisStruct
% Sakari Tervo & Jukka P����tynen, Aalto University, 2011-2016
% Sakari.Tervo@aalto.fi and Jukka.Patynen@aalto.fi
% Copyleft

n_div = 24;         % Sampling resolution, 1/24 octave

winlength = floor(resolution * n_div);

% Create logarithmically spaced frequency axis
% Pick 10 first values from the original frequency bin vector
% a=1;
hiind = find((f_orig(3:end)./f_orig(2:end-1))<2^(1/n_div),1,'first');
hiind = hiind-1;
ixs = f_orig(1:hiind)';
a = f_orig(hiind);
while a < f_orig(end)
    a = a*2^(1/n_div);
    ixs = [ixs(:); a];
end

% Pick frequency axis values by indices
idx = [];
for i=1:length(ixs)
    in = find(ixs(i) < f_orig, 1);
    idx = [idx in];
end
idx=round(idx);

f = f_orig(idx);        % Frequency axis output

gain = sum(hanning(winlength))/sum(ones(winlength,1));
Xf = filter(hanning(winlength),1,Xf_orig(idx,:));     % Low-pass filter sampled values
Xf = (1/gain)*circshift(Xf,-floor(winlength/2)) / winlength;        % Correct filtering delay and magnitude

Xf = Xf(1:end-floor(winlength/2),:); % Truncate the wrapped bass response
f= f(1:end-floor(winlength/2));


end



