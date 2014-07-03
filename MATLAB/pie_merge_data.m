function [legend_str,pie_data] = pie_merge_data(label,data_sum,top_threshold)

[a,b]=sort(data_sum,'descend');

if length(a)<top_threshold
    top_threshold=length(a)
end     

top_set_sum=a(1:top_threshold);
total_sum=sum(data_sum);
others=total_sum-sum(top_set_sum);

pie_data=[top_set_sum;others];

legend_str={};

legend_str=label(b(1:top_threshold));

legend_str{length(pie_data)}='Others';

lth=length(pie_data);

for i=1:lth
 legend_str{i}=sprintf('%s (%.1f%%)',legend_str{i},pie_data(i)/sum(pie_data)*100);
end

