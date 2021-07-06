#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gs_tl_env.git
# Date :  2021-06-30
# Notes:  GS_TL_Env for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+

# 第一步：更新系统组件，安装docker,docker-composer
# 第二步：下载GS相关命令到系统
# 第三步：在线下载打包好的镜像或者导入离线版本的镜像
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
startTime=`date +%s`
# 检测是不是root用户。不是则退出
[ $(id -u) != "0" ] && { echo "${CFAILURE}错误: 你必须使用ROOT用户${CEND}"; exit 1; }
#获取当前脚本路径
GSTL_DIR=$(dirname "`readlink -f $0`")
pushd ${GSTL_DIR} > /dev/null

# 加载配置
. ./.env
. ./include/color.sh
. ./include/check_os.sh

# 帮助信息
show_help() {
  _green "https://gsgameshare.com"
}

# 系统组件安装
sys_plugins_install() {
  echo -e "${CGREEN}开始安装系统常用组件 !!!${CEND}";
  # 安装 wget gcc curl git python
  [ "${PM}" == 'apt-get' ] && apt-get -y update
  [ "${PM}" == 'yum' ] && yum clean all && yum -y update
  ${PM} -y install wget gcc curl python git jq
  [ "${CentOS_ver}" == '8' ] && { yum -y install python36 gcc wget curl git jq; sudo alternatives --set python /usr/bin/python3; }
}

# 安装docker docker-compose
do_install_docker() {
    echo -e "${CGREEN}开始安装环境核心组件 !!!${CEND}";
    egrep "^docker" /etc/group >& /dev/null
    if [ $? -ne 0 ]; then
      sudo groupadd docker
      sudo usermod -aG docker ${USER}
      sudo gpasswd -a ${USER} docker
    fi

    docker info >& /dev/null
    if [ $? -ne 0 ]; then
        # 制作的国内镜像安装脚本
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
      echo -e "${CBLUE}docker was installed !!!${CEND}";
    fi


  curl -L https://get.daocloud.io/docker/compose/releases/download/${DOCKER_COMPOSER_VERSION}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose
  docker-compose --version >& /dev/null
  if [ $? -eq 0 ]; then
    echo -e "${CBLUE} docker-compose was installed !!! ${CEND}";
  fi
}

# 配置常用命令到系统中
set_command() {
    echo -e "${CGREEN}开始设置全局命令 !!!${CEND}";
    ls -l ${GS_PROJECT}/scripts/ | awk '{print $9}' > /tmp/command.txt
    for VAR in `cat /tmp/command.txt`; do
        if [ -n ${VAR} ]; then
            \cp -rf ${GS_PROJECT}/scripts/${VAR} /usr/local/bin/${VAR%%.*} && chmod +x /usr/local/bin/${VAR%%.*}
        fi
    done
    rm -rf /tmp/command.txt
}

# 设置服务器时间
set_timezone() {
    echo -e "${CGREEN}开始设置时区 !!!${CEND}";
    rm -rf /etc/localtime
    ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime
    # 复制一份到docker镜像里面。可以在制作docker镜像时添加
}

# 安装整合
do_install() {
  set_timezone
  [ $? == 0 ] && echo -e "${CBLUE} set_timezone success!! ${CEND}" || { echo -e "${CRED} set_timezone failed!! ;${CEND}"; exit 1;}
  do_install_docker
  [ $? == 0 ] && echo -e "${CBLUE} docker_install success!! ${CEND}" || { echo -e "${CRED} docker_install failed!! ;${CEND}"; exit 1;}
  set_command
  [ $? == 0 ] && echo -e "${CBLUE} set_command success！${CEND}" || { echo -e "${CRED}  set_command failed ！！${CEND}"; exit 1;}
}

# 安装完成提示信息
show_install_msg() {
  printf "${CCYAN}
  #######################################################################
  #       GS_TL_Env 支持： CentOS/RedHat 7+  Ubuntu 18+ Debian 10+
  #       GS游享网 [https://gsgameshare.com] 专用环境安装成功!
  #       安装环境需要移步论坛注册账号才能正常安装，只需要注册账号即可
  #       1.论坛客服QQ:\t1303588722
  #       2.论坛有对应的环境教程，有不懂的可以进论坛--原创教程
  #       3.技术交流群:\t826717146,如果搜索不到群，请加客服QQ,备注进群即可
  #       4.环境还未安装完成，请手动执行 gstl
  #######################################################################
  ${CEND}"
  endTime=`date +%s`
  ((outTime=($endTime-$startTime)/60))
  echo -e "总耗时:\e[44m $outTime \e[0m 分钟!"
}

##################################################################
# 数据交换目录是否存在
[ -d ${SHARE_DIR} ] && chmod 755 ${SHARE_DIR}

# 调用系统组件
sys_plugins_install
clear

# 获取IP地址
IPADDR=$(./include/get_ipaddr.py)
PUBLIC_IPADDR=$(./include/get_public_ipaddr.py)
IPADDR_COUNTRY=$(./include/get_ipaddr_state.py ${PUBLIC_IPADDR})

# 获取系统内存，交换内存
. ./include/memory.sh
# 检查依赖安装包
. ./include/check_sw.sh
# 根据不同版本的系统，安装不同的
case "${LikeOS}" in
  "CentOS")
    installDepsCentOS 2>&1 | tee ${GS_PROJECT}/install.log
    . include/init_CentOS.sh 2>&1 | tee -a ${GS_PROJECT}/install.log
    ;;
  "Debian")
    installDepsDebian 2>&1 | tee ${GS_PROJECT}/install.log
    . include/init_Debian.sh 2>&1 | tee -a ${GS_PROJECT}/install.log
    ;;
  "Ubuntu")
    installDepsUbuntu 2>&1 | tee ${GS_PROJECT}/install.log
    . include/init_Ubuntu.sh 2>&1 | tee -a ${GS_PROJECT}/install.log
    ;;
esac
# 开始安装
do_install
if [ $? -eq 0 ]; then
  show_install_msg
else
  echo -e "${CRED}环境还未安装完成，请手动执行 gstl${CEND}"
fi 