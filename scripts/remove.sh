#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gs_tl_env.git
# Date :  2021-02-01
# Notes:  GS_TL_Env for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 删除所有数据
# 颜色代码
if [ -f ./color.sh ]; then
  . /root/.tlgame/scripts/color.sh
else
  . /usr/local/bin/color
fi

while :; do
  echo
  echo -e "${CBLUE}正在进行删除所有，请选择以下选项中的一项：${CEND}"
  echo -e "\t${CBLUE}1${CEND}. 删除当前容器以及所有数据，请自行备份好："
  echo -e "\t${CBLUE}0${CEND}. 退出！"
  read -e -p "请输入 : (默认 1 按回车) " option
  option=${option:-1}
  if [[ ! ${option} =~ ^[0-1]$ ]]; then
    echo -e "${CRED} 输入错误！请输入 0 或者 1 ${CEND}"
  else
    if [ ${option} == 1 ]; then
      for ((time = 10; time > 0; time--)); do
        echo -ne "\r在准备正行清除操作！！，剩余 ${CBLUE}$time${CEND} 秒，可以在计时结束前，按 CTRL+D 退出！\r"
        sleep 1
      done
      docker stop $(docker ps -a -q) && \
      docker rm -f $(docker ps -a -q) && \
      docker rmi -f $(docker images -q) && \
      mv /tlgame  /tlgame-`date +%Y%m%d%H%I%S` && \
      rm -rf ~/.tlgame
      if [ $? == 0 ]; then
        echo -e "${CBLUE} 数据清除成功，请重新安装环境！！${CEND}"
      else
        echo -e "${CRED} 数据清除失败！可能需要重装系统或者环境了！${CEND}"
      fi
      break
    elif [ ${option} == 0 ]; then
      break
    fi

  fi
done