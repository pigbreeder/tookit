#! /bin/bash
# 安装 ./manage_ss_service.sh -i your_password your_port
# 安装bbr加速 ./manage_ss_service.sh -bbr
# 卸载 ss-fly/ss-fly.sh -uninstall
# 
# 日志 /var/log/shadowsocks.json
# 后端启动，输入：
# 开始：ssserver -c /etc/shadowsocks.json -d start
# 结束：ssserver -c /etc/shadowsocks.json -d stop

# 多用户设置
# {
# "server":"my_server_ip",
# "local_address": "127.0.0.1",
# "local_port":1080, 
# "port_password":
# {     "8381": "foobar1",
#       "8382": "foobar2", 
#       "8383": "foobar3",
#       "8384": "foobar4"
# },
# "timeout":300,
# "method":"aes-256-cfb",
# "fast_open": false
# }
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
usage () {
	cat $DIR/sshelp
}

wrong_para_prompt() {
    echo "参数输入错误!$1"
}

install() {
	if [[ "$#" -lt 1 ]]
        then
          wrong_para_prompt "请输入至少一个参数作为密码"
	  return 1
	fi
        port="1024"
        if [[ "$#" -ge 2 ]]
        then
          port=$2
        fi
        if [[ $port -le 0 || $port -gt 65535 ]]
        then
          wrong_para_prompt "端口号输入格式错误，请输入1到65535"
          exit 1
        fi
	echo "{
    \"server\":\"0.0.0.0\",
    \"server_port\":$port,
    \"local_address\": \"127.0.0.1\",
    \"local_port\":1080,
    \"password\":\"$1\",
    \"timeout\":300,
    \"method\":\"aes-256-cfb\"
}" > /etc/shadowsocks.json
	apt-get update
	apt-get install -y python-pip
	pip install --upgrade pip
	pip install setuptools
	pip install shadowsocks
	chmod 755 /etc/shadowsocks.json
	apt-get install python-m2crypto
        command -v ssserver >/dev/null 2>&1 || { echo >&2 "请确保你服务器（服务器，不是你自己的电脑）的系统是Ubuntu。如果系统是Ubuntu，似乎因为网络原因ss没有安装成功，请再执行一次搭建ss脚本代码。如果试了几次还是不行，执行reboot命令重启下服务器之后再试下。"; exit 1; }
	ps -fe|grep ssserver |grep -v grep > /dev/null 2>&1
        if [ $? -ne 0 ]
        then
          ssserver -c /etc/shadowsocks.json -d start
        else
          ssserver -c /etc/shadowsocks.json -d restart
        fi
	rclocal=`cat /etc/rc.local`
        if [[ $rclocal != *'ssserver -c /etc/shadowsocks.json -d start'* ]]
        then
          sed -i '$i\ssserver -c /etc/shadowsocks.json -d start'  /etc/rc.local
        fi
	echo "安装成功~尽情冲浪吧
您的配置文件内容如下（server在客户端中需要配置成你VPS的IP）："
	cat /etc/shadowsocks.json
}

install_bbr() {
	sysfile=`cat /etc/sysctl.conf`
	if [[ $sysfile != *'net.core.default_qdisc=fq'* ]]
	then
    		echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
	fi
	if [[ $sysfile != *'net.ipv4.tcp_congestion_control=bbr'* ]]
	then
    		echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
	fi
	sysctl -p > /dev/null
	i=`uname -r | cut -f 2 -d .`
	if [ $i -le 9 ]
	then
    		if
        	echo '准备下载镜像文件...' && wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.10.2/linux-image-4.10.2-041002-generic_4.10.2-041002.201703120131_amd64.deb
    		then
        		echo '镜像文件下载成功，开始安装...' && dpkg -i linux-image-4.10.2-041002-generic_4.10.2-041002.201703120131_amd64.deb && update-grub && echo '镜像安装成功，系统即将重启，重启后bbr将成功开启...' && reboot
    		else
        		echo '下载内核文件失败，请重新执行安装BBR命令'
        		exit 1
    		fi
	fi
	result=`sysctl net.ipv4.tcp_available_congestion_control`
	if [[ $result == *'bbr'* ]]
	then
    		echo 'BBR已开启成功'
	else 
    		echo 'BBR开启失败，请重试'
	fi
}

install_ssr() {
	wget --no-check-certificate https://raw.githubusercontent.com/teddysun/shadowsocks_install/master/shadowsocksR.sh
	chmod +x shadowsocksR.sh
	./shadowsocksR.sh 2>&1 | tee shadowsocksR.log
}

uninstall_ss() {
	ps -fe|grep ssserver |grep -v grep > /dev/null 2>&1
        if [ $? -eq 0 ]
        then
          ssserver -c /etc/shadowsocks.json -d stop
        fi
	pip uninstall -y shadowsocks
	rm /etc/shadowsocks.json
	rm /var/log/shadowsocks.log
	echo 'shadowsocks卸载成功'
}

if [ "$#" -eq 0 ]; then
	usage
	exit 0
fi

case $1 in
	-h|h|help )
		usage
		exit 0;
		;;
	-v|v|version )
		echo 'ss-fly Version 1.0, 2018-01-20, Copyright (c) 2018 flyzy2005'
		exit 0;
		;;
esac

if [ "$EUID" -ne 0 ]; then
	echo '必需以root身份运行，请使用sudo命令'
	exit 1;
fi

case $1 in
	-i|i|install )
        install $2 $3
		;;
        -bbr )
        install_bbr
                ;;
        -ssr )
        install_ssr
                ;;
	-uninstall )
	uninstall_ss
		;;
	* )
		usage
		;;
esac