设置脚本开机自启动方式:
打开命令行--->
$crontab -e
在执行计划文件中新增一行：@reboot /usr/shell/monitor.sh  (注意此处必须为绝对路径)
保存退出

后台运行脚本：
进入到脚本文件的当前路径下，在命令行输入指令--->
$nohup ./monitor.sh &

查看脚本运行状态：
$jobs -l
或者
$ps -ef | grep monitor

知识点补充：
$ jobs      //查看任务，返回任务编号n和进程号

$ bg  %n   //将编号为n的任务转后台运行

$ fg  %n   //将编号为n的任务转前台运行

$ ctrl+z    //挂起当前任务

$ ctrl+c    //结束当前任务

示例：
在Linux中，如果要让进程在后台运行，一般情况下，我们在命令后面加上&即可，实际上，这样是将命令放入到一个作业队列中了--->
$ ./monitor.sh &
[1] 17208

$ jobs -l
[1]+ 17208 Running                 ./monitor.sh &
对于已经在前台执行的命令，也可以重新放到后台执行，首先按ctrl+z暂停已经运行的进程，然后使用bg命令将停止的作业放到后台运行--->
$ ./monitor.sh
[1]+  Stopped                 ./monitor.sh

$ bg %1
[1]+ ./monitor.sh &

$ jobs -l
[1]+ 22794 Running                 ./monitor.sh &

但是如上方到后台执行的进程，其父进程还是当前终端shell的进程，而一旦父进程退出，则会发送hangup信号给所有子进程，子进程收到hangup以后也会退出。
如果我们要在退出shell的时候继续运行进程，则需要使用nohup忽略hangup信号，或者setsid将将父进程设为init进程(进程号为1)--->
$ echo $$
21734

$ nohup ./monitor.sh &
[1] 29016

$ ps -ef | grep monitor
515      29710 21734  0 11:47 pts/12   00:00:00 /bin/sh ./monitor.sh
515      29713 21734  0 11:47 pts/12   00:00:00 grep monitor
$ setsid ./monitor.sh &
[1] 409

$ ps -ef | grep monitor
515        410     1  0 11:49 ?        00:00:00 /bin/sh ./monitor.sh
515        413 21734  0 11:49 pts/12   00:00:00 grep monitor
