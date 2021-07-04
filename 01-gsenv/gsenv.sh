#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gs_tl_env.git
# Date :  2021-02-01
# Notes:  GS_TL_Env for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
clear
# 检测是不是root用户。不是则退出
[ $(id -u) != "0" ] && { echo "${CFAILURE}错误: 你必须使用ROOT用户${CEND}"; exit 1; }
# comment: 安装天龙环境docker
DOCKERNAME='gsdocker'
# 容器配置根目录
GSDIR='.gs'
# 容器存放的父级目录
ROOT_PATH='/root'
# 容器配置文件名称
CONFIG_FILE='.env'
# 容器配置文件绝对路径
WHOLE_PATH='/root/.gs/.env'
# 容器下载临时路径
TMP_PATH='/opt'
# 容器打包文件后缀
SUFFIX='.tar.gz'
# 容器完整包名称
WHOLE_NAME=${FILENAME}${SUFFIX}
#环境下载保存的文件名称
FILENAME='gstlenv'
#环境下载保存的文件名称
DOCKERNAME='gsdocker'
#解压后重全名文件夹名称
ENVDIR='.tlgame'
#解压后docker目录
GSDIR='.gs'
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
#       version:                           ${VERSION}                   #
#       update:                            ${UPDATE}                  #
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
  wget -q https://gsgameshare.com/${WHOLE_NAME} -O ${TMP_PATH}/${WHOLE_NAME}
  cd ${TMP_PATH} && \
  # 解压目录
  tar zxf ${WHOLE_NAME} && mv ${FILENAME} ${ROOT_PATH}/${ENVDIR} && rm -rf ${TMP_PATH}/${WHOLE_NAME}
}

show
download
if [ -d ${ROOT_PATH}/${ENVDIR} ]; then
    chmod -R 777 ${ROOT_PATH}/${ENVDIR}
    \cp -rf ${ROOT_PATH}/${ENVDIR}/env.sample ${ROOT_PATH}/${ENVDIR}/.env
    cd ${ROOT_PATH}/${ENVDIR} && bash install.sh
fi