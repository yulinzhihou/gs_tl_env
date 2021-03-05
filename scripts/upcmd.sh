#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gs_tl_env.git
# Date :  2021-02-13
# Notes:  GS_TL_Env for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 根据当前环境变量重新生成命令
upenv

if [ ! -d "/root/gs_tl_env" ]; then
  cd ~ && git clone https://github.com/yulinzhihou/gs_tl_env.git && chmod -R 777 gs_tl_env
fi

set_command() {
    ls -l /root/gs_tl_env/scripts/ | awk '{print $9}' > ./command.txt
    for VAR in `cat ./command.txt`; do
        if [ -n ${VAR} ]; then
            \cp -rf ~/gs_tl_env/scripts/${VAR} /usr/local/bin/${VAR%%.*} && chmod +x /usr/local/bin/${VAR%%.*}
        fi
    done
}

set_command

if [ $? == '0' ]; then
  echo -e "\e[44m 命令重新生成成功，如果需要了解详情，可以运行 gs 命令进行帮助查询！！\e[0m"
else
  echo -e "\e[44m 命令重新生成失败，请联系作者，或者重装安装环境\e[0m"
fi