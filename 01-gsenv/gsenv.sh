#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gs_tl_env.git
# Date :  2021-02-01
# Notes:  GS_TL_Env for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+

# 第一步，尽量短小简洁的进行下载脚本 。
# 第二步，关注公众号进行认证请求--暂时不需要实现。
# 第三步，认证请求成功之后，下载安装环境必须的脚本
# 第四步，安装基本系统组件。
# 第五步，下载环境源码
# 第六步，执行环境脚本安装
# 第七步，写入相应配置，端口，密码等
# 第八步，安装docker,docker-composer
# 第九步，拉取镜像或者本地制作镜像
# 第十步，环境安装完成 ，展示安装结果以及相应配置
clear
# 定义变量
#接口请求结果
RESULT=''
#环境下载保存的文件名称
FILENAME='gstlenv.tar.gz'
#解压后重全名文件夹名称
ENVDIR='.tlgame'
#环境版本号
VERSION='v2.0.0'
#更新时间
UPDATE='2021-06-30'
# 授权
login(){
    # 实现shell请求登录接口
    URL='http://grav.test'
    printf "Username: "
    read username
    printf "Password: "
    stty -echo
    read pass
    printf "\n"
    stty echo
    RESULT=${pass} | sed -e "s/^/-u ${username}:/" | curl --url "${url}" -K-
    unset username
    unset pass
    echo $RESULT
}

show() {
printf "\e[1;35m
#######################################################################
#       GS_TLBB_ENV 支持：CentOS/RedHat 7+  Ubuntu 18+ Debian 10+     #
#       更多天龙网游单机版本请访问：       https://gsgamesahre.com    #
#       技术交流群：                       826717146                  #
#       version:                           ${VERSION}             #
#       update:                            ${UPDATE}                 #
#######################################################################
\033[0m"
}

version() {
  echo "version: ${VERSION}"
  echo "updated date: 2021-05-18"
}


download () {
wget -O ${FILENAME} https://gitee.com/yulinzhihou/gs_tl_env/repository/archive/${VERSION}.tar.gz 
tar zxf ${FILENAME} && mv gs_tl_env ${ENVDIR}
}

show
download
if [ -d ${ENVDIR} ]; then
    chmod -R 777 ${ENVDIR}
    \cp -rf ${ENVDIR}/env.sample ${ENVDIR}/.env
    cd ${ENVDIR} && bash install.sh
fi