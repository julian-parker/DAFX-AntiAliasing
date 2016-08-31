function [ out ] = HardClip1( in )
% First moment (integral of x f(x)) of hard clipping function

if (in > 1)
    out = in*in*0.5 - (1/6);
elseif (in < -1)
     out = -in*in*0.5 + (1/6);
else
    out = in*in*in/3;
end

end
