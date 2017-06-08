close all; clear all; clc;

%% load audio
[x, Fe] = audioread('data/full-sentence.wav');

x = 0.9*x/max(abs(x)); % normalize
x = resample(x, 16000/2, Fe);
Fe = 16000/2;

%% prep
% WINDOW
Nwin = floor(0.03*Fe);% using 30ms Hann window
w = hann(Nwin, 'periodic'); % window creation

% GLOBAL VARIABLES
tInterp = 5; % time of interpolation
nInterp = floor(tInterp * Fe);
Nframes = floor(nInterp / Nwin); % number of frames
p = 15; % number of LPC poles 
[B, G] = lpcEncode(x, p, w);

% INSTANCIATION
Nframes = length(G);
F = ones(1, Nframes) * 440 / Fe; % pitch guide (Hz)
G = ones(1, Nframes) * 4.174937490656687e-03; % vocal effort 

%[F, ~] = lpcFindPitch(x, w, 5);

%% Interpolating poles
% loading poles
v1p = B(:,15);
v2p = B(:,85);

% ... into A
A = zeros(p, 2);
A(:,1) = sort(v1p);
A(:,2) = sort(v2p);

% Interpolate
A = interpolatePoles(A, Nframes);

%% LPC decode
interpolatedSig = lpcDecode(A, [G; F], w, 200/Fe);
interpolatedSig = interpolatedSig*0.9/max(abs(interpolatedSig));

%% Encoding result to .wav
audiowrite('output/interpolatedSignal.wav', interpolatedSig , Fe);
plot(interpolatedSig)
