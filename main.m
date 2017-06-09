close all; clear all; clc;

%% PREP 
% LOAD AUDIO 
[x, Fe] = audioread('data/full-sentence.wav');
x = 0.9*x/max(abs(x)); % normalize

% WINDOW
Nwin = floor(0.03*Fe);% using 30ms Hann window
w = hann(Nwin, 'periodic'); % window creation

% GLOBAL VARIABLES
tInterp = 5; % time of interpolation
nInterp = floor(tInterp * Fe);
Nframes = floor(nInterp / Nwin); % number of frames
p = 25; % number of LPC poles 
Te = 1/ Fe;
fmax = Fe / 2;

% PLOT VECTORS
t = [0 : nInterp] * Te;
f = [-fmax : Fe/nInterp : fmax];

% VECTOR INSTANCIATION
F = ones(1, Nframes) * 440; % pitch guide (Hz)
G = ones(1, Nframes) * 4e-03; % vocal effort 
interpolatedSig = zeros(Nwin, Nframes); % rendered signal

%% Interpolating poles
% On remplace cette ligne par ma propre fonction
% en mode getPARCOR
[A, E, K] = getPARCOR(x, p, w);
% loading poles
flagA = 0;
flagB = 0; % afficher les flags sur un graph temporel
v1p = B(:, flagA);
v2p = B(:, flagB);

A = zeros(p, 2);
A(:,1) = sort(v1p, 'ascend');
A(:,2) = sort(v2p, 'ascend');

% Interpolate poles
A = interpolatePoles(A, Nframes);

%% LPC decode
% Create source signal
src = impulseTrain(F, Nwin, Fe);

% synthesize
interpolatedSig = synthLPC(src, A, Fe);
interpolatedSig = reshape(interpolatedSig, 1, []);

%% Encoding result to .wav
interpolatedSig = interpolatedSig*0.9/max(abs(interpolatedSig));
% audiowrite('output/interpolatedSignal.wav', interpolatedSig , Fe);
plot(f, abs(fftshift(fft(interpolatedSig, length(f)))))
