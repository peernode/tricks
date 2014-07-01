function get_ip_int(ip_string)
{
        ip_int=0;
        split(ip_string, ip, ".");

        return ip[1]*256*256*256+ip[2]*256*256+ip[3]*256+ip[4];
}

function binary_search_ip(ip_begin, ip_end, ip_addr)
{
        start=0;
        end =length(ip_begin);
        while(start<=end){
                mid=int(start+(end-start)/2);
                if(ip_addr>=ip_begin[mid]&&ip_addr<=ip_end[mid]){
                        break;
                }else if(ip_addr>ip_end[mid]){
                        start=mid+1;
                }else{
                        end=mid-1;
                }
        }

        return mid;
}
