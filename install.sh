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
echo=echo
for cmd in echo /bin/echo; do
  $cmd >/dev/null 2>&1 || continue
  if ! $cmd -e "" | grep -qE '^-e'; then
    echo=$cmd
    break
  fi
done
CSI=$($echo -e "\033[")
CEND="${CSI}0m"
CDGREEN="${CSI}32m"
CRED="${CSI}1;31m"
CGREEN="${CSI}1;32m"
CYELLOW="${CSI}1;33m"
CBLUE="${CSI}1;34m"
CMAGENTA="${CSI}1;35m"
CCYAN="${CSI}1;36m"
CSUCCESS="$CDGREEN"
CFAILURE="$CRED"
CQUESTION="$CMAGENTA"
CWARNING="$CYELLOW"
CMSG="$CCYAN"
# 检测系统版本
if [ -e "/usr/bin/yum" ]; then
  PM=yum
  command -v lsb_release >/dev/null 2>&1 || { [ -e "/etc/euleros-release" ] && yum -y install euleros-lsb || yum -y install redhat-lsb-core; clear; }
fi
if [ -e "/usr/bin/apt-get" ]; then
  PM=apt-get
  command -v lsb_release >/dev/null 2>&1 || { apt-get -y update; apt-get -y install lsb-release; clear; }
fi

command -v lsb_release >/dev/null 2>&1 || { echo "${CFAILURE}${PM} source failed! ${CEND}"; kill -9 $$; }

# Get OS Version
if [ -e /etc/redhat-release ]; then
  OS=CentOS
  CentOS_ver=$(lsb_release -sr | awk -F. '{print $1}')
  [ -n "$(lsb_release -is | grep -Ei 'Alibaba|Aliyun')" ] && { CentOS_ver=7; Aliyun_ver=$(lsb_release -rs); }
  [[ "$(lsb_release -is)" =~ ^EulerOS$ ]] && { CentOS_ver=7; EulerOS_ver=$(lsb_release -rs); }
  [ "$(lsb_release -is)" == 'Fedora' ] && [ ${CentOS_ver} -ge 19 >/dev/null 2>&1 ] && { CentOS_ver=7; Fedora_ver=$(lsb_release -rs); }
elif [ -n "$(grep 'Amazon Linux' /etc/issue)" -o -n "$(grep 'Amazon Linux' /etc/os-release)" ]; then
  OS=CentOS
  CentOS_ver=7
elif [ -n "$(grep 'bian' /etc/issue)" -o "$(lsb_release -is 2>/dev/null)" == "Debian" ]; then
  OS=Debian
  Debian_ver=$(lsb_release -sr | awk -F. '{print $1}')
elif [ -n "$(grep 'Deepin' /etc/issue)" -o "$(lsb_release -is 2>/dev/null)" == "Deepin" ]; then
  OS=Debian
  Debian_ver=8
elif [ -n "$(grep -w 'Kali' /etc/issue)" -o "$(lsb_release -is 2>/dev/null)" == "Kali" ]; then
  OS=Debian
  if [ -n "$(grep 'VERSION="2016.*"' /etc/os-release)" ]; then
    Debian_ver=8
  elif [ -n "$(grep 'VERSION="2017.*"' /etc/os-release)" ]; then
    Debian_ver=9
  elif [ -n "$(grep 'VERSION="2018.*"' /etc/os-release)" ]; then
    Debian_ver=9
  fi
elif [ -n "$(grep 'Ubuntu' /etc/issue)" -o "$(lsb_release -is 2>/dev/null)" == "Ubuntu" -o -n "$(grep 'Linux Mint' /etc/issue)" ]; then
  OS=Ubuntu
  Ubuntu_ver=$(lsb_release -sr | awk -F. '{print $1}')
  [ -n "$(grep 'Linux Mint 18' /etc/issue)" ] && Ubuntu_ver=16
elif [ -n "$(grep 'elementary' /etc/issue)" -o "$(lsb_release -is 2>/dev/null)" == 'elementary' ]; then
  OS=Ubuntu
  Ubuntu_ver=16
fi

# Check OS Version
if [ ${CentOS_ver} -lt 6 >/dev/null 2>&1 ] || [ ${Debian_ver} -lt 8 >/dev/null 2>&1 ] || [ ${Ubuntu_ver} -lt 14 >/dev/null 2>&1 ]; then
  echo "${CFAILURE}Does not support this OS, Please install CentOS 6+,Debian 8+,Ubuntu 14+ ${CEND}"
  kill -9 $$
