close all; clear all; clc;

%% PREP 
% LOAD AUDIO 
[x, Fe] = audioread('data/full-sentence.wav');
x = 0.9*x/max(abs(x)); % normalize

% WINDOW
Nwin = 1024; % using 30ms Hann window, trouver un nombre qui marche
w = hann(Nwin, 'periodic'); % window creation

% ZERO PADDING
% if signal cannot be divided in equal chunks
while (mod(length(x),Nwin))>0,
  x = [x; 0];
end

%% GLOBAL VARIABLES
% ANALYSIS
tInterp = 5; % time of interpolation
nInterp = floor(tInterp * Fe);
Nframes = floor(nInterp / Nwin); % number of frames
p = 6; % number of LPC poles 
Te = 1/ Fe;
fmax = Fe / 2;

% PLOT VECTORS
t = [0 : nInterp] * Te;
f = [-fmax : Fe/nInterp : fmax];

% VECTOR INSTANCIATION
F = ones(1, Nframes) * 440; % pitch guide (Hz)
G = ones(1, Nframes) * 4e-03; % vocal effort 
interpolatedSig = zeros(Nwin, Nframes); % rendered signal
T = zeros(p, 2);
poles = zeros(p + 1, Nframes);

%% Interpolating poles
% Computes reflection coefficients
[A, E, K] = getPARCOR(x, p, w);

% loading poles
flagA = 100;
flagB = 50; % afficher les flags sur un graph temporel
v1p = K(:, flagA);
v2p = K(:, flagB);

T(:,1) = sort(v1p, 'ascend');
T(:,2) = sort(v2p, 'ascend');

% Interpolate poles
T = interpolatePoles(T, Nframes);

for i = 1 : Nframes,
  poles(:,i) = rc2poly(T(:,i));
end

%% LPC decode
% Create source signal
src = impulseTrain(F, Nwin, Fe);

% synthesize
interpolatedSig = synthLPC(src, poles, Fe);
interpolatedSig = reshape(interpolatedSig, 1, []);

%% Encoding result to .wav
interpolatedSig = interpolatedSig*0.9/max(abs(interpolatedSig));
% audiowrite('output/interpolatedSignal.wav', interpolatedSig , Fe);
plot(f, abs(fftshift(fft(interpolatedSig, length(f)))))
