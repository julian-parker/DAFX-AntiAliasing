function [ out ] = Tanh1( in )
% First moment of tanh(x) (integral of x tanh(x))
% NOTE: You will need to provide your own implementation of the dilog function
out =0.5* (in* (in+2*log(1+exp(-2*in)))-dilog(-exp(-2*in)));
end
