#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gs_tl_env.git
# Date :  2021-02-01
# Notes:  GS_TL_Env for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+

# 第一步：更新系统组件，安装docker,docker-composer
# 第二步：下载GS相关命令到系统
# 第三步：在线下载打包好的镜像或者导入离线版本的镜像
startTime=`date +%s`
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
printf "
#######################################################################
#       GS_TL_Env 支持： CentOS/RedHat 7+  Ubuntu 16+ Debian 8+       #
#       更多天龙网游单机版本请访问：       https://gsgamesahre.com    #
#       技术交流群：                       826717146                  #
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

# 配置常用命令到系统中
set_command() {
    ls -l /root/gs_tl_env/scripts/ | awk '{print $9}' > ./command.txt
    for VAR in `cat ./command.txt`; do
        if [ -n ${VAR} ]; then
            \cp -rf ~/gs_tl_env/scripts/${VAR} /usr/local/bin/${VAR%%.*} && chmod +x /usr/local/bin/${VAR%%.*}
        fi
    done
}

# 启动环境
docker_run () {
    if [ ! -e /root/gs_tl_offline.tar.gz ]; then
      # 在线镜像拉取
      cd /root/gs_tl_env && . /etc/profile && docker-compose up -d
    else
      # 离线版本。暂时没做
      tar zxf gs_tl_offline.tar.gz
    fi
}