fi

command -v gcc > /dev/null 2>&1 || $PM -y install gcc
gcc_ver=$(gcc -dumpversion | awk -F. '{print $1}')

[ ${gcc_ver} -lt 5 >/dev/null 2>&1 ] && redis_ver=${redis_oldver}

if uname -m | grep -Eqi "arm|aarch64"; then
  armplatform="y"
  if uname -m | grep -Eqi "armv7"; then
    TARGET_ARCH="armv7"
  elif uname -m | grep -Eqi "armv8"; then
    TARGET_ARCH="arm64"
  elif uname -m | grep -Eqi "aarch64"; then
    TARGET_ARCH="aarch64"
  else
    TARGET_ARCH="unknown"
  fi
fi

if [ "$(uname -r | awk -F- '{print $3}' 2>/dev/null)" == "Microsoft" ]; then
  Wsl=true
fi

if [ "$(getconf WORD_BIT)" == "32" ] && [ "$(getconf LONG_BIT)" == "64" ]; then
  OS_BIT=64
  SYS_BIT_j=x64 #jdk
  SYS_BIT_a=x86_64 #mariadb
  SYS_BIT_b=x86_64 #mariadb
  SYS_BIT_c=x86_64 #ZendGuardLoader
  SYS_BIT_d=x86-64 #ioncube
  [ "${TARGET_ARCH}" == 'aarch64' ] && { SYS_BIT_c=aarch64; SYS_BIT_d=aarch64; }
else
  OS_BIT=32
  SYS_BIT_j=i586
  SYS_BIT_a=x86
  SYS_BIT_b=i686
  SYS_BIT_c=i386
  SYS_BIT_d=x86
  [ "${TARGET_ARCH}" == 'armv7' ] && { SYS_BIT_c=armhf; SYS_BIT_d=armv7l; }
fi

THREAD=$(grep 'processor' /proc/cpuinfo | sort -u | wc -l)

# Percona binary: https://www.percona.com/doc/percona-server/5.7/installation.html#installing-percona-server-from-a-binary-tarball
if [ ${Debian_ver} -lt 9 >/dev/null 2>&1 ] || [ ${Ubuntu_ver} -lt 14 >/dev/null 2>&1 ]; then
  sslLibVer=ssl100
elif [[ "${CentOS_ver}" =~ ^[6-7]$ ]] && [ "$(lsb_release -is)" != 'Fedora' ]; then
  sslLibVer=ssl101
elif [ ${Debian_ver} -ge 9 >/dev/null 2>&1 ] || [ ${Ubuntu_ver} -ge 14 >/dev/null 2>&1 ]; then
  sslLibVer=ssl102
elif [ ${Fedora_ver} -ge 27 >/dev/null 2>&1 ]; then
  sslLibVer=ssl102
elif [ "${CentOS_ver}" == '8' ]; then
  sslLibVer=ssl1:111
else
  sslLibVer=unknown
fi

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
      cd /root/gs_tl_env && docker-compose up -d
    else
      # 离线版本。暂时没做
      tar zxf gs_tl_offline.tar.gz
    fi
}

# 下载环境源码
download_code()
{
  cd ~ && git clone https://github.com/yulinzhihou/gs_tl_env.git && chmod -R 777 gs_tl_env
  \cp -rf  ~/gs_tl_env/include/env.sh /usr/local/bin/env_variable && chmod a+x /usr/local/bin/env_variable
  export $(grep -v '^#' /usr/local/bin/env_variable | xargs -d '\n')
}

sys_plugins_install
do_install_docker
download_code

