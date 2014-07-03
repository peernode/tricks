function lineStyle = get_linetype(color_offset,marker_offset,type_offset)

Color_Array=['b';'r';'g';'c';'m';'k'];
Marker_Array=['o';'v';'d';'s';'<';'>';'x';'^';'*';'+'];
LineStyle_Array=[': ';'-.';'- ';'--'];


%type_offset=1;
%color_offset=1
%marker_offset=1;

if(color_offset ~= -1)
    ln_color= mod(color_offset,length(Color_Array))+1;
end

if(marker_offset ~= -1)
    marker=mod(marker_offset,length(Marker_Array))+1;    
end


switch type_offset
   case 1
      lineType='-';
   case 2
      lineType='-.';
   case 3
     lineType='--';
   case 4
     lineType=':';
   otherwise
     lineType='-';
end

if(color_offset ~= -1) && (marker_offset ~= -1)
   lineStyle=sprintf('%s%s%s',Color_Array(ln_color),Marker_Array(marker),lineType); 
elseif (marker_offset ~= -1)
   lineStyle=sprintf('%s%s',Marker_Array(marker),lineType); 
elseif  (color_offset ~= -1)
   lineStyle=sprintf('%s%s',Color_Array(ln_color),lineType);   
else
   lineStyle=sprintf('%s',lineType);     
end

