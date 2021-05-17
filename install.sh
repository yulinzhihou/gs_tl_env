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
clear
alias upenv="source /root/.tlgame/.env"
printf "\e[1;35m
#######################################################################
#       GS_TLBB_Env 支持：CentOS/RedHat 7+  Ubuntu 18+ Debian 10+     #
#       更多天龙网游单机版本请访问：       https://gsgamesahre.com    #
#       技术交流群：                       826717146                  #
#       version:                             1.0                      #
#       update:                            2021-03-05                 #
#######################################################################
\033[0m"
# 下载环境源码
download_code()
{
  params=('SHARED_DIR' 'RESTART' 'BILLING_DEFAULT_PORT' 'LOGIN_DEFAULT_PORT' 'TL_MYSQL_DEFAULT_PORT' 'SERVER_DEFAULT_PORT' 'WEB_DEFAULT_PORT' 'TL_MYSQL_DEFAULT_PASSWORD' 'BILLING_PORT' 'LOGIN_PORT' 'TL_MYSQL_PORT' 'SERVER_PORT' 'WEB_PORT' 'TL_MYSQL_PASSWORD' 'GS_PROJECT' 'GS_PROJECT_URL_1' 'GS_PROJECT_URL_2')
  params_value=('/tlgame' 'always' '21818' '13580' '33601' '15680' '58080' '123456' '21818' '13580' '33601' '15680' '58080' '123456' '/root/.tlgame' 'https://gitee.com/yulinzhihou/gs_tl_env.git' 'https://gitee.com/yulinzhihou/gs_tl_env.git')

  for i in $(seq 0 1 16)
  do
      index=$i
      if [ -z "`grep ^'export ${params[index]}' /etc/profile`" ]; then
          echo "export ${params[index]}='${params_value[index]}'" >> /etc/profile
      fi
  done

  source /etc/profile
  if [ ! -d ${GS_PROJECT} ]; then
    cd ~ && git clone ${GS_PROJECT_URL_1} .tlgame && chmod -R 777 ${GS_PROJECT}
  fi

  FILE_PATH="/root/.tlgame/"
  alias upenv="source /root/.tlgame/.env"

  if [ -e ${FILE_PATH} ]; then
    cd ${FILE_PATH} && \cp -rf env.sample .env && source ${FILE_PATH}.env
  fi
}

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
  echo "${CFAILURE}不支持此系统, 请安装 CentOS 7+,Debian 10+,Ubuntu 18+ ${CEND}"
  kill -9 $$
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
  [ "${CentOS_ver}" == '8' ] && { yum -y install python36 gcc wget curl git; sudo alternatives --set python /usr/bin/python3; }
}

# 安装docker docker-compose
do_install_docker()
{
    egrep "^docker" /etc/group >& /dev/null
    if [ $? -ne 0 ]; then
      sudo groupadd docker
      sudo usermod -aG docker ${USER}
    fi

    docker --info >& /dev/null
    if [ $? -ne 0 ]; then
        curl -sSL https://gsgameshare.com/gsdocker | bash -s docker --mirror Aliyun
        if [ ! -e "/etc/docker" ]; then
            sudo mkdir -p /etc/docker
            sudo tee /etc/docker/daemon.json <<EOF
{
  "registry-mirrors": ["https://f0tv1cst.mirror.aliyuncs.com"]
}
EOF
        fi

      [ "${OS}" == "Debian" ] || [ "${OS}" == "Ubuntu" ] && sudo apt-get service docker start
      [ "${OS}" == "CentOS" ] && sudo systemctl daemon-reload && sudo systemctl restart docker
      # 安装 docker-compose
      [ "${OS}" == "Debian" ] || [ "${OS}" == "Ubuntu" ] && sudo apt-get service docker start
      [ "${OS}" == "CentOS" ] && sudo systemctl daemon-reload && sudo systemctl restart docker

    else
      echo -e "${CRED}docker was installed !!!${CEND}";
    fi


  curl -L https://get.daocloud.io/docker/compose/releases/download/1.29.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose
  docker-compose --version
}

