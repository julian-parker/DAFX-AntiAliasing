function [ out ] = HardClip0( in )
% First antiderivative of hard clipping function

if (in > 1)
    out = in - 0.5;
elseif (in < -1)
     out = -in -0.5;
else
    out = in*in * 0.5;
end

end
