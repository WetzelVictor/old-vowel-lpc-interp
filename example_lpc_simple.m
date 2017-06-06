close all; clear all; clc;

%% load audio
[x, fs] = wavread('audio/speech2.wav');

x = mean(x, 2); % mono
x = 0.9*x/max(abs(x)); % normalize

x = resample(x, 8000, fs);% resampling to 8kHz
fs = 8000;

w = hann(floor(0.03*fs), 'periodic'); % using 30ms Hann window


%% LPC encode 
p = 6; % using 6th order
[A, G] = lpcEncode(x, p, w);


%% LPC decode
xhat = lpcDecode(A, G, w);


%% compare amount of data
nSig = length(x);
disp(['Original signal size: ' num2str(nSig)]);
sz = size(A);
nLPC = sz(1)*sz(2) + length(G);
disp(['Encoded signal size: ' num2str(nLPC)]);
disp(['Data reduction: ' num2str(nSig/nLPC)]);


%% listen to resynthesized signal
% uncomment the lines below to play the estimated signal
% apLPC = audioplayer(xhat, fs);
% play(apLPC); 


%% save result to file
wavwrite(xhat, fs, ['output/lpc_breathy_' num2str(p) '.wav']);
