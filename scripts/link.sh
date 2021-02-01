#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gs_tl_env.git
# Date :  2021-02-01
# Notes:  GS_TL_Env for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 连接服务器环境
if [ -n $1 ]; then
    cd ~/gs_tl_env && docker-compose exec server bash
elif [ $1 -eq 'php' ] || [ $1 -eq 'nginx' ]; then
    cd ~/gs_tl_env && docker-compose exec $1 sh
else
    cd ~/gs_tl_env && docker-compose exec $1 bash
fi