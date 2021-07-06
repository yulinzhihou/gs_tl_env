#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gs_tl_env.git
# Date :  2021-02-01
# Notes:  GS_TL_Env for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 用来配置网站访问。默认网站内容请自觉上传到/tlgame/www/gsgm/public 目录下
# 引入全局参数
if [ -f ./.env ]; then
  . /root/.gs/.env
else
  . /usr/local/bin/.env
fi

if [ -f ./color.sh ]; then
  . ${GS_PROJECT}/scripts/color.sh
else
  . /usr/local/bin/color
fi