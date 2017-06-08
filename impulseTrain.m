% impulseTrain(F, Nwin, Fe)
% Create a impulse train depending on a vector F containing frequency target 
% for every frames
%
% F: frequency vector for each frame
% Nwin: number of samples per frame
% Fe: samplerate (Hz)

function F = impulseTrain(F, Nwin, Fe)
Nframes = length(F) 
% N = Nframes* Nwin ;
f = zeros(Nwin,Nframes);

%% Loop variables
offset = 0; step = 0;

for i = 1:Nframes,
  step = floor(Fe / F(1,i)); % computing step size 
  count = step; 
  
  for j = 1:Nwin,
    % if last loop got out of the vector, it applies an offset 
    if offset > 0
      count = offset;
      offset = 0;
    end
    
    % check if count = 0
    if count == 0,
      f(j, i) = 1;
      count = step;
    else
      count = count - 1;
    end

    
    % computing the offset size only if the algorithm
    % is reaching out of the vector
    if count + step > Nwin,
      offset = step - Nframes + j;
      break;
    end


  end
end

%% END
F = f;
