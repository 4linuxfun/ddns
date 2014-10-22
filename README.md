ddns
====

shadowsocks的日本代理晚上高峰期性能不行，使用DNSPOD的API，晚上定时修改IP到新加坡节点shadowsocks

###脚本说明
此脚本根据DNSPOD官方API写的Bash脚本工具，用来修改对应域名的IP地址，且使用XML为返回信息，会产生几个临时文件，但都会在脚本完成后自动删除。

[DNSPOD官方API](https://www.dnspod.cn/docs/index.html)
###操作说明：
1. 在DNSPOD中，对需要自动修改IP的DNS做mark标记
2. 在脚本中填写对应参数
```
  login_email="DNSPD登录邮箱地址"
  login_password="DNSPOD登录密码"
  record_name="需要修改的记录" #如果需要修改**www**的IP地址，则此处填写**www**
  new_ip="${1}" #参数传过来的新IP
```
3. 赋予执行权限

  >chmod +x ddns.sh
4. 执行

  >./ddns.sh IP地址
