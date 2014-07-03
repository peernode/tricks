function ret_index = fairness_index(proc_matrix,sta_num)
%ADDMATRIX Add two matrices
%    This function adds the two matrices passed as input. This function is
%    used to demonstate the functionality of MATLAB Compiler. Refer to the
%    shared library section of MATLAB Compiler for more information.
% Copyright 2003 The MathWorks, Inc.


ret_index=[];

[d1,d2]=size(proc_matrix)

for i=1:d1; 
    
N=sta_num(i);
total_N_x=sum(proc_matrix(i,1:sta_num(i)));
total_N_x_2=0;

for j=1:sta_num(i);  
total_N_x_2=total_N_x_2+proc_matrix(i,j)^2;
end

ret_index(i)=total_N_x^2/(N*total_N_x_2);

end

