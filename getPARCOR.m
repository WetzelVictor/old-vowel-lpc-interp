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
x = reshape(x, Nw, []); % Eventuellement, stackOLA
[~ , Nf] = size(x);

%% INSTANCIATION
A = zeros(p, Nf);
E = zeros(p, Nf);
K = zeros(p, Nf);

%% COMPUTING
for i = 1 : Nf,
  y = xcorr( x(:, i), 'biased');
  [A(:,i), E(:,i), K(:,i)] = levinson(y,p);
end

end
