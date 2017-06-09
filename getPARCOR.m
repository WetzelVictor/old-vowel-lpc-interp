% function [A, E, L] = getPARCOR(x, p, w)
%
% Returns poles A, E prediction error, K the PARCORS
% x : signal vectors
% p : number of poles
% w : window 
%

function [A, E, L] = getPARCOR(x, p, w)

%% BASIC INFO
Nw = length(w);
N = length(x);
x = reshape(x, Nw, [] );
[~ , Nf] = size(x);

