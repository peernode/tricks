function ret = fig_save_to_file(fig_id,file_name,type,bSub_dir)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parameter Definition
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% type 0: save to emf, 1: save to eps, 2: save to all types, 3: save to
%% png, 4: save to pdf
%% bSub_dir 0: output to current directory, 1: output to subdirectory
%% 
%% 
%% for example fig_save_to_file(hf,'Service_Number_vs_Station_Sum',2,1);
%% 
%% 
%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ret=0;

fig_handle_opt=sprintf('-f%d',fig_id); 

if(bSub_dir==1)

switch type
case 0
if exist('emf','dir') == 0
mkdir('emf')
end
case 1
if exist('eps','dir') == 0
mkdir('eps')
end
case 3
if exist('png','dir') == 0
mkdir('png')
end
case 4
if exist('pdf','dir') == 0
mkdir('pdf')
end
otherwise
if exist('emf','dir') == 0
mkdir('emf')
end
if exist('eps','dir') == 0
mkdir('eps')
end
if exist('png','dir') == 0
mkdir('png')
end
if exist('pdf','dir') == 0
mkdir('pdf')
end
end



end

if(bSub_dir==1)
fig_file_name_emf='emf\';
fig_file_name_emf=strcat(fig_file_name_emf,file_name);
else
fig_file_name_emf=file_name;
end
fig_file_name_emf=strcat(fig_file_name_emf,'.emf');

if(bSub_dir==1)
fig_file_name_eps='eps\';
fig_file_name_eps=strcat(fig_file_name_eps,file_name);
else
fig_file_name_eps=file_name;
end
fig_file_name_eps=strcat(fig_file_name_eps,'.eps');

if(bSub_dir==1)
fig_file_name_png='png\';
fig_file_name_png=strcat(fig_file_name_png,file_name);
else
fig_file_name_png=file_name;
end
fig_file_name_png=strcat(fig_file_name_png,'.png');

if(bSub_dir==1)
fig_file_name_pdf='pdf\';
fig_file_name_pdf=strcat(fig_file_name_pdf,file_name);
else
fig_file_name_pdf=file_name;
end
fig_file_name_pdf=strcat(fig_file_name_pdf,'.pdf');

switch type
case 0
print(fig_handle_opt,'-dmeta', fig_file_name_emf);
case 1
print(fig_handle_opt,'-depsc2', fig_file_name_eps);
case 3
print(fig_handle_opt,'-dpng', fig_file_name_png);
case 4
delete(fig_file_name_pdf);
print(fig_handle_opt,'-dpdf', fig_file_name_pdf);
otherwise
print(fig_handle_opt,'-dmeta', fig_file_name_emf);
print2eps(fig_file_name_eps,fig_id);
%print(fig_handle_opt,'-depsc2', fig_file_name_eps);
delete(fig_file_name_pdf);
eps2pdf(fig_file_name_eps,fig_file_name_pdf,true);
print(fig_handle_opt,'-dpng', fig_file_name_png);

end






