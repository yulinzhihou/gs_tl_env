#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gs_tl_env.git
# Date :  2021-02-01
# Notes:  GS_TL_Env for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 一键命令关闭所有
# 颜色代码
if [ -f ./color.sh ]; then
  . /root/.tlgame/scripts/color.sh
else
  . /usr/local/bin/color
fi
cd ~/.tlgame && \
docker-compose exec -d server /bin/bash stop.sh && \
docker-compose exec -d server /home/billing/billing stop
if [ $? == 0 ]; then
  echo -e "${CBLUE} 服务端已经关闭成功，如果需要重新开启，请运行【runtlbb】命令${CEND}"
else
  echo -e "${CRED} 服务端已经关闭失败！请稍后再试！${CEND}"
fi