# 配置常用命令到系统中
set_command() {
    ls -l ${GS_PROJECT}/scripts/ | awk '{print $9}' > /tmp/command.txt
    for VAR in `cat /tmp/command.txt`; do
        if [ -n ${VAR} ]; then
            \cp -rf ${GS_PROJECT}/scripts/${VAR} /usr/local/bin/${VAR%%.*} && chmod +x /usr/local/bin/${VAR%%.*}
        fi
    done
}

# 启动环境
docker_run ()
{
    if [ ! -e "/root/gs_tl_offline.tar.gz" ]; then
      # 在线镜像拉取
      . /etc/profile
      source /etc/profile
      cd ${GS_PROJECT} && docker-compose up -d
    else
      # 离线版本。暂时没做
      tar zxf gs_tl_offline.tar.gz
    fi
}

# 数据备份
data_backup()
{
    #备份数据库
    crontabCount=`crontab -l | grep docker exec -it `docker ps --format "{{.Names}}" | grep "tlmysql"` | grep -v grep |wc -l`
    if [ $crontabCount -eq 0 ];then
        (echo "0 */1 * * * sh docker exec -it `docker ps --format "{{.Names}}" | grep "tlmysql"``docker ps --format "{{.Names}}" | grep "tlmysql"` /bin/bash -c './tlmysql_backup.sh' > /dev/null 2>&1 &"; crontab -l) | crontab
    fi

    docker cp /root/.tlgame/include/tlmysql_backup.sh `docker ps --format "{{.Names}}" | grep "tlmysql"`:/
    docker exec -it gs_tlmysql_1 /bin/bash -c "chmod -R 777 /tlmysql_backup.sh"

    #备份服务端
    crontabCount=`crontab -l | grep `docker ps --format "{{.Names}}" | grep "server"` | grep -v grep |wc -l`
    if [ $crontabCount -eq 0 ];then
        (echo "0 */1 * * * sh  > /dev/null 2>&1 &"; crontab -l) | crontab
    fi
}

##################################################################
# 开始调用
sys_plugins_install
download_code
[ $? == 0 ] && echo -e "${CBLUE} download_code success!! ${CEND}" || { echo -e "${CRED} download_code failed!! ${CEND}"; exit 1; }
do_install_docker
[ $? == 0 ] && echo -e "${CBLUE} docker_install success!! ${CEND}" || { echo -e "${CRED} docker_install failed!! ;${CEND}"; exit 1;}
set_command
[ $? == 0 ] && echo -e "${CBLUE} set_command success！${CEND}" || { echo -e "${CRED}  set_command failed ！！${CEND}"; exit 1;}
docker_run
[ $? == 0 ] && echo -e "${CBLUE} docker_run success！${CEND}" || { echo -e "${CRED}  docker_run failed ！！${CEND}"; exit 1;}
data_backup
[ $? == 0 ] && echo -e "${CBLUE} data_backup success！${CEND}" || { echo -e "${CRED}  data_backup failed ！！${CEND}"; exit 1;}
##################################################################
printf "${CBLUE}
#######################################################################
#       GS_TL_Env 支持： CentOS/RedHat 7+  Ubuntu 18+ Debian 10+
#       \e[44m GS游享网 [https://gsgameshare.com] 专用环境安装成功!\e[0m
#       1.数据库端口: \t`[ ! -z ${TL_MYSQL_PORT} ] && echo ${TL_MYSQL_PORT} || echo 33061`
#       2.数据库密码: \t`[ ! -z ${TL_MYSQL_PASSWORD} ] && echo ${TL_MYSQL_PASSWORD} || echo 123456`
#       3.登录网关端口: `[ ! -z ${LOGIN_PORT} ] && echo ${LOGIN_PORT} || echo 13580`
#       4.游戏网关端口: `[ ! -z ${SERVER_PORT} ] && echo ${SERVER_PORT} || echo 15680`
#       5.网站端口: \t`[ ! -z ${WEB_PORT} ] && echo ${WEB_PORT} || echo 58080`
#       6.验证端口: \t`[ ! -z ${BILLING_PORT} ] && echo ${BILLING_PORT} || echo 21818`
#       7.技术交流群：\t826717146
#       8.更多命令请运行: gs 查看
#######################################################################
${CEND}"
endTime=`date +%s`
((outTime=($endTime-$startTime)/60))
echo -e "总耗时:\e[44m $outTime \e[0m 分钟!"