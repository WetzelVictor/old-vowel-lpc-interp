close all; clear all; clc;


%% PREP 
% LOAD AUDIO 
[x, Fe] = audioread('data/full-sentence.wav');

x = 0.9*x/max(abs(x)); % normalize
x = resample(x, 44100, Fe);
Fe = 44100;

% WINDOW
Nwin = floor(0.03*Fe);% using 30ms Hann window
w = hann(Nwin, 'periodic'); % window creation

% GLOBAL VARIABLES
tInterp = 5; % time of interpolation
nInterp = floor(tInterp * Fe);
Nframes = floor(nInterp / Nwin); % number of frames
p = 8; % number of LPC poles 

% VECTOR INSTANCIATION
F = ones(1, Nframes) * 440; % pitch guide (Hz)
G = ones(1, Nframes) * 4e-03; % vocal effort 
interpolatedSig = zeros(Nwin, Nframes); % rendered signal

%% Interpolating poles
% Looking for poles
[B, G] = lpcEncode(x, p, w);

% loading poles
v1p = B(:, 20);
v2p = B(:, 10);

% ... into A
A = zeros(p, 2);
A(:,1) = sort(v1p, 'ascend');
A(:,2) = sort(v2p, 'ascend');

% Interpolate poles
A = interpolatePoles(A, Nframes);
src = impulseTrain(F, Nwin, Fe);

%% LPC decode
interpolatedSig = synthLPC(src, A, Fe);
interpolatedSig = reshape(interpolatedSig, 1, []);


%% Encoding result to .wav
interpolatedSig = interpolatedSig*0.9/max(abs(interpolatedSig));
% audiowrite('output/interpolatedSignal.wav', interpolatedSig , Fe);
plot(interpolatedSig)
