function p_z=pdf_show(x_z,num,lineSpec) 

Z_max=max(x_z);
Z_min=min(x_z);
z=linspace(Z_min,Z_max,num);  

 
p_z=hist(x_z,z)/length(x_z)/abs(z(2)-z(1)); 
 

plot(z,p_z,lineSpec); 
%    xlabel('z'); 
%    ylabel('p_x(z)'); 

