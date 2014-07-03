close all;
clear all;
format long g;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Graph Output Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
bGraph_output_to_file=1;
save_to_sub_dir=1;
save_file_type=3;

scrsz=get(0, 'ScreenSize');

date='20130926';
fardir='E:\data_analysis\temp\';
filename='add_1.0.0.26Beta_20130926.log';
fileformat='%d\t%*s\t%*s\t%d\t%d\t%d\t%d\t%d';

[time, post, unchoked, not_unchoke_sent, unchoke_sent, temp]=textread(filename, fileformat);

hf=figure('Position', [100 scrsz(4)/2-300 scrsz(3)/1.4 scrsz(4)/2+200]);
cdf_show(temp, 'r');