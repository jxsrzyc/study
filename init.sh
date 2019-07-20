#!/bin/bash
echo -e "\e[35m
    ************************************
    *          1.配置主机名            *
    *          2.配置IP地址            *
    *          3.关闭防火墙            *
    *          4.关闭selinux           *
    *          5.配置yum本地源         *
    ************************************
    *  默认八次循环退出或者输入q退出   *
    ************************************
\e[0m"
i=1
while [ $i -le 8 ]
do
read -p "请选择1-5选项,执行相应操作：" num
case $num in
1)
    read -p "请输入主机名：" name
    hostname $name
    echo "$name" > /etc/hostname
    ;;
2)
    echo -e "\e[31mIP,网卡名不能为空,网关和DNS可以为空\e[0m"
    read -p "请输入IP地址：" ip
    read -p "请输入网关地址：" gw
    read -p "请输入DNS地址：" dns
    read -p "请输入网卡名称：" wkm
#   sed -i "/IPADDR/c IPADDR=$ip" /etc/sysconfig/network-scripts/ifcfg-$wkm
    [ -z $ip ] || [ -z $wkm ] && echo -e "\e[31m输入格式错误,请正确输入
\e[0m" && continue
    cat > /etc/sysconfig/network-scripts/ifcfg-$wkm << eof
TYPE=Ethernet
BOOTPROTO=none
DEVICE=$wkm
ONBOOT=yes
IPADDR=$ip
GATEWAY=$gw
DNS1=$dns
eof
    ifdown $wkm;ifup $wkm
    ;;
3)
    systemctl stop firewalld
    systemctl disable firewalld
    ;;
4)
    setenforce 0
    sed -i '/^SELINUX=/c SELINUX=disabled' /etc/selinux/config
    ;;
5)
    read -p "请输入创建的yum仓库名,以.repo结尾：" ckm
    cd /etc/yum.repos.d/
    [ -d repo ] || mkdir repo
    mv *.repo repo/ &>/dev/null
    echo "[localdisk]
name=localdisk
baseurl=file:///mnt
enabled=1
gpgcheck=0" > $ckm
    mount /dev/sr0 /mnt &>/dev/null
    yum repolist &>/dev/null
    ;;
q)
    exit
    ;;
*)
    echo "please input one-five options"
    ;;
esac
done

