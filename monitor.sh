#!/bin/bash
echo "开始监控目标程序^_^"

while true
do
systemctl status testd.service | grep running   #目标程序名
if [ "$?" -eq 0 ] #判断指令查询结果是否为0
then

    echo "program is running!"

else

    echo "program is dead!"
    systemctl restart testd.service  #重启目标程序
    
fi

sleep 60  #脚本执行周期为60秒

done

#注释"$?"为 systemctl status testd.service | grep running的执行结果，若
#指令执行结果存在(成功)则"$?"为0，否则为1
