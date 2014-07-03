function ret = delay_proc(fileName)
%ADDMATRIX Add two matrices
%    This function adds the two matrices passed as input. This function is
%    used to demonstate the functionality of MATLAB Compiler. Refer to the
%    shared library section of MATLAB Compiler for more information.
% Copyright 2003 The MathWorks, Inc.


delayArray=[];
fid = fopen(fileName);

tline = fgetl(fid); %%don't parse the firt line
    
i=1;
while 1
    tline = fgetl(fid);
    if ~ischar(tline),   break,   end
    %disp(tline)

%%delayArray(i,:)=sscanf(tline,'%d\t%f\t%f\t%f\t%s\t%s');
delayArray(i,:)=sscanf(tline,'%d\t%f\t%f\t%f');
i=i+1;
end

fclose(fid);
ret=delayArray;


