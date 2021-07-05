#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gs_tl_env.git
# Date :  2021-02-01
# Notes:  GS_TL_Env for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 查看服务器进程情况
# 引入全局参数
if [ -f ./.env ]; then
  . /root/.gs/.env
else
  . /usr/local/bin/.env
fi
# 颜色代码
if [ -f ./color.sh ]; then
  . ${GS_PROJECT}/scripts/color.sh
else
  . /usr/local/bin/color
fi

if [ -n $1 ]; then
    echo -e "${CBLUE} 命令重新生成成功，如果需要了解详情，可以运行 gs 命令进行帮助查询！！${CEND}"
    cd ${ROOT_PATH}/${GSDIR} && docker-compose exec gsserver top
else
    cd ${ROOT_PATH}/${GSDIR} && docker-compose exec $1 top
fi
