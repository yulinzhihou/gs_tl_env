#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gs_tl_env.git
# Date :  2021-02-01
# Notes:  GS_TL_Env for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+


# 第一步：更新系统组件，安装docker,docker-composer
# 第二步：下载GS相关命令到系统
# 第三步：在线下载打包好的镜像或者导入离线版本的镜像

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
printf "
#######################################################################
#       GS_TL_Env 支持： CentOS/RedHat 7+  Ubuntu 16+ Debian 8+       #
#       更多天龙网游单机版本请访问：          https://gsgamesahre.com    #
#       技术交流群：                        826717146                  #
#######################################################################
"
# 颜色代码
. ./include/color.sh
# 检测系统版本
. ./include/check_os.sh
# 加载shell
. ./include/get_char.sh
# 检测是不是root用户。不是则退出
[ $(id -u) != "0" ] && { echo "${CFAILURE}错误: 你必须使用${CEND}"; exit 1; }

ARG_NUM=$#
[ $? != 0 ] && echo "${CWARNING}ERROR: unknown argument! ${CEND}" && Show_Help && exit 1

# 修改各种端口，密码

# 系统组件安装
sys_plugins_install()
{
  # 安装 wget gcc curl git python
  [ "${PM}" == 'apt-get' ] && apt-get -y update
  [ "${PM}" == 'yum' ] && yum clean all
  ${PM} -y install wget gcc curl python git
  [ "${CentOS_ver}" == '8' ] && { yum -y install python36; sudo alternatives --set python /usr/bin/python3; }
}

# 安装docker docker-compose
do_install_docker()
{
    curl -sSL https://get.daocloud.io/docker | sh
    sudo mkdir -p /etc/docker
    sudo tee /etc/docker/daemon.json <<EOF
{
  "registry-mirrors": ["https://f0tv1cst.mirror.aliyuncs.com"]
}
EOF
  [ "${OS}" == "Debian" ] || [ "${OS}" == "Ubuntu" ] && sudo apt-get service docker start
  [ "${OS}" == "CentOS" ] && sudo systemctl daemon-reload && sudo systemctl restart docker
  # 安装 docker-compose
  [ "${OS}" == "Debian" ] || [ "${OS}" == "Ubuntu" ] && sudo apt-get service docker start
  [ "${OS}" == "CentOS" ] && sudo systemctl daemon-reload && sudo systemctl restart docker

  curl -L https://get.daocloud.io/docker/compose/releases/download/1.28.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose
  docker-compose --version
}

# 安装GS组件
