#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gs_tl_env.git
# Date :  2021-02-01
# Notes:  GS_TL_Env for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 服务器环境重构，删除容器，重新启动
# 引入全局参数
if [ -f ./.env ]; then
  . /root/.gs/.env
else
  . /usr/local/bin/.env
fi
# 颜色代码
if [ -f ./color.sh ]; then
  . ${GS_PROJECT}/scripts/color.sh
else
  . /usr/local/bin/color
fi

while :; do echo
    for ((time = 10; time > 0; time--)); do
      sleep 1
      echo -ne "\r在准备正行重构操作！！，剩余 ${CBLUE}$time${CEND} 秒，可以在计时结束前，按 CTRL+C 退出！\r"
    done
    docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q) && rm -rf /tlgame/tlbb/* && cd ~/.tlgame && docker-compose up -d
    if [ $? == 0 ]; then
      echo -e "${CBLUE} 环境已经重构成功，请上传服务端到指定位置，然后再开服操作！！${CEND}"
    else
      echo -e "${CRED} 环境已经重构失败！可能需要重装系统或者环境了！${CEND}"
    fi
done