# 初始化配置
# 修改billing参数
[ -z "`grep ^BILLING_PORT /usr/local/bin/env_variable`" ] && BILLING_PORT=${BILLING_DEFAULT_PORT} || BILLING_PORT=${BILLING_PORT}
while :; do echo
  read -e -p "当前【Billing验证端口】为：${CBLUE}[${BILLING_PORT}]${CEND}，是否需要修改【Billing验证端口】 [y/n](默认: n): " IS_MODIFY
  if [[ ! ${IS_MODIFY} =~ ^[y,n]$ ]]; then
      echo "${CWARNING}输入错误! 请输入 'y' 或者 'n' ${CEND}"
  else
    if [ "${IS_MODIFY}" == 'y' ]; then
      while :; do echo
        read -p "请输入【Billing验证端口】：(默认: ${BILLING_DEFAULT_PORT}): " BILLING_NEW_PORT
        BILLING_NEW_PORT={${BILLING_NEW_PORT}:-${BILLING_DEFAULT_PORT}}
        if [ ${BILLING_NEW_PORT} == ${BILLING_DEFAULT_PORT} >/dev/null 2>&1 -o ${BILLING_NEW_PORT} -gt 1024 >/dev/null 2>&1 -a ${BILLING_NEW_PORT} -lt 65535 >/dev/null 2>&1 ]; then
          break
        else
          echo "${CWARNING}输入错误! 端口范围: 1025~65534${CEND}"
        fi
      done

      if [ ! -z "`grep ^BILLING_PORT /usr/local/bin/env_variable`" -a "${BILLING_NEW_PORT}" != "${BILLING_DEFAULT_PORT}" ]; then
        echo 'BILLING_PORT="${BILLING_NEW_PORT}"' >> /usr/local/bin/env_variable
      elif [ -n "`grep ^BILLING_PORT /usr/local/bin/env_variable`" ]; then
        sed -i "s@^BILLING_PORT.*@BILLING_PORT=${BILLING_NEW_PORT}@" /usr/local/bin/env_variable
      fi
    fi
    break;
  fi
done

# 修改mysql_Port参数
[ -z "`grep ^TL_MYSQL_PORT /usr/local/bin/env_variable`" ] && TL_MYSQL_PORT=${TL_MYSQL_DEFAULT_PORT} || TL_MYSQL_PORT=${TL_MYSQL_PORT}
while :; do echo
  read  -e -p "当前【mysql端口】为：${CBLUE}[${TL_MYSQL_PORT}]${CEND}，是否需要修改【mysql端口】 [y/n](默认: n): " IS_MODIFY
  if [[ ! ${IS_MODIFY} =~ ^[y,n]$ ]]; then
      echo "${CWARNING}输入错误! 请输入 'y' 或者 'n',当前【mysql端口】为：[${TL_MYSQL_PORT}]${CEND}"
  else
    if [ "${IS_MODIFY}" == 'y' ]; then
      while :; do echo
        read -p "请输入【mysql端口】：(默认: ${TL_MYSQL_DEFAULT_PORT}): " TL_MYSQL_NEW_PORT
        TL_MYSQL_NEW_PORT={${TL_MYSQL_NEW_PORT}:-${TL_MYSQL_DEFAULT_PORT}}
        if [ ${TL_MYSQL_NEW_PORT} -eq ${TL_MYSQL_DEFAULT_PORT} >/dev/null 2>&1 -o ${TL_MYSQL_NEW_PORT} -gt 1024 >/dev/null 2>&1 -a ${TL_MYSQL_NEW_PORT} -lt 65535 >/dev/null 2>&1 ]; then
          break
        else
          echo "${CWARNING}输入错误! 端口范围: 1025~65534${CEND}"
        fi
      done

      if [ ! -z "`grep ^TL_MYSQL_PORT /usr/local/bin/env_variable`" -a "${TL_MYSQL_NEW_PORT}" != "${TL_MYSQL_DEFAULT_PORT}" ]; then
        echo 'TL_MYSQL_PORT="${TL_MYSQL_NEW_PORT}"' >> /usr/local/bin/env_variable
      elif [ -n "`grep ^TL_MYSQL_PORT /usr/local/bin/env_variable`" ]; then
        sed -i "s@^TL_MYSQL_PORT.*@TL_MYSQL_PORT=${TL_MYSQL_NEW_PORT}@" /usr/local/bin/env_variable
      fi
    fi
    break
  fi
done

