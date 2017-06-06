%%% VICTOR WETZEL, LAM 2017
% Interpolation of vowel using LPC

clear all
close all

% importing data
[sig, Fe] = audioread('data/full-sentence.wav');

% Analysis variables
Nwin = 512;
win = hann(Nwin);

% pre-emphasis filter
preemph = [1 0.63];
fsig = filter(1, preemph, sig);

% Slicing vowels
flagA = 2000;
flagB = flagA + Nwin* 10 - 1;
a.sig = fsig( flagA:flagB );


%%% Gathering basic infos about wav files
a.Fe = Fe;
a.N = length(a.sig);
a.Te = 1 / a.Fe;
a.t = [0:a.N - 1] * a.Te;
a.name = 'Temporal representation of vowel ''a''';
a.Nframes = a.N / Nwin;

%%% Synthesis signal
% creating source signal
noise = randn(Nwin , 1);
impTrain = zeros(length(noise), 1);
for i = 1:5
  impTrain(i * 100) = 1;
end

synthSource = impTrain;

% creating window
wintemp = win;
for i = 1:9
  win = [win wintemp];
end

clear wintemp


%% Plot signal for vowel  
figure;
plot(a.t, a.sig)
title(a.name)
xlabel('Time (s)')
ylabel('Amplitude')
grid on
saveas(gcf, 'vowel-a', 'png')


%% Computes LPC
% Reshapes matrix
a.frames = reshape(a.sig, Nwin, []);

% windowing signal
a.frames = a.frames .* win;
a.p = 25;
[a.A, a.E] = lpc(a.frames, a.p);

% synthesis
a.estimated = zeros(a.N, 0);


for i = 1: a.Nframes
  a.estimated([1:Nwin] * i, 1) = filter([-a.A(i,2:end)], 1, synthSource); 
end



% == GRAPH ==
figure;
plot(a.t, a.estimated)
title('LPC estimated signal')
xlabel('Time (s)')
ylabel('Amplitude')
grid on


