close all; clear all; clc;

%% load audio
[x, Fe] = audioread('data/full-sentence.wav');

x = mean(x, 2); % mono
x = 0.9*x/max(abs(x)); % normalize


%% prep
% WINDOW
Nwin = floor(0.03*Fe);% using 30ms Hann window
w = hann(floor(0.03*Fe), 'periodic'); % window creation

% GLOBAL VARIABLES
tInterp = 5; % time of interpolation
nInterp = floor(tInterp * Fe);
Nframes = floor(nInterp / Nwin); % number of frames
p = 8; % number of LPC poles 

% INSTANCIATION

[B, G] = lpcEncode(x, p, w);
Nframes = length(G);
%F = ones(1, Nframes) * 440 / Fe; % pitch guide (Hz)
%G = ones(1, Nframes) * 4.174937490656687e-03; % vocal effort 

[F, ~] = lpcFindPitch(x, w, 5);

%% Interpolating poles
% loading poles
v1p = B(:,20);
v2p = B(:,5);

% ... into A
A = zeros(p, 2);
A(:,1) = v1p;
A(:,2) = v2p;

% Interpolate
A = interpolatePoles(A, Nframes);
%% LPC encode 
%% pitch detection


%% LPC decode
interpolatedSig = lpcDecode(B, [G; F], w, 200/Fe);
%interpolatedSig = interpolatedSig*0.9/max(abs(interpolatedSig));

%% Encoding result to .wav
%audiowrite('output/interpolatedSignal.wav', interpolatedSig , Fe);
