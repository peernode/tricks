function ret =boxplot_show(array, lineSpec)
%CDF_SHOW Add two matrices
%    This function adds the two matrices passed as input. This function is
%    used to demonstate the functionality of MATLAB Compiler. Refer to the
%    shared library section of MATLAB Compiler for more information.

% Copynoright 2007 ZHOU Ting
sorted_array=sort(array);
sort_len=length(sorted_array);
plot(sorted_array, 0:1/sort_len:1-1/sort_len,lineSpec); 
ret=sorted_array;