# 修改login_Port参数
[ -z "`grep ^LOGIN_PORT /usr/local/bin/env_variable`" ] && LOGIN_PORT=${LOGIN_DEFAULT_PORT} || LOGIN_PORT=${LOGIN_PORT}
while :; do echo
  read  -e -p "当前【登录端口】为：${CBLUE}[${LOGIN_PORT}]${CEND}，是否需要修改【登录端口】 [y/n](默认: n): " IS_MODIFY
  if [[ ! ${IS_MODIFY} =~ ^[y,n]$ ]]; then
      echo "${CWARNING}输入错误! 请输入 'y' 或者 'n',当前【登录端口】为：[${LOGIN_PORT}]${CEND}"
  else
    if [ "${IS_MODIFY}" == 'y' ]; then
      while :; do echo
        read -p "请输入【登录端口】：(默认: ${LOGIN_DEFAULT_PORT}): " LOGIN_NEW_PORT
        LOGIN_NEW_PORT={${LOGIN_NEW_PORT}:-${LOGIN_PORT}}
        if [ ${LOGIN_NEW_PORT} -eq ${LOGIN_DEFAULT_PORT} >/dev/null 2>&1 -o ${LOGIN_NEW_PORT} -gt 1024 >/dev/null 2>&1 -a ${LOGIN_NEW_PORT} -lt 65535 >/dev/null 2>&1 ]; then
          break
        else
          echo "${CWARNING}输入错误! 端口范围: 1025~65534${CEND}"
        fi
      done

      if [ ! -z "`grep ^LOGIN_PORT /usr/local/bin/env_variable`" -a "${LOGIN_NEW_PORT}" != "${LOGIN_DEFAULT_PORT}" ]; then
         echo 'LOGIN_PORT="${LOGIN_PORT}"' >> /usr/local/bin/env_variable
      elif [ -n "`grep ^LOGIN_PORT /usr/local/bin/env_variable`" ]; then
        sed -i "s@^LOGIN_PORT.*@LOGIN_PORT=${LOGIN_NEW_PORT}@" /usr/local/bin/env_variable
      fi
    fi
    break
  fi
done


# 修改Game_Port参数
[ -z "`grep ^SERVER_PORT /usr/local/bin/env_variable`" ] && SERVER_PORT=${SERVER_DEFAULT_PORT} || SERVER_PORT=${SERVER_PORT}
while :; do echo
  read  -e -p "当前【游戏端口】为：${CBLUE}[${SERVER_PORT}]${CEND}，是否需要修改【游戏端口】 [y/n](默认: n): " IS_MODIFY
  
  if [[ ! ${IS_MODIFY} =~ ^[y,n]$ ]]; then
      echo "${CWARNING}输入错误! 请输入 'y' 或者 'n',当前【游戏端口】为：[${SERVER_PORT}]${CEND}"
  else
    if [ "${IS_MODIFY}" == 'y' ]; then
      while :; do echo
        read -p "请输入【游戏端口】：(默认: ${SERVER_DEFAULT_PORT}): " SERVER_NEW_PORT
        SERVER_NEW_PORT={${SERVER_NEW_PORT}:-${SERVER_DEFAULT_PORT}}
        if [ ${SERVER_NEW_PORT} -eq ${SERVER_DEFAULT_PORT} >/dev/null 2>&1 -o ${SERVER_NEW_PORT} -gt 1024 >/dev/null 2>&1 -a ${SERVER_NEW_PORT} -lt 65535 >/dev/null 2>&1 ]; then
          break
        else
          echo "${CWARNING}输入错误! 端口范围: 1025~65534${CEND}"
        fi
      done

      if [ ! -z "`grep ^SERVER_PORT /usr/local/bin/env_variable`" -a "${SERVER_NEW_PORT}" != "${SERVER_DEFAULT_PORT}" ]; then
        echo 'SERVER_PORT="${SERVER_PORT}"' >> /usr/local/bin/env_variable
      elif [ -n "`grep ^SERVER_PORT /usr/local/bin/env_variable`" ]; then
        sed -i "s@^SERVER_PORT.*@SERVER_PORT=${SERVER_NEW_PORT}@" /usr/local/bin/env_variable
      fi
    fi
    break
  fi
done

# 修改WEB_Port参数
[ -z "`grep ^WEB_PORT /usr/local/bin/env_variable`" ] && WEB_PORT=${WEB_DEFAULT_PORT} || WEB_PORT=${WEB_PORT}
while :; do echo
  read  -e -p "当前【网站端口】为：${CBLUE}[${WEB_PORT}]${CEND}，是否需要修改【网站端口】 [y/n](默认: n): " IS_MODIFY
  if [[ ! ${IS_MODIFY} =~ ^[y,n]$ ]]; then
      echo "${CWARNING}输入错误! 请输入 'y' 或者 'n',当前【网站端口】为：[${WEB_PORT}]${CEND}"
  else
    if [ "${IS_MODIFY}" == 'y' ]; then
      while :; do echo
        read -p "请输入【网站端口】：(默认: ${WEB_DEFAULT_PORT}): " WEB_NEW_PORT
        WEB_NEW_PORT={${WEB_NEW_PORT}:-${WEB_PORT}}
        if [ ${WEB_NEW_PORT} -eq ${WEB_DEFAULT_PORT} >/dev/null 2>&1 -o ${WEB_NEW_PORT} -gt 1024 >/dev/null 2>&1 -a ${WEB_NEW_PORT} -lt 65535 >/dev/null 2>&1 ]; then
          break
        else
          echo "${CWARNING}输入错误! 端口范围: 1025~65534${CEND}"
        fi
      done

      if [ ! -z "`grep ^WEB_PORT /usr/local/bin/env_variable`" -a "${WEB_NEW_PORT}" != "${WEB_DEFAULT_PORT}" ]; then
        echo 'WEB_PORT="${WEB_PORT}"' >> /usr/local/bin/env_variable
      elif [ -n "`grep ^WEB_PORT /usr/local/bin/env_variable`" ]; then
        sed -i "s@^WEB_PORT.*@WEB_PORT=${WEB_NEW_PORT}@" /usr/local/bin/env_variable
      fi
    fi
    break
  fi
