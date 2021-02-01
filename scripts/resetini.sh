#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gs_tl_env.git
# Date :  2021-02-01
# Notes:  GS_TL_Env for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 当用户需要重新生成数据库端口，密码时，则使用此命令进行重装写入配置，注意，执行完成后需要重启服务器再进行配置。否则需要使用 source /etc/profile.d 让数据临时生效
#echo -e "export WEB_MYSQL_PORT=`[ ! -z ${WEB_MYSQL_PORT} ] && echo ${WEB_MYSQL_PORT} || echo 33060`" > /tmp/pass.txt
#echo -e "export TLBB_MYSQL_PORT=`[ ! -z ${TLBB_MYSQL_PORT} ] && echo ${TLBB_MYSQL_PORT} || echo 33061`" >> /tmp/pass.txt
#echo -e "export LOGIN_PORT=`[ ! -z ${LOGIN_PORT} ] && echo ${LOGIN_PORT} || echo 13580`" >> /tmp/pass.txt
#echo -e "export SERVER_PORT=`[ ! -z ${SERVER_PORT} ] && echo ${SERVER_PORT} || echo 15680`" >> /tmp/pass.txt
#echo -e "export WEBDB_PASSWORD=`[ ! -z ${WEBDB_PASSWORD} ] && echo ${WEBDB_PASSWORD} || echo 123456`" >> /tmp/pass.txt
#echo -e "export TLBBDB_PASSWORD=`[ ! -z ${TLBBDB_PASSWORD} ] && echo ${TLBBDB_PASSWORD} || echo 123456`" >> /tmp/pass.txt
#echo -e "export BILLING_PORT=`[ ! -z ${BILLING_PORT} ] && echo ${BILLING_PORT} || echo 21818`" >> /tmp/pass.txt
#cat /tmp/pass.txt > /etc/profile.d/gsconfig.sh && rm -rf /tmp/pass.txt
. ./include/get_char.sh
get_char
ARG_NUM=$#
# 修改billing参数
if [ -e "/etc/profile" ]; then
  . /etc/profile
  BILLING_DEFAULT_PORT=21818
  [ ! -z "`grep ^BILLING_PORT /etc/profile`" ] && BILLING_PORT=${BILLING_DEFAULT_PORT} || BILLING_PORT=${BILLING_PORT}
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

    if [ -z "`grep ^BILLING_PORT /etc/profile`" -a "${BILLING_NEW_PORT}" != "${BILLING_DEFAULT_PORT}" ]; then
      echo BILLING_PORT="${BILLING_NEW_PORT}" >> /etc/profile
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

    if [ -z "`grep ^TL_MYSQL_PORT /etc/profile`" -a "${TL_MYSQL_NEW_PORT}" != "${TL_MYSQL_DEFAULT_PORT}" ]; then
      echo TL_MYSQL_PORT="${TL_MYSQL_NEW_PORT}" >> /etc/profile
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

    if [ -z "`grep ^LOGIN_PORT /etc/profile`" -a "${LOGIN_NEW_PORT}" != "${LOGIN_DEFAULT_PORT}" ]; then
       echo LOGIN_PORT="${LOGIN_PORT}" >> /etc/profile
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

    if [ -z "`grep ^SERVER_PORT /etc/profile`" -a "${SERVER_NEW_PORT}" != "${SERVER_DEFAULT_PORT}" ]; then
      echo SERVER_PORT="${SERVER_PORT}" >> /etc/profile
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
    [ -z "`grep ^WEB_PORT /etc/profile`" ] && WEB_PORT=${WEB_DEFAULT_PORT} || WEB_PORT=`grep ^WEB_PORT /etc/profile | awk '{print $2}' | head -1`
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

    if [ -z "`grep ^WEB_PORT /etc/profile`" -a "${WEB_NEW_PORT}" != "${WEB_DEFAULT_PORT}" ]; then
      echo WEB_PORT="${WEB_PORT}" >> /etc/profile
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
      #[ -n "`echo ${dbpwd} | grep '[+|&]'`" ] && { echo "${CWARNING}input error,not contain a plus sign (+) and & ${CEND}"; continue; }
      if (( ${#TL_MYSQL_NEW_PASSWORD} >= 5 )); then
        break
      else
        echo "${CWARNING}密码最少要6个字符! ${CEND}"
      fi
    done

    if [ -z "`grep ^TL_MYSQL_PASSWORD /etc/profile`" -a "${TL_MYSQL_NEW_PASSWORD}" != "${TL_MYSQL_DEFAULT_PASSWORD}" ]; then
      echo TL_MYSQL_PASSWORD="${TL_MYSQL_NEW_PASSWORD}" >> /etc/profile
    elif [ -n "`grep ^TL_MYSQL_PASSWORD /etc/profile`" ]; then
      sed -i "s@^TL_MYSQL_PASSWORD.*@TL_MYSQL_PASSWORD=${TL_MYSQL_NEW_PASSWORD}@" /etc/profile
    fi
  fi
fi

#############################################################################################################################
# 配置完成，加载读取配置。进行重新生成
. /etc/profile
# 先停止容器，再将容器删除，重新根据镜像文件以及配置文件，通过docker-compose重新生成容器环境
docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)
if [ -e "/usr/local/bin/setini" ]; then
  setini
else
  echo -e "\e[43m 配置写入失败，请移除环境重新安装！！\e[0m"
  exit 1;
fi
# 开环境
cd /root/gs_tl_env && docker-compose up -d

