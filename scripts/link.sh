#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gs_tl_env.git
# Date :  2021-02-01
# Notes:  GS_TL_Env for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 连接服务器环境
if [ -f ./color.sh ]; then
  . /root/.tlgame/scripts/color.sh
else
  . /usr/local/bin/color
fi
if [ $1 == "tlmysql" ] || [ $1 == "web" ]; then
    cd /root/.tlgame && docker-compose exec $1 bash
elif [ -z $1 ]; then
    cd /root/.tlgame && docker-compose exec server bash
else
  echo  -e "${CBLUE}错误：输入有误！！请使用 link tlmysql|nginx|server${CEND}";
fi