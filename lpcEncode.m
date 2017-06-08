
% Encodes the input signal into lpc coefficients using 50% OLA
%
% x - single channel input signal
% p - lpc order
% nw - window length
% 
% A - the coefficients
% G - the signal power
%
function [A, G] = lpcEncode(x, p, w)

X = stackOLA(x, w); % stack the windowed signals
[nw, n] = size(X);

%% Instanciate variables
A = zeros(p, n);
G = zeros(1, n);

%% LPC encode
for i = 1:n,
    % Computing LPC
    [a, g] = lpc(X(:,i), p - 1);
    % [a,g] = levinson( X(:,i), p-1 );

    % Store result
    A(:, i) = a;
    G(i) = g;
end
