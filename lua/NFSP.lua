--本脚本解析的是2.8.3客户端与ms之间、ms与ms之间的交互协议NFSP
--by huangsb -- 2014.03.20
do
	--Proto用来注册新协议
	local p_nfsp = Proto("nfsp","New Funshion Service Protocol")

	--ProtoField.***定义将在包详细信息面板显示的字段
	local f_res = ProtoField.uint32("nfsp.res","reserved",base.HEX)
	local f_key_index = ProtoField.uint8("nfsp.keyindex","key_index",base.HEX)
	local f_key_version = ProtoField.uint8("nfsp.keyver","key_version",base.HEX)
	local f_key_value = ProtoField.uint16("nfsp.keyvalue","key_value",base.HEX)
	local f_random_key = ProtoField.uint16("nfsp.randomkey","key_random",base.HEX)
	local f_decode_key = ProtoField.uint16("nfsp.decode","key_decode",base.HEX)
	local f_p_len = ProtoField.uint16("nfsp.length","length",base.DEC)
	local f_p_type = ProtoField.uint16("nfsp.type","type",base.HEX)
	local f_p_version = ProtoField.uint16("nfsp.pversion","pversion",base.HEX)
	local f_p_session_id= ProtoField.uint16("nfsp.sessionid","session_id",base.DEC)
	local f_p_request_idx= ProtoField.uint32("nfsp.idx","idx",base.DEC)
	local f_p_request_offset= ProtoField.uint32("nfsp.offset","offset",base.DEC)
	local f_p_request_len= ProtoField.uint32("nfsp.len","len",base.DEC)
	local f_p_payload_len= ProtoField.uint32("nfsp.payload","payload",base.DEC)
	
	local f_p_file_idx= ProtoField.uint32("nfsp.file_idx","file_idx",base.DEC)
	local f_p_file_offset= ProtoField.uint32("nfsp.file_offset","file_offset",base.DEC)
	local f_p_file_len= ProtoField.uint32("nfsp.file_len","file_len",base.DEC)
	local f_p_file_count= ProtoField.uint32("nfsp.file_count","file_count",base.DEC)
	local f_p_file_status= ProtoField.uint32("nfsp.file_status","file_status",base.DEC)
	
	local f_len = ProtoField.uint32("nfsp.len","length")
	
	local f_ihash= ProtoField.bytes("nfsp.ihash","hash",base.HEX)
	local f_peerid = ProtoField.bytes("nfsp.peerid","peerid",base.HEX)
	local f_reason = ProtoField.uint32("nfsp.reason","reason",base.HEX)
	local f_bitfield = ProtoField.bytes("fsp.bitfield","bitfield",base.HEX)
	local f_index = ProtoField.uint32("fsp.index","index",base.DEC)
	local f_begin = ProtoField.uint32("fsp.begin","begin",base.DEC)
	local f_reqlen = ProtoField.uint32("fsp.reqlen","length",base.DEC)
	local f_block = ProtoField.bytes("fsp.block","block",base.HEX)
	local f_chksum = ProtoField.uint16("fsp.chksum","Checksum",base.HEX)
	local f_retcode = ProtoField.uint32("fsp.retcode","Code",base.HEX)
	local f_content = ProtoField.bytes("fsp.content","content",base.HEX)
	
	local nfsp_keyg_v1={
		0x8d4e, 0x9c74, 0xa591, 0xb96e, 
		0xca25, 0xd32d, 0xe6a6, 0xfc1d, 
		0xf19a, 0xec9f, 0xd8b0, 0xc36c,
		0xb2b3, 0xa91a, 0x927c, 0x872b
	};

    -- 前面定义的字段，需要通过p_heartbeat.fields注册才能在包详细信息面板中显示出来
	p_nfsp.fields = {f_p_type,f_retcode,f_content,f_chksum,f_res,f_len,f_type,f_pver,f_sid,f_ihash,f_peerid,
		f_reason,f_bitfield,f_index,f_begin,f_reqlen,f_block,f_key_index,f_key_version,f_key_value,f_random_key,
		f_decode_key,f_p_version,f_p_len,f_p_session_id,f_p_request_idx,f_p_request_offset,f_p_request_len,f_p_payload_len,
		f_p_file_idx,f_p_file_offset,f_p_file_len,f_p_file_count,f_p_file_status}

	local function head_dissector(buf,pinfo,t)
	    local key_idx=bit.rshift(buf(2,1):uint(),4)
	    local  key_ver = bit.band(buf(2,1):uint(),0x0F)
	    local random_key=buf(0,2):uint()
	    local  key=nfsp_keyg_v1[key_idx+1]--start from 1 not 0
	    local decode_key=bit.bxor(key, random_key)
	    local  l=buf(6,2):uint()
	    local  m=buf(8,2):uint()
	    local  n=buf(10,2):uint()
	    local  p=buf(12,2):uint()
	    local  length = bit.bxor(decode_key,l)
	    local  ptype = bit.bxor(decode_key,m)
	    local  version=bit.bxor(decode_key,n)
	    local  session=bit.bxor(decode_key,p)
	    local sub_t=t:add(buf(0,14),"Media Server Header(14 bytes)")
	    
		sub_t:append_text(string.format(" : the header was encrypted with 0x%04x",key))
		
		sub_t:add(f_key_index,key_idx)
		sub_t:add(f_key_version,key_ver)
		sub_t:add(f_key_value,key)
		sub_t:add(f_random_key,random_key)
		sub_t:add(f_decode_key,decode_key)
		
		sub_t:add(f_p_len,length)
		sub_t:add(f_p_type,ptype)
		sub_t:add(f_p_version,version)
		sub_t:add(f_p_session_id,session)
	end
	
	--0x0601
	local function handshake_dissector(buf,pinfo,t)
	    local sub_t=t:add(buf(14,40),"Handshake Message")
		sub_t:add(f_ihash,buf(14,20))
		sub_t:add(f_peerid,buf(34,20))
		pinfo.cols.info="Handshake Message"
    end
    
    	--0x0602
	local function keepalive_dissector(buf,pinfo,t)
	    local sub_t=t:add(buf(0,14),"KeepAlive Message")
		pinfo.cols.info="KeepAlive Message"
    end
    
    --0x0603
	local function choke_dissector(buf,pinfo,t)
	    local sub_t=t:add(buf(0,18),"choke Message")
		pinfo.cols.info="choke Message"
		sub_t:add(f_res,buf(14,4))
    end
    
     --0x0604
	local function unchoke_dissector(buf,pinfo,t)
	    local sub_t=t:add(buf(0,18),"unchoke Message")
		pinfo.cols.info="unchoke Message"
		sub_t:add(f_res,buf(14,4))
    end
    
     --0x0605
	local function interest_dissector(buf,pinfo,t)
	    local sub_t=t:add(buf(0,18),"interest Message")
		pinfo.cols.info="interest Message"
		sub_t:add(f_res,buf(14,4))
    end
    
     --0x0606
	local function uninterest_dissector(buf,pinfo,t)
	    local sub_t=t:add(buf(0,18),"uninterest Message")
		pinfo.cols.info="uninterest Message"
		sub_t:add(f_res,buf(14,4))
    end
    
     --0x0607
	local function deny_dissector(buf,pinfo,t)
	    local sub_t=t:add(buf(0,18),"deny Message")
		pinfo.cols.info="deny Message"
    end    
    
    --0x0608
    	local function bitfield_dissector(buf,pinfo,t)
    		local buf_len=buf:len()
	    local sub_t=t:add(buf(0,-1),"bitfield Message")
		sub_t:add(f_block,buf(14,-1))
		pinfo.cols.info="Bitfiled Message"		
    end
    
     --0x0609
    	local function have_dissector(buf,pinfo,t)
    		local buf_len=buf:len()
	    local sub_t=t:add(buf(0,-1),"have Message")
		pinfo.cols.info="have Message"		
    end
    
     --0x060A
    	local function request_dissector(buf,pinfo,t)
    		if buf:len() < 26 then
    			return false
    		end
    		
	    local sub_t=t:add(buf(14,12),"request Message")
	    
	    sub_t:append_text(":request")
	    sub_t:add(f_p_request_idx,  buf(14,4) )
	    sub_t:add(f_p_request_offset,  buf(18,4) )
	    sub_t:add(f_p_request_len,  buf(22,4) )
		pinfo.cols.info="request Message"		
    end
    
    	--0x0601
	local function handshake_dissector(buf,pinfo,t)
	    local sub_t=t:add(buf(0,54),"Handshake Message")
		sub_t:add(f_ihash,buf(14,20))
		sub_t:add(f_peerid,buf(34,20))
		pinfo.cols.info="Handshake Message"
    end
    
     --0x060B
    	local function piece_dissector(buf,pinfo,t)
    		local buf_len=buf:len()
	    local sub_t=t:add(buf(0,-1),"piece Message")
	    sub_t:add(f_p_request_idx,buf(14,4))
	    sub_t:add(f_p_request_offset,buf(18,4))
		pinfo.cols.info="piece Message"		
    end
    
    --0x060C
    	local function badpiece_dissector(buf,pinfo,t)
    		local buf_len=buf:len()
	    local sub_t=t:add(buf(0,-1),"badpiece Message")
	    sub_t:add(f_p_request_idx,buf(14,4))
		pinfo.cols.info="badpiece Message"		
    end
    
     --0x060d
    	local function querymeta_dissector(buf,pinfo,t)
    		local buf_len=buf:len()
	    local sub_t=t:add(buf(0,-1),"querymeta Message")
	    sub_t:add(f_chksum,buf(14,2))
	    sub_t:add(f_content,buf(16,-1))
	    
	    if buf_len > 20 then
	   		sub_t:add(f_p_payload_len,buf(20,4))
	    		sub_t:add(f_content,buf(24,-1))
	    end
		pinfo.cols.info="querymeta Message"		
    end
    
     --0x060e
    	local function pushmeta_dissector(buf,pinfo,t)
    		local buf_len=buf:len()
	    local sub_t=t:add(buf(0,-1),"pushmeta Message")
	    sub_t:add(f_chksum,buf(14,2))
	    sub_t:add(f_retcode,buf(16,4))
	    
	    if buf_len > 20 then
	   		sub_t:add(f_p_payload_len,buf(20,4))
	    		sub_t:add(f_content,buf(24,-1))
	    end
		pinfo.cols.info="pushmeta Message"		
    end
    
     --0x060f
    	local function head_info_req_dissector(buf,pinfo,t)
    		local buf_len=buf:len()
	    local sub_t=t:add(buf(0,-1),"head info req Message")
	    sub_t:add(f_p_file_idx,buf(14,4))
	    sub_t:add(f_p_file_offset,buf(18,4))
	    sub_t:add(f_p_file_len,buf(22,4))
		pinfo.cols.info="head info req Message"		
    end
    
     --0x0610
    	local function head_info_resp_dissector(buf,pinfo,t)
    		local buf_len=buf:len()
	    local sub_t=t:add(buf(0,-1),"head info resp Message")
	    sub_t:add(f_p_file_count,buf(14,4))
	    local paylen=buf(14,4):uint()
	    if paylen>0 then
	    		sub_t:add(f_content,buf(28,-1))
	    end
		pinfo.cols.info="head info resp Message"		
    end
    
     --0x0611
    	local function head_data_req_dissector(buf,pinfo,t)
    		local buf_len=buf:len()
	    local sub_t=t:add(buf(0,-1),"head data req Message")
	    sub_t:add(f_p_file_idx,buf(14,4))
	    sub_t:add(f_p_file_offset,buf(18,4))
	    sub_t:add(f_p_file_len,buf(22,4))
		pinfo.cols.info="head info data Message"		
    end

     --0x0612
    	local function head_data_resp_dissector(buf,pinfo,t)
    		local buf_len=buf:len()
	    local sub_t=t:add(buf(0,-1),"head data resp Message")
	    sub_t:add(f_p_file_status,buf(14,4))
	    sub_t:add(f_p_file_idx,buf(18,4))
	    sub_t:add(f_p_file_offset,buf(22,4))
		pinfo.cols.info="head data resp Message"		
    end

	function p_nfsp.dissector(buf,pinfo,root)
	
		if buf:len()<1 then
			return false
		end
		
		pinfo.cols.protocol = "NFSP"
		local t=root:add(p_nfsp,buf(0,-1))
		head_dissector(buf,pinfo,t)
		
		local  key_idx=bit.rshift(buf(2,1):uint(),4)
	    	local  key_ver = bit.band(buf(2,1):uint(),0x0F)
	    local  random_key=buf(0,2):uint()
	    local  key=nfsp_keyg_v1[key_idx+1]--start from 1 not 0
	    local  decode_key=bit.bxor(key, random_key)
	    local  m=buf(8,2):uint()
	    local  proto_type=bit.bxor(decode_key,m)
	    local buf_len=buf:len()
		
	    	if proto_type == 0x0601 then
			handshake_dissector(buf,pinfo,t)
		elseif  proto_type == 0x0602 then 
			keepalive_dissector(buf,pinfo,t)
		elseif  proto_type == 0x0603 then 
			choke_dissector(buf,pinfo,t)
		elseif  proto_type == 0x0604 then 
			unchoke_dissector(buf,pinfo,t)
		elseif  proto_type == 0x0605 then 
			interest_dissector(buf,pinfo,t)
		elseif  proto_type == 0x0606 then 
			uninterest_dissector(buf,pinfo,t)
		elseif  proto_type == 0x0607 then 		
			deny_dissector(buf,pinfo,t)
		elseif proto_type == 0x0608  then
	       	bitfield_dissector(buf,pinfo,t)
	    elseif proto_type == 0x0609  then
	       	have_dissector(buf,pinfo,t)
	    elseif proto_type == 0x060A  then
	       	request_dissector(buf,pinfo,t)
	    elseif proto_type == 0x060B  then
	       	piece_dissector(buf,pinfo,t)
	     elseif proto_type == 0x060C  then
	       	badpiece_dissector(buf,pinfo,t)
	   	elseif proto_type == 0x060d  then
		 	querymeta_dissector(buf,pinfo,t)
		elseif proto_type == 0x060e  then
              pushmeta_dissector(buf,pinfo,t)
         elseif proto_type == 0x060f  then   
              head_info_req_dissector(buf,pinfo,t)
		elseif proto_type == 0x0610  then   
              head_info_resp_dissector(buf,pinfo,t)
		elseif proto_type == 0x0611  then   
              head_data_req_dissector(buf,pinfo,t)
		elseif proto_type == 0x0612  then   
              head_data_resp_dissector(buf,pinfo,t)
 	    end
	end

	local tcp_encap_table = DissectorTable.get("tcp.port")
	tcp_encap_table:add(6601,p_nfsp)
	
	
end