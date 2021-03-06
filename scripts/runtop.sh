#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gs_tl_env.git
# Date :  2021-02-01
# Notes:  GS_TL_Env for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 查看服务器进程情况
if [ -n $1 ]; then
    cd ~/.tlgame && docker-compose exec server top
else
    cd ~/.tlgame && docker-compose exec $1 top
fi
