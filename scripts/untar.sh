#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gs_tl_env.git
# Date :  2021-02-01
# Notes:  GS_TL_Env for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 解压tar.gz文件包到指定的目录，并给相应的权限
# 颜色代码
# 颜色代码
if [ -f ./color.sh ]; then
  . ./color.sh
else
  . ./color
fi

if [ -f "/root/tlbb.tar.gz" ]; then
    mv /tlgame/tlbb /tlgame/tlbb-`date +%Y%m%d%H%I%S` && \
    tar zxf ~/tlbb.tar.gz -C /gs_tl && \
    chown -R root:root /tlgame && \
    chmod -R 777 /tlgame && \
    mv  ~/tlbb.tar.gz  ~/`date +%Y%m%d%H%I%S`-tlbb.tar.gz
    echo -e "${CBLUE} 服务端文件【tlbb.tar.gz】已经解压成功！！${CEND}"
elif [ -f "/root/tlbb.zip" ]; then
    mv /tlgame/tlbb /tlgame/tlbb-`date +%Y%m%d%H%I%S` && \
    sudo yum -y install unzip && \
    unzip ~/tlbb.zip -d /tlgame && \
    chmod -R 777 /tlgame && \
    mv ~/tlbb.zip ~/`date +%Y%m%d%H%I%S`-tlbb.zip
    echo -e "${CBLUE} 服务端文件 tlbb.zip 已经上传成功！！${CEND}"
else
    echo -e "${CRED} 服务端文件不存在，或者位置上传错误，请上传至 [/root] 目录下面${CEND}"
fi