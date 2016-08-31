function [ out ] = HardClip( in )
% Naive hard clipping function

if (in > 1)
    out = 1;
elseif (in < -1)
     out = -1;
else
    out = in;
end

end
