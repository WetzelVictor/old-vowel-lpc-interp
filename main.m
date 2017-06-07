close all; clear all; clc;

%% load audio
[x, Fe] = audioread('data/full-sentence.wav');

x = mean(x, 2); % mono
x = 0.9*x/max(abs(x)); % normalize

x = resample(x, 8000, Fe); % resampling to 8kHz
Fe = 8000;

w = hann(floor(0.03*Fe), 'periodic'); % using 30ms Hann window


%% LPC encode 
p = 24; % using 6th order
[A, G] = lpcEncode(x, p, w);


%% pitch detection
[F, ~] = lpcFindPitch(x, w, 5);


%% LPC decode
xhat = lpcDecode(A, [G; F], w, 200/Fe);


%% save result to file
audiowrite('output/lpc_pitch_example.wav', xhat, Fe); % uncomment to save to file
