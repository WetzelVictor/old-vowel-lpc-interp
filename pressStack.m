%% Based on Hyung-Suk Kim's work
% Renders an overlap-add stack into the original signal.
% It assumes the stacked signals are already windowed.
%
% X - a stacked overlap-add
% R (optional, default = 0.5) - step size
% x - the rendered signal
%
function x = pressStack(X, R)

[nw, count] = size(X);

if nargin < 2
  R = floor(nw*0.5);
end

n = (count-1)*R+nw;

x = zeros(n, 1);

for i = 1:count
   x( (1:nw) + R*(i-1) ) = x( (1:nw) + R*(i-1) ) + X(:, i);
end
