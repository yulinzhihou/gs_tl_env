#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gs_tl_env.git
# Date :  2021-02-01
# Notes:  GS_TL_Env for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
clear
#环境下载保存的文件名称
FILENAME='gstlenv'
#环境下载保存的文件名称
DOCKERNAME='gsdocker'
#解压后重全名文件夹名称
ENVDIR='~/.tlgame'
#解压后docker目录
GSDIR='~/.gs'
#环境版本号
VERSION='v2.0.0'
#更新时间
UPDATE='2021-06-30'


show() {
printf "\e[1;35m
#######################################################################
#       GS_TLBB_ENV 支持：CentOS/RedHat 7+  Ubuntu 18+ Debian 10+     #
#       更多天龙网游单机版本请访问：       https://gsgamesahre.com    #
#       技术交流群：                       826717146                  #
#       version:                           ${VERSION}               #
#       update:                            ${UPDATE}                 #
#######################################################################
\033[0m"
}

version() {
  echo "version: ${VERSION}"
  echo "updated date: 2021-05-18"
}


download () {
  # wget -O ${FILENAME} https://gitee.com/yulinzhihou/gs_tl_env/repository/archive/${VERSION}.tar.gz 
  # gs env 服务器环境 ，组件
  wget -q https://gsgameshare.com/gstl.tar.gz -O ${FILENAME}.tar.gz
  # 解压目录
  tar zxf ${FILENAME}.tar.gz && mv gs_tl_env ${ENVDIR}
}

show
download
if [ -d ${ENVDIR} ]; then
    chmod -R 777 ${ENVDIR}
    \cp -rf ${ENVDIR}/env.sample ${ENVDIR}/.env
    cd ${ENVDIR} && bash install.sh
fi