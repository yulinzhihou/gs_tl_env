#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gs_tl_env.git
# Date :  2021-02-01
# Notes:  GS_TL_Env for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 换版本
docker stop $(docker ps -a -q) && \
docker rm $(docker ps -a -q) && \
rm -rf /tlgame/tlbb/* && \
untar && \
cd ~/.tlgame && \
setini && \
docker-compose up -d && \
runtlbb
echo -e "\e[44m 换端成功，请耐心等待几分钟后，建议使用：【runtop】查看开服的情况！\e[0m"