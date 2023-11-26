function [H,Hbin] = synthesizeSDMCoeffs(P,DOA, p)
% H = synthesizeSDMCoeffs(P,DOA,varargin)
% Synthesizes the pressure vector P according to DOA matrix 
% to loudspeakers defined in p.lspLocs
% 
% USAGE:
% 
% H : Synthesized matrix of impulse responses [N numberOfLoudspeakers]
% Hbin : Synthesized binaural impulse responses [2 numberOfLoudspeakers]
%        Channels 1: left, 2: right
% 
% P : Vector with the pressure in the center of the array [N 1]   
% DOA : Matrix DOA corresponding to each pressure value [N 3]
% p: struct given by createSynthesisStruct.m or can be manually given
% 
% EXAMPLES:
% 
% For further examples for setting the parameters, see 
% createSynthesiStruct.m or demo*.m
% 
% References
% [1] S. Tervo, J. P����tynen, A. Kuusinen, T. Lokki "Spatial decomposition method 
% for room impulse responses", Journal of the Audio
% [2] S. Tervo, J. P����tynen, N. Kaplanis, M. Lydolf, S. Bech, and T. Lokki
% "Spatial Analysis and Synthesis of Car Audio System and Car Cabin
% Acoustics with a Compact Microphone Array",

% SDM toolbox : synthesizeSDMCoeffs
% Sakari Tervo & Jukka P����tynen, Aalto University, 2011-2016
% Sakari.Tervo@aalto.fi and Jukka.Patynen@aalto.fi

if nargin < 3
    error(['SDM toolbox : synthesizesSDMCoeffs : Three inputs are required ' ... 
    ' synthesizesSDMCoeffs(P,DOA, p)']);
end

disp('Started synthesizing'); ts = tic;

% Local variable for loudspeaker locations
lspLocs = p.lspLocs;

numOfLsp = size(lspLocs,1);

% Assign NaNs to the LEF channels
lspLocs(p.LFEchannel,:) = NaN;

% To spherical coordinates
[az,el] = cart2sph(DOA(:,1), DOA(:,2), DOA(:,3));

% ---- hack ----
% Sometimes you get NaNs from the DOA analysis
% Replace NaN directions with uniformly distributed random angle
az(isnan(az)) = pi-rand(size(az(isnan(az))))*2*pi;
el(isnan(el)) = pi/2-rand(size(el(isnan(el))))*pi;
% ------ EOF hack -------

% Nearest loudspeaker synthesis == no panning
[nLOC(:,1),nLOC(:,2),nLOC(:,3)] = sph2cart(az,el,1);
[lpsx,lpsy,lpsz] = sph2cart(lspLocs(:,1)/180*pi, lspLocs(:,2)/180*pi, 1);

% Nearest neighbour search
indslps = knnsearch([lpsx,lpsy,lpsz],nLOC);

% Output matrix of impulse responses for each loudspeaker
H = zeros(length(P),numOfLsp);

% p.dimensionality is user defined, typically 2-D arrays are in home use,
% and 3-D arrays in research facilities and cinemas (movie theaters)

% ----- Synthesis of the impulse response as in Ref. [1] ----------------
% ---- For a 3-D loudspeaker setup, e.g. Hamasaki 22.2 -----
if p.dimensionality == 3  
    % assign the pressure sample to nearest loudspeakers w.r.t. az and el
    for rep_lps = 1:numOfLsp
        inds = indslps == rep_lps;
        H(inds,rep_lps) = P(inds); % assign the pressure values
    end
    
elseif p.dimensionality == 2
    % ---- For a 2-D loudspeaker setup (azimuthal plane) -----
    % The pressure is weighted with the elevation, thus all the energy is played back
    % but higher elevation is attenuated more (according to abs(cos(el))).
    
    % Assign the pressure sample to nearest loudspeakers w.r.t. az and el
    for rep_lps= 1:numOfLsp
        inds = indslps == rep_lps;
        H(inds,rep_lps) = P(inds).*abs(cos(el(inds)));
    end
end
% ----> H is the synthesized impulse response

% The rest is some tricks to obtain a smoother time-frequency response

