#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gs_tl_env.git
# Date :  2021-02-01
# Notes:  GS_TL_Env for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 删除所有数据
docker stop $(docker ps -a -q) && \
docker rm $(docker ps -a -q) && \
docker rmi $(docker images -q) && \
mv /gs_tl  /gs_tl-`date +%Y%m%d%H%I%S` && \
rm -rf ~/gs_tl_env
echo -e "\e[44m 数据清除成功，请重新安排文档教程命令第一步开始安装环境！！！ \e[0m"