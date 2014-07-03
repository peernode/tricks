function [service,mean_val] = mean_nozero(proc_array)
%ADDMATRIX Add two matrices
%    This function adds the two matrices passed as input. This function is
%    used to demonstate the functionality of MATLAB Compiler. Refer to the
%    shared library section of MATLAB Compiler for more information.
% Copyright 2003 The MathWorks, Inc.


service=0;
mean_val=0;

for i=1:length(proc_array)

if(proc_array(i)>0)
 service=service+1;
 
end

end


if(service>0)
mean_val = sum(proc_array)/service;
%%stdev = sqrt(sum((proc_array-mean_val).^2/service));
end