% % ------- Smoothen the spectrogram of H to match P (no batch) ----------
% % Post-equalization of the synthesized impulse responses
% % This method is described in Reference [2]
% % FIR octave band filters
% snfft = length(P);
% numOfBands = length(p.f1);
% HS = zeros(size(H));
% 
% % ---- post-eq octave bands -----
% for band = 1:numOfBands
%     if band == 1
%         winLen = snfft;
%         winLen = winLen + mod(winLen,2);
%     else
%         winLen = round(7/p.f1(band)*p.fs);
%         winLen = winLen + mod(winLen,2);      
%     end
%     % Equalize the NSL output in winLen sized frames
%     H_posteq = equalizeNLS(H, P, winLen);
%     
%     % Filter the result with octave band filter
%     H_filt = fftconv(p.g(:,band), H_posteq, snfft);
%     HS = HS + H_filt;
% end
% clear H_filt H_posteq;
% H = HS; % overwrite H with the post-equalized version
% clear HS;
% %---- end of no batch processing ----%

%---- Smoothen the spectrogram of H to match P (with batch processing) ----
% Assuming snfft is defined and is a power of two
snfft = length(P);
numOfBands = length(p.f1);

% Determine the batch size - this could be adjusted based on your memory constraints
batchSize = 1000;  % Adjust this value as needed
numBatches = ceil(size(H, 1) / batchSize);

HS = zeros(size(H), 'like', H);  % Preallocate for efficiency, matching the data type of H

% Process each batch
for b = 1:numBatches
    % Determine the range of indices for this batch
    idxStart = (b - 1) * batchSize + 1;
    idxEnd = min(b * batchSize, size(H, 1));

    % Extract the batch from H
    H_batch = H(idxStart:idxEnd, :);

    % Initialize a matrix for the post-equalized batch
    H_posteq_batch = zeros(size(H_batch), 'like', H_batch);

    % Process each octave band
    for band = 1:numOfBands
        if band == 1
            winLen = snfft;
            winLen = winLen + mod(winLen, 2);
        else
            winLen = round(7 / p.f1(band) * p.fs);
            winLen = winLen + mod(winLen, 2);
        end

        % Equalize the batch in winLen sized frames
        H_batch_posteq = equalizeNLS(H_batch, P(idxStart:idxEnd), winLen);

        % Filter the result with octave band filter
        H_batch_filt = fftconv(p.g(:, band), H_batch_posteq, snfft);

        H_posteq_batch = H_posteq_batch + H_batch_filt;
    end

    % Store the processed batch in HS
    HS(idxStart:idxEnd, :) = H_posteq_batch;
end

clear H_posteq_batch H_batch_filt H_posteq_batch H_batch;
H = HS;  % Overwrite H with the post-equalized version
clear HS;
%---- end of batch processing (comment out the section if not using it ----

%-----------------------------------------------------------------------
% Since there are several loudspeakers, the low-frequencies
% are low-passed due to phase summation in the listening location.
% Here, the cut-off frequency is 200 Hz, which assumes that in-phase
% summation occurs below 200 Hz
if numel(p.LFEchannel) == 0
    f_cutoff = 200;
    [b,a] = butter(1,f_cutoff/(p.fs),'high');
    H = filtfilt(b,a,H);
end

% ----------- Add LFE channels --------------
% If one LFE channel
if numel(p.LFEchannel) == 1
    
    % High-passed sound to all other channels
    Hhp = filtfilt(p.Bhp,p.Ahp,H);
    H = Hhp;
    
    % Low-passed sound to LFE channel
    Hlp = filtfilt(p.Blp,p.Alp,H);
    H(:,p.LFEchannel) = sum(Hlp,2);
    clear Hlp;
% If two LFE channels
elseif numel(p.LFEchannel) == 2 % This assumes that LFE1 is left and LFE2 is right 
    
    % High-passed sound to all other channels
    Hhp = filtfilt(p.Bhp,p.Ahp,H);
    H = Hhp;
    
    % Low-passed sound to LFE channels
    inds_lfe1 = lspLocs(:,1) > 0;
    inds_lfe2 = lspLocs(:,1) < 0;
    inds_zero = lspLocs(:,1) == 0;
    
    Hlp1 = filtfilt(p.Blp,p.Alp,[H(:,inds_lfe1), sqrt(2)*H(:,inds_zero)]);
    Hlp2 = filtfilt(p.Blp,p.Alp,[H(:,inds_lfe2), sqrt(2)*H(:,inds_zero)]);

    H(:,p.LFEchannel(1)) = sum(Hlp1,2);
    H(:,p.LFEchannel(2)) = sum(Hlp2,2);
    clear Hlp1 Hlp2 Hhp;
end
% TODO, elseif more than two LFE channels, depends on the positions of the other
% loudspeakers

% %  ------ Binaural synthesis (no batch overlap-save) ---------------
% if p.Binaural
%     disp('Started binaural synthesis.');tb = tic;
%     N1 = size(H,1);
%     N2 = size(p.hrir_l,1);
%     nfft = N1+N2+1;
%     Hbin(:,1) = real(ifft(sum(fft(p.hrir_l,nfft).*fft(H,nfft),2)));
%     Hbin(:,2) = real(ifft(sum(fft(p.hrir_r,nfft).*fft(H,nfft),2)));
%     disp(['Ended binaural synthesis in ' num2str(toc(tb)) ' seconds.' ])
% end
% %  ------ end of Binaural synthesis (no batch overlap-save) ---------------

%  ------ Binaural synthesis (with batch overlap-save) ---------------
% Assuming p.Binaural is true
if p.Binaural
    disp('Started binaural synthesis with batch processing.'); tb = tic;
    
    % Define batch and overlap parameters
    batchSize = 1000; % Adjust this based on memory constraints
    overlapSize = length(p.hrir_l) - 1; % Assuming length of HRTF

    % Preallocate the binaural output
    Hbin = zeros(size(H, 1), 2); % Assuming 2 channels for binaural

    % Batch processing
    for startIdx = 1:batchSize:size(H, 1)
        endIdx = min(startIdx + batchSize - 1, size(H, 1));
        
        % Extract the batch with overlap
        batchIndices = max(1, startIdx - overlapSize):min(endIdx + overlapSize, size(H, 1));
        H_batch = H(batchIndices, :);
        
        % FFT of the batch
        H_batch_fft = fft(H_batch, length(H_batch) + length(p.hrir_l) - 1);
        hrir_l_fft = fft(p.hrir_l, size(H_batch_fft, 1));
        hrir_r_fft = fft(p.hrir_r, size(H_batch_fft, 1));

        % Convolution in frequency domain
        Hbin_l = real(ifft(H_batch_fft .* hrir_l_fft));
        Hbin_r = real(ifft(H_batch_fft .* hrir_r_fft));

        % Overlap-save: Store the results with overlap management
        outputIndices = startIdx:endIdx;
        if startIdx == 1
            Hbin(outputIndices, 1) = Hbin_l(1:length(outputIndices));
            Hbin(outputIndices, 2) = Hbin_r(1:length(outputIndices));
        else
            Hbin(outputIndices, 1) = Hbin(outputIndices, 1) + Hbin_l(overlapSize+1:overlapSize+length(outputIndices));
            Hbin(outputIndices, 2) = Hbin(outputIndices, 2) + Hbin_r(overlapSize+1:overlapSize+length(outputIndices));
        end

        % Clear variables specific to this batch after its processing
        clear H_batch H_batch_fft hrir_l_fft hrir_r_fft Hbin_l Hbin_r
    end

    disp(['Ended binaural synthesis in ' num2str(toc(tb)) ' seconds.']);
end
%  ------ end of Binaural synthesis (with batch overlap-save) ---------------

% --- Compensate for the difference between the distances of the
% loudspeakers ----
delays = round((max(p.lspLocs(:,3)) - p.lspLocs(:,3))/p.c*p.fs);

for lsp = 1:numOfLsp
    H(:,lsp) = [zeros(delays(lsp),1); H(1:end-delays(lsp),lsp)];   
end

% --- Draw the array if asked -----
if p.showArray
    plotArray(p.lspLocs, p.LFEchannel)
end

disp(['Ended synthesizing in ' num2str(toc(ts)) ' seconds.' ])

end

function plotArray(lspLocs, LFEchannel)
% plotArray(micLocs)
% Plot the geometry of loudspeaker locations, defined in lspLocs

% SDM toolbox : plotArray
% Sakari Tervo & Jukka P����tynen, Aalto University, 2011-2016
% Copyleft

[lspLocs(:,1),lspLocs(:,2), lspLocs(:,3)] = ...
    sph2cart(lspLocs(:,1)/180*pi,lspLocs(:,2)/180*pi, lspLocs(:,3));

numOfLsp = size(lspLocs,1);
figure
hold on
lfe = 1;
for m = 1:numOfLsp
    if any(m == LFEchannel)
        plot3(lspLocs(m,1),lspLocs(m,2),lspLocs(m,3),'color','k','Marker','s')
        text(lspLocs(m,1),lspLocs(m,2),lspLocs(m,3)-0.05,[ '\# ' num2str(m) ' LFE' num2str(lfe)]);
        lfe = lfe + 1;
    else
        plot3(lspLocs(m,1),lspLocs(m,2),lspLocs(m,3),'color','k','Marker','o')
        text(lspLocs(m,1),lspLocs(m,2),lspLocs(m,3),[ '\# ' num2str(m)]);
        
    end
end

hold off;grid on;
view([35 45]);
axis square;
title('Loudspeaker Array Geometry in the Synthesis');
xlabel('X-coord.');ylabel('Y-coord.');zlabel('Z-coord.');

end

function xm_comp = equalizeNLS(x_sdm,x_ref,winLen)
% xm_comp = equalizeNLS(x_sdm,x_ref,winLen)
% Matches the x_sdm spectrogram to x_ref with overlap-add in a windows of
% size winLen.
%
% USAGE:
% 
% x_comp : Spectrogram matched impulse responses, same size as x_sdm
% x_sdm  : Matrix of impulse responses subject to compensation [N numOfLoudspeakers]
% x_ref  : Vector including reference impulse response for compensation [N 1]
% winLen : window length in samples
% 
% EXAMPLES:
% 
% xm_comp = equalizeNLS(randn(1000,24),randn(1000,1),128);
%
% For further usage see See synthesizesSDMCoeffs.m

% SDM toolbox : equalizeNLS
% Sakari Tervo & Jukka P����tynen, Aalto University, 2011-2016
% Copyleft

% Add zeros to fully construct the IR
N = size(x_sdm,1);
x_sdm = [zeros(winLen,size(x_sdm,2));x_sdm;zeros(winLen,size(x_sdm,2))];
x_ref = [zeros(winLen,size(x_ref,2));x_ref;zeros(winLen,size(x_ref,2))];

% Overlap-add parameters
win = hanning(winLen);
win = win/max(win);
nfft = winLen;
startx = 1;
endx = winLen;
nforward = winLen/2;

% Number of frames, i.e., windows
NN = round((size(x_sdm,1)-winLen)/nforward);

y = zeros(size(x_sdm,1)+2*nfft, size(x_sdm,2));
for n = 1:NN
    
    % Disply the current frame number
    if(mod(n,1000)==0)
        disp(['equalizeNLS: processing frame : ' num2str(n)])
    end
    
    % Reference frame and NLS impulse response frames
    X_ref = fft(bsxfun(@times, win, x_ref(startx:endx)),nfft*2);
    X_sdm = fft(bsxfun(@times, win, x_sdm(startx:endx,:)),nfft*2);
    
    % Compute the difference
    comp = sqrt(abs(X_ref).^2 ./ (sum(abs(X_sdm).^2,2)+eps));
    % Square
    Hf = sqrt(comp).*sqrt(conj(comp));
    % Calculate the compensated version of the NLS frames
    Yy = bsxfun(@times, Hf, X_sdm);
    % Back to the time-domain
    tempy = real(ifft(Yy));
    
    % Overlap-add
    y(startx:startx + nfft*2-1,:) = y(startx:startx + nfft*2-1,:) +  tempy;
    startx = startx + nforward;
    endx = endx + nforward;
    
end
% Truncate to the original size
xm_comp = y(winLen+1:winLen+N,:);

end

function y = fftconv(b, x, snfft)
% Convolution via fft for two impulse responses b and x
% b : First FIR
% x : Another FIR
% snfft : length of the result

% SDM toolbox : equalizeNLS
% Sakari Tervo & Jukka P����tynen, Aalto University, 2011-2016
% Copyleft

y = real(ifft(bsxfun(@times, fft(b,2*snfft), fft(x,2*snfft))));

y = y(snfft+1:end,:);
y = y(1:snfft,:);
end