# 初始化配置
ini_config()
{
    if [ -z "`grep ^SHARE_DIR /etc/profile`" ]; then
        echo 'SHARE_DIR="/gs_tl"' >> /etc/profile
    fi

    if [ -z "`grep ^RESTART /etc/profile`" ]; then
        echo 'RESTART="always"' >> /etc/profile
    fi


#  get_char
  ARG_NUM=$#
  # 修改billing参数
  if [ -e "/etc/profile" ]; then
    . /etc/profile
    BILLING_DEFAULT_PORT=21818
    [ -z "`grep ^BILLING_PORT /etc/profile`" ] && BILLING_PORT=${BILLING_DEFAULT_PORT} || BILLING_PORT=${BILLING_PORT}
    read -e -p "当前【Billing验证端口】为：${CBLUE}[${BILLING_PORT}]${CEND}，是否需要修改【Billing验证端口】 [y/n](默认: n): " IS_MODIFY
    IS_MODIFY=${IS_MODIFY:-'n'}
    if [[ ! ${IS_MODIFY} =~ ^[y,n]$ ]]; then
        echo "${CWARNING}输入错误! 请输入 'y' 或者 'n',当【Billing验证端口】为：[${BILLING_PORT}]${CEND}"
    elif [ "${IS_MODIFY}" == 'n' ]; then
        echo "${CWARNING}当前【Billing验证端口】为：[${BILLING_PORT}]${CEND}"
    else
      #
      while :; do echo
        [ ${ARG_NUM} == 0 ] && read -e -p "请输入【Billing验证端口】：(默认: ${BILLING_DEFAULT_PORT}): " BILLING_NEW_PORT
        BILLING_NEW_PORT=${BILLING_NEW_PORT:-${BILLING_DEFAULT_PORT}}
        if [ ${BILLING_NEW_PORT} == ${BILLING_DEFAULT_PORT} >/dev/null 2>&1 -o ${BILLING_NEW_PORT} -gt 1024 >/dev/null 2>&1 -a ${BILLING_NEW_PORT} -lt 65535 >/dev/null 2>&1 ]; then
          break
        else
          echo "${CWARNING}输入错误! 端口范围: 1025~65534${CEND}"
          exit 1
        fi
      done

      if [ ! -z "`grep ^BILLING_PORT /etc/profile`" -a "${BILLING_NEW_PORT}" != "${BILLING_DEFAULT_PORT}" ]; then
        echo 'BILLING_PORT="${BILLING_NEW_PORT}"' >> /etc/profile
      elif [ -n "`grep ^BILLING_PORT /etc/profile`" ]; then
        sed -i "s@^BILLING_PORT.*@BILLING_PORT=${BILLING_NEW_PORT}@" /etc/profile
      fi
    fi
  fi

  # 修改mysql_Port参数
  if [ -e "/etc/profile" ]; then
    . /etc/profile
    TL_MYSQL_DEFAULT_PORT=33061
    [ -z "`grep ^TL_MYSQL_PORT /etc/profile`" ] && TL_MYSQL_PORT=${TL_MYSQL_DEFAULT_PORT} || TL_MYSQL_PORT=${TL_MYSQL_PORT}
    read -e -p "当前【mysql端口】为：${CBLUE}[${TL_MYSQL_PORT}]${CEND}，是否需要修改【mysql端口】 [y/n](默认: n): " IS_MODIFY
    IS_MODIFY=${IS_MODIFY:-'n'}
    if [[ ! ${IS_MODIFY} =~ ^[y,n]$ ]]; then
        echo "${CWARNING}输入错误! 请输入 'y' 或者 'n',当前【mysql端口】为：[${TL_MYSQL_PORT}]${CEND}"
    elif [ "${IS_MODIFY}" == 'n' ]; then
        echo "${CWARNING}当前【mysql端口】为：[${TL_MYSQL_PORT}]${CEND}"
    else
      while :; do echo
        [ ${ARG_NUM} == 0 ] && read -e -p "请输入【mysql端口】：(默认: ${TL_MYSQL_DEFAULT_PORT}): " TL_MYSQL_NEW_PORT
        TL_MYSQL_NEW_PORT=${TL_MYSQL_NEW_PORT:-${TL_MYSQL_DEFAULT_PORT}}
        if [ ${TL_MYSQL_NEW_PORT} -eq ${TL_MYSQL_DEFAULT_PORT} >/dev/null 2>&1 -o ${TL_MYSQL_NEW_PORT} -gt 1024 >/dev/null 2>&1 -a ${TL_MYSQL_NEW_PORT} -lt 65535 >/dev/null 2>&1 ]; then
          break
        else
          echo "${CWARNING}输入错误! 端口范围: 1025~65534${CEND}"
          exit 1
        fi
      done

      if [ ! -z "`grep ^TL_MYSQL_PORT /etc/profile`" -a "${TL_MYSQL_NEW_PORT}" != "${TL_MYSQL_DEFAULT_PORT}" ]; then
        echo 'TL_MYSQL_PORT="${TL_MYSQL_NEW_PORT}"' >> /etc/profile
      elif [ -n "`grep ^TL_MYSQL_PORT /etc/profile`" ]; then
        sed -i "s@^TL_MYSQL_PORT.*@TL_MYSQL_PORT=${TL_MYSQL_NEW_PORT}@" /etc/profile
      fi
    fi
  fi

  # 修改login_Port参数
  if [ -e "/etc/profile" ]; then
    . /etc/profile
    LOGIN_DEFAULT_PORT=13580
    [ -z "`grep ^LOGIN_PORT /etc/profile`" ] && LOGIN_PORT=${LOGIN_DEFAULT_PORT} || LOGIN_PORT=${LOGIN_PORT}
    read -e -p "当前【登录端口】为：${CBLUE}[${LOGIN_PORT}]${CEND}，是否需要修改【登录端口】 [y/n](默认: n): " IS_MODIFY
    IS_MODIFY=${IS_MODIFY:-'n'}
    if [[ ! ${IS_MODIFY} =~ ^[y,n]$ ]]; then
        echo "${CWARNING}输入错误! 请输入 'y' 或者 'n',当前【登录端口】为：[${LOGIN_PORT}]${CEND}"
    elif [ "${IS_MODIFY}" == 'n' ]; then
        echo "${CWARNING}当前【登录端口】为：[${LOGIN_PORT}]${CEND}"
    else
      while :; do echo
        [ ${ARG_NUM} == 0 ] && read -e -p "请输入【登录端口】：(默认: ${LOGIN_DEFAULT_PORT}): " LOGIN_NEW_PORT
        LOGIN_NEW_PORT=${LOGIN_NEW_PORT:-${LOGIN_PORT}}
        if [ ${LOGIN_NEW_PORT} -eq ${LOGIN_DEFAULT_PORT} >/dev/null 2>&1 -o ${LOGIN_NEW_PORT} -gt 1024 >/dev/null 2>&1 -a ${LOGIN_NEW_PORT} -lt 65535 >/dev/null 2>&1 ]; then
          break
        else
          echo "${CWARNING}输入错误! 端口范围: 1025~65534${CEND}"
          exit 1
        fi
      done

      if [ ! -z "`grep ^LOGIN_PORT /etc/profile`" -a "${LOGIN_NEW_PORT}" != "${LOGIN_DEFAULT_PORT}" ]; then
         echo 'LOGIN_PORT="${LOGIN_PORT}"' >> /etc/profile
      elif [ -n "`grep ^LOGIN_PORT /etc/profile`" ]; then
        sed -i "s@^LOGIN_PORT.*@LOGIN_PORT=${LOGIN_NEW_PORT}@" /etc/profile
      fi
    fi
  fi


  # 修改Game_Port参数
  if [ -e "/etc/profile" ]; then
    . /etc/profile
    SERVER_DEFAULT_PORT=15680
    [ -z "`grep ^SERVER_PORT /etc/profile`" ] && SERVER_PORT=${SERVER_DEFAULT_PORT} || SERVER_PORT=${SERVER_PORT}
    read -e -p "当前【游戏端口】为：${CBLUE}[${SERVER_PORT}]${CEND}，是否需要修改【游戏端口】 [y/n](默认: n): " IS_MODIFY
    IS_MODIFY=${IS_MODIFY:-'n'}
    if [[ ! ${IS_MODIFY} =~ ^[y,n]$ ]]; then
        echo "${CWARNING}输入错误! 请输入 'y' 或者 'n',当前【游戏端口】为：[${SERVER_PORT}]${CEND}"
    elif [ "${IS_MODIFY}" == 'n' ]; then
        echo "${CWARNING}当前【游戏端口】为：[${SERVER_PORT}]${CEND}"
    else
      while :; do echo
        [ ${ARG_NUM} == 0 ] && read -e -p "请输入【游戏端口】：(默认: ${SERVER_DEFAULT_PORT}): " SERVER_NEW_PORT
        SERVER_NEW_PORT=${SERVER_NEW_PORT:-${SERVER_DEFAULT_PORT}}
        if [ ${SERVER_NEW_PORT} -eq ${SERVER_DEFAULT_PORT} >/dev/null 2>&1 -o ${SERVER_NEW_PORT} -gt 1024 >/dev/null 2>&1 -a ${SERVER_NEW_PORT} -lt 65535 >/dev/null 2>&1 ]; then
          break
        else
          echo "${CWARNING}输入错误! 端口范围: 1025~65534${CEND}"
          exit 1
        fi
      done

      if [ ! -z "`grep ^SERVER_PORT /etc/profile`" -a "${SERVER_NEW_PORT}" != "${SERVER_DEFAULT_PORT}" ]; then
        echo 'SERVER_PORT="${SERVER_PORT}"' >> /etc/profile
      elif [ -n "`grep ^SERVER_PORT /etc/profile`" ]; then
        sed -i "s@^SERVER_PORT.*@SERVER_PORT=${SERVER_NEW_PORT}@" /etc/profile
      fi
    fi
  fi

  # 修改WEB_Port参数
  if [ -e "/etc/profile" ]; then
    . /etc/profile
    WEB_DEFAULT_PORT=15680
    [ -z "`grep ^WEB_PORT /etc/profile`" ] && WEB_PORT=${WEB_DEFAULT_PORT} || WEB_PORT=${WEB_PORT}
    read -e -p "当前【网站端口】为：${CBLUE}[${WEB_PORT}]${CEND}，是否需要修改【网站端口】 [y/n](默认: n): " IS_MODIFY
    IS_MODIFY=${IS_MODIFY:-'n'}
    if [[ ! ${IS_MODIFY} =~ ^[y,n]$ ]]; then
        echo "${CWARNING}输入错误! 请输入 'y' 或者 'n',当前【网站端口】为：[${WEB_PORT}]${CEND}"
    elif [ "${IS_MODIFY}" == 'n' ]; then
        echo "${CWARNING}当前【网站端口】为：[${WEB_PORT}]${CEND}"
    else
      while :; do echo
        [ ${ARG_NUM} == 0 ] && read -e -p "请输入【网站端口】：(默认: ${WEB_DEFAULT_PORT}): " WEB_NEW_PORT
        WEB_NEW_PORT=${WEB_NEW_PORT:-${WEB_PORT}}
        if [ ${WEB_NEW_PORT} -eq ${WEB_DEFAULT_PORT} >/dev/null 2>&1 -o ${WEB_NEW_PORT} -gt 1024 >/dev/null 2>&1 -a ${WEB_NEW_PORT} -lt 65535 >/dev/null 2>&1 ]; then
          break
        else
          echo "${CWARNING}输入错误! 端口范围: 1025~65534${CEND}"
          exit 1
        fi
      done

      if [ ! -z "`grep ^WEB_PORT /etc/profile`" -a "${WEB_NEW_PORT}" != "${WEB_DEFAULT_PORT}" ]; then
        echo 'WEB_PORT="${WEB_PORT}"' >> /etc/profile
      elif [ -n "`grep ^WEB_PORT /etc/profile`" ]; then
        sed -i "s@^WEB_PORT.*@WEB_PORT=${WEB_NEW_PORT}@" /etc/profile
      fi
    fi
  fi

  # 修改数据库密码
  if [ -e "/etc/profile" ]; then
    . /etc/profile
    TL_MYSQL_DEFAULT_PASSWORD=123456
    [ -z "`grep ^TL_MYSQL_PASSWORD /etc/profile`" ] && TL_MYSQL_PASSWORD=${TL_MYSQL_DEFAULT_PASSWORD} || TL_MYSQL_PASSWORD=${TL_MYSQL_PASSWORD}
    read -e -p "当前【数据库密码】为：${CBLUE}[${TL_MYSQL_PASSWORD}]${CEND}，是否需要修改【数据库密码】 [y/n](默认: n): " IS_MODIFY
    IS_MODIFY=${IS_MODIFY:-'n'}
    if [[ ! ${IS_MODIFY} =~ ^[y,n]$ ]]; then
        echo "${CWARNING}输入错误! 请输入 'y' 或者 'n',当前【数据库密码】为：[${TL_MYSQL_PASSWORD}]${CEND}"
    elif [ "${IS_MODIFY}" == 'n' ]; then
        echo "${CWARNING}当前【数据库密码】为：[${TL_MYSQL_PASSWORD}]${CEND}"
    else
      while :; do
        read -e -p "请输入【数据库密码】(默认: ${TL_MYSQL_DEFAULT_PASSWORD}): " TL_MYSQL_NEW_PASSWORD
        TL_MYSQL_NEW_PASSWORD=${TL_MYSQL_NEW_PASSWORD:-${TL_MYSQL_PASSWORD}}
        if (( ${#TL_MYSQL_NEW_PASSWORD} >= 5 )); then
          break
        else
          echo "${CWARNING}密码最少要6个字符! ${CEND}"
        fi
      done

      if [ ! -z "`grep ^TL_MYSQL_PASSWORD /etc/profile`" -a "${TL_MYSQL_NEW_PASSWORD}" != "${TL_MYSQL_DEFAULT_PASSWORD}" ]; then
        echo 'TL_MYSQL_PASSWORD="${TL_MYSQL_NEW_PASSWORD}"' >> /etc/profile
      elif [ -n "`grep ^TL_MYSQL_PASSWORD /etc/profile`" ]; then
        sed -i "s@^TL_MYSQL_PASSWORD.*@TL_MYSQL_PASSWORD=${TL_MYSQL_NEW_PASSWORD}@" /etc/profile
      fi
    fi
  fi
  source /etc/profile
}

##################################################################
# 开始调用
sys_plugins_install
do_install_docker
ini_config
docker_run
set_command
setini
##################################################################
# 安装完成提示
. /etc/profile
#export $(grep -v '^#' ~/.tlgame/gs/.env | xargs -d '\n')
printf "
#######################################################################
#       GS_TL_Env 支持： CentOS/RedHat 7+  Ubuntu 18+ Debian 10+
#       \e[44m GS游享网 [https://gsgameshare.com] 专用环境安装成功!\e[0m
#       1.数据库端口: `echo [ ! -z ${TL_MYSQL_PORT} ] && ${TL_MYSQL_PORT} || 33061`
#       2.数据库密码: `echo [ ! -z ${TL_MYSQL_PASSWORD} ] && ${TL_MYSQL_PASSWORD} || 123456`
#       3.登录网关端口: `echo [ ! -z ${LOGIN_PORT} ] && ${LOGIN_PORT} || 13580`
#       4.游戏网关端口: `echo [ ! -z ${SERVER_PORT} ] && ${SERVER_PORT} || 15680`
#       5.网站端口: `echo [ ! -z ${WEB_PORT} ] && ${WEB_PORT} || 58080`
#       6.Billing端口: `echo [ ! -z ${TL_MYSQL_PASSWORD} ] && ${TL_MYSQL_PASSWORD} || 21818`
#       更多天龙网游单机版本请访问：          https://gsgamesahre.com
#       技术交流群：                        826717146
#######################################################################
"
endTime=`date +%s`
((outTime=($endTime-$startTime)/60))
echo -e "总耗时:\e[44m $outTime \e[0m 分钟!"