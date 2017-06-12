% function [A, E, L] = getPARCOR(x, p, w)
%
% Returns poles A, E prediction error, K the PARCORS
% x : signal vectors
% p : number of poles
% w : window 
%

function [A, E, K] = getPARCOR(x, p, w)

%% BASIC INFO
Nw = length(w);
N = length(x);
x = reshape(x, Nw, []); % Eventuellement, stackOLA
[~ , Nf] = size(x);

%% INSTANCIATION
A = zeros(p+1, Nf);
E = zeros(p, Nf);
K = zeros(p, Nf);

%% COMPUTING
for i = 1 : Nf,
  % Autocorrelation coefs put as a Toeplitz matrix
  y = xcorr( x(:, i), 'biased');

  % Solving equation with levinson-durbin algorithm
  [A(:,i), E(:,i), K(:,i)] = levinson(y, p);
end

end