done

# 修改数据库密码
[ -z "`grep ^TL_MYSQL_PASSWORD /usr/local/bin/env_variable`" ] && TL_MYSQL_PASSWORD=${TL_MYSQL_DEFAULT_PASSWORD} || TL_MYSQL_PASSWORD=${TL_MYSQL_PASSWORD}
while :; do echo
  read  -e -p "当前【数据库密码】为：${CBLUE}[${TL_MYSQL_PASSWORD}]${CEND}，是否需要修改【数据库密码】 [y/n](默认: n): " IS_MODIFY
  if [[ ! ${IS_MODIFY} =~ ^[y,n]$ ]]; then
      echo "${CWARNING}输入错误! 请输入 'y' 或者 'n',当前【数据库密码】为：[${TL_MYSQL_PASSWORD}]${CEND}"
  else
    if [ "${IS_MODIFY}" == 'y' ]; then
      while :; do echo
        read -p "请输入【数据库密码】(默认: ${TL_MYSQL_DEFAULT_PASSWORD}): " TL_MYSQL_NEW_PASSWORD
        TL_MYSQL_NEW_PASSWORD={${TL_MYSQL_NEW_PASSWORD}:-${TL_MYSQL_PASSWORD}}
        if (( ${#TL_MYSQL_NEW_PASSWORD} >= 5 )); then
          break
        else
          echo "${CWARNING}密码最少要6个字符! ${CEND}"
        fi
      done

      if [ ! -z "`grep ^TL_MYSQL_PASSWORD /usr/local/bin/env_variable`" -a "${TL_MYSQL_NEW_PASSWORD}" != "${TL_MYSQL_DEFAULT_PASSWORD}" ]; then
        echo 'TL_MYSQL_PASSWORD="${TL_MYSQL_NEW_PASSWORD}"' >> /usr/local/bin/env_variable
      elif [ -n "`grep ^TL_MYSQL_PASSWORD /usr/local/bin/env_variable`" ]; then
        sed -i "s@^TL_MYSQL_PASSWORD.*@TL_MYSQL_PASSWORD=${TL_MYSQL_NEW_PASSWORD}@" /usr/local/bin/env_variable
      fi
    fi
    break
  fi
done

##################################################################
# 开始调用
docker_run
set_command
##################################################################
# 安装完成提示
source /usr/local/bin/env_variable
printf "
#######################################################################
#       GS_TL_Env 支持： CentOS/RedHat 7+  Ubuntu 18+ Debian 10+
#       \e[44m GS游享网 [https://gsgameshare.com] 专用环境安装成功!\e[0m
#       1.数据库端口: \t`[ ! -z ${TL_MYSQL_PORT} ] && echo ${TL_MYSQL_PORT} || echo 33061`
#       2.数据库密码: \t`[ ! -z ${TL_MYSQL_PASSWORD} ] && echo ${TL_MYSQL_PASSWORD} || echo 123456`
#       3.登录网关端口: \t`[ ! -z ${LOGIN_PORT} ] && echo ${LOGIN_PORT} || echo 13580`
#       4.游戏网关端口: \t`[ ! -z ${SERVER_PORT} ] && echo ${SERVER_PORT} || echo 15680`
#       5.网站端口: \t`[ ! -z ${WEB_PORT} ] && echo ${WEB_PORT} || echo 58080`
#       6.验证端口: \t`[ ! -z ${TL_MYSQL_PASSWORD} ] && echo ${TL_MYSQL_PASSWORD} || echo 21818`
#       7.技术交流群：\t826717146
#       8.更多命令请运行 > gs
#######################################################################
"
endTime=`date +%s`
((outTime=($endTime-$startTime)/60))
echo -e "总耗时:\e[44m $outTime \e[0m 分钟!"