%%% VICTOR WETZEL, LAM 2017
% Interpolation of vowel using LPC

clear all
close all

% importing data
[sig, Fe] = audioread('data/full-sentence.wav');
sig = sig/max(abs(sig));
% Analysis variables
Nwin = 300;
win = hann(Nwin, 'periodic');

% pre-emphasis filter
preemph = [1 0.63];
fsig = filter(1, preemph, sig);

% Slicing vowels
flagA = 2000;
flagB = flagA + Nwin* 10 - 1;
a.sig = fsig( flagA:flagB );


%% Gathering basic infos about wav files
a.Fe = Fe;
a.N = length(a.sig);
a.Te = 1 / a.Fe;
a.t = [0:a.N - 1] * a.Te;
a.name = 'Temporal representation of vowel ''a''';
a.Nframes = a.N / Nwin;
a.p = 8;

%% Plot signal for vowel  
figure;
plot(a.t, a.sig)
title(a.name)
xlabel('Time (s)')
ylabel('Amplitude')
grid on


%% Computes LPC
[a.A, a.G] = lpcEncode(a.sig, a.p, win);
a.estimated = lpcDecode(a.A, a.G, win);

figure;
plot(a.t, a.estimated, a.t, a.sig)
title(a.name)
xlabel('Time (s)')
ylabel('Amplitude')
grid on
legend('estimated signal','original signal')

