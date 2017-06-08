% synthLPC.m
% Filters signal with a given source signal x with poles A
%
% src - source signal (Nwin, Nframes)
% A - poles (p, Nframes)
% Fe - sampling rate (Hz)

function sig = synthLPC(src, A, Fe),

[Nwin, Nframes] = size(src);

tempSig = zeros(Nwin, Nframes);

for i = 1 : Nframes,
  % Filters actual frame i 
  tempSig(:, i) = filter(1, A(:,i), src(:,i));
  
  %% LOWCUT
  cutoff = 100; % cutoff frequency (Hz)
  cutoff = cutoff * 2 / Fe;
  [b, a] = butter(10, cutoff, 'high');
  tempSig(:,i) = filter(b, a, tempSig(:,i) );
end

sig = tempSig;
end
