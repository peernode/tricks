#! /bin/igawk -f

@include common_funs.awk

BEGIN{
    FS="[, \t+]"
}

NR==FNR{
    ip_begin[k]=$1;
    ip_end[k]=$2;
    province[k]=$3;
    net_operator[k]=$4;
    k++;
}

NR>FNR {
    clientIP=$4;
    clientIP_int = get_ip_int(clientIP);
    guid=$7;
    host_idx=binary_search_ip(ip_begin, ip_end, clientIP_int);
    print host_idx, province[host_idx], net_operator[host_idx];
}

END{
}
