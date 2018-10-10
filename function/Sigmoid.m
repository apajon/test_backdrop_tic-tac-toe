function [y]=Sigmoid(x)
%x and y are vectors
%return y=f(x)=1/(1+exp(-x))
if ~isvector(x)
    msg='the input of Sigmoid() must be a vector \n';
    errormsg=[msg];
    error(errormsg,[])
end

y=1./(1+exp(-x));
    
end