#!/bin/bash
# chkconfig: - 99 99
filename=/usr/local/nginx/conf/nginx.conf
nginx_pid=/usr/local/nginx/logs/nginx.pid
nginx=/usr/sbin/nginx
fileport=`egrep "^ *listen" $filename |awk -F " +|;" '{print $3}'`
case "$1" in
start)
    if [ -e $nginx_pid ]
    then
        echo "nginx already start"
    else
        for i in $fileport
        do
            netstat -tlnp|egrep "\<$i\>" && echo -e "\e[35mthe $i port is used\e[0m" && exit
        done
        $nginx
    fi
    ;;
stop)
    [ ! -e $nginx_pid ] && echo "nginx already stop" || $nginx -s stop
    ;;
restart)
    [ ! -e $nginx_pid ] && $nginx
    [ -e $nginx_pid ] && $nginx -s stop && $nginx
    ;;
reload)
    [ ! -e $nginx_pid ] && $nginx || $nginx -s reload
    ;;
*)
    echo "Usage:$0 start|stop|restart|reload"
    ;;
esac

