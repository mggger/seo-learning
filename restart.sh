#!/bin/bash

# 查找Hugo的进程ID
pid=$(ps -ef | grep 'hugo server' | grep -v 'grep' | awk '{print $2}')

# 如果找到了Hugo的进程ID，那么就杀掉这个进程
if [ ! -z "$pid" ]; then
    echo "Killing Hugo server with PID: $pid"
    kill -9 $pid
fi

# 启动新的Hugo进程
echo "Starting new Hugo server"
nohup hugo server --bind=0.0.0.0 --baseURL=http://mggg.cloud &> /dev/null &

