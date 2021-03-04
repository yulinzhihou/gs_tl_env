#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gs_tl_env.git
# Date :  2021-02-01
# Notes:  GS_TL_Env for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 服务器环境重构，删除容器，重新启动
docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q) && rm -rf /tlgame/tlbb/* && cd ~/gs_tl_env && docker-compose up -d
echo -e "\e[44m 环境已经重构成功，请上传服务端到指定位置，然后再开服操作！！ \e[0m"