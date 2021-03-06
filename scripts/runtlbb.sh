#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gs_tl_env.git
# Date :  2021-02-01
# Notes:  GS_TL_Env for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 一键开服，适合于那种可以一键开启的服务端，如果3-5分钟后，服务端没开启，则需要使用分步开服方式
chmod -R 777 /tlgame && \
chown -R root:root /tlgame && \
cd ~/.tlgame && \
docker-compose exec -d server /home/billing/billing up -d  && \
docker-compose exec -d server /bin/bash run.sh
echo -e "\e[44m 已经成功启动服务端，请耐心等待几分钟后，建议使用：【runtop】查看开服的情况！\e[0m"