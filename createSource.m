% createSource(F, Nwin, Fe)
% Create a impulse train depending on a vector F containing frequency target 
% for every frames
%
% F: frequency vector for each frame
% Nwin: number of samples per frame
% Fe: samplerate (Hz)

function F = createSource(F, Nwin, Fe)
Nframes = length(F);
N = Nframes* Nwin ;
f = zeros(1,N);

%% Loop variables
offset = 0; step = 0;

for i = 1:Nframes,
  step = floor(Fe / F(1,i)); % computing step size 
  
  
  for j = 1:Nwin,
    % if last loop got out of the vector, it applies an offset 
    if offset > 0
      j = j + offset;
      offset = 0;
    end
   

    % computing where to put the sample 
    flag = (i - 1) * Nwin + j; 
    f(1,flag) = 1;
    
    % computing the offset size only if the algorithm
    % is reaching out of the vector
    if j + step > Nwin,
      offset = step - Nframes + j;
      break;
    else
      j = j + step;
    end
  end
end

%% END
F = f;
