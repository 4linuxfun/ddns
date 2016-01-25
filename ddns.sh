#!/bin/bash 
#此脚本用来自动化更换DNSPOD解析IP
#注意，此脚本需要先在DNSPOD上设置域名mark
#在login_email和login_password中填入用户名和密码
#record_name为需要修改的域名信息,如修改www的IP地址
#new_ip为需要修改的为新的IP

login_email=""
login_password=""
##record_name为需要自动修改IP的记录
record_name=""
new_ip="${1}"

format="xml"
lang="en"
userAgent="ddns/0.1(yinyinxiaozi@gmail.com)"
common_post="login_email=${login_email}&login_password=${login_password}&format=${format}"
common_url="https://dnsapi.cn"

#获取mark标记的域名信息(domain_id)
D_id(){
curl -s -A ${userAgent} -X POST ${common_url}/Domain.List -d "${common_post}&type=ismark">/root/domain_info.txt
if cat /root/domain_info.txt|grep -i "login fail";then
	echo "Login fail.Please check login info"
	exit 1
else
	local domain_id=$(cat /root/domain_info.txt|grep id|grep -v group|awk -F'[<>]' '{print $3}')
	rm -rf /root/domain_info.txt
	echo "${domain_id}"
fi 
}

#获取record.list信息
R_info(){
	curl -A ${userAgent} -X POST ${common_url}/Record.List -d "${common_post}&domain_id=${domain_id}">/root/record_info.txt
	cat /root/record_info.txt|grep -B2 -A12 ${record_name}>/root/tmp.txt
	rm -rf /root/record_info.txt
}

#修改record.modify信息
R_modify(){
	curl -A ${userAgent} -X POST ${common_url}/Record.Modify -d "${common_post}&domain_id=${domain_id}&record_id=${record_id}&sub_domain=${record_name}&value=${new_ip}&record_type=${record_type}&record_line=默认">/root/modify.txt
	if cat /root/modify.txt|grep -i "fail";then
		echo "error...please check /root/modify.txt for more information"
		exit 1
	else
		rm -rf /root/modify.txt
	fi
}

domain_ids=$(D_id)
for domain_id in $domain_ids
do
	echo $domain_id
	R_info $domain_id
	record_id=$(cat tmp.txt|grep id|awk -F'[<>]' '{print $3}')
	record_type="A"
	R_modify $domain_id

	rm -rf tmp.txt
done
