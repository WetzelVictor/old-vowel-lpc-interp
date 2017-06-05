%%% VICTOR WETZEL, LAM 2017
% Interpolation of vowel using LPC

clear all
close all
clc

% importing data
[sig, Fe] = audioread('data/full-sentence.wav');


% Slicing vowels
a.sig = sig(89000:93000);


a.Fe = Fe;
o.Fe = Fe;

%%% Gathering basic infos about wav files

% vowel 'e'
%.N = length(o.sig);
%.t = [0:o.N] * o.To;
%.Te = 1 / o.Fe;
%.name = 'Temporal representation of vowel ''e''';

% vowel 'a'
a.N = length(a.sig);
a.Te = 1 / a.Fe;
a.t = [0:a.N] * a.Te;
a.name = 'Temporal representation of vowel ''a''';

%% LPC estimation
Nwin = 512;
noise = randn(1,Nwin);
a.win = hann(Nwin)';

a.A = lpc(a.sig(1,1:512).*a.win, 30);

a.est = filter(a.A, 1, noise);

figure;
plot(a.A);
hold on
plot(a.sig(1:512));
