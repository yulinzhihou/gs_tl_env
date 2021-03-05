#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gs_tl_env.git
# Date :  2021-02-01
# Notes:  GS_TL_Env for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 当用户需要重新生成数据库端口，密码时，则使用此命令进行重装写入配置，注意，执行完成后需要重启服务器再进行配置。否则需要使用 source /etc/profile.d 让数据临时生效
# 修改billing参数
##
#BILLING_PORT=21818
##
#TL_MYSQL_PORT=33061
##
#LOGIN_PORT=13580
##
#SERVER_PORT=15680
##
#WEB_PORT=58080
##
#TL_MYSQL_PASSWORD=123456
source /etc/profile
[ -z "`grep ^'export BILLING_PORT' /etc/profile`" ] && BILLING_PORT=${BILLING_DEFAULT_PORT} || BILLING_PORT=${BILLING_PORT}
while :; do echo
  read -e -p "当前【Billing验证端口】为：${CBLUE}[${BILLING_PORT}]${CEND}，是否需要修改【Billing验证端口】 [y/n](默认: n): " IS_MODIFY
  IS_MODIFY=${IS_MODIFY:-'n'}
  if [[ ! ${IS_MODIFY} =~ ^[y,n]$ ]]; then
      echo "${CWARNING}输入错误! 请输入 'y' 或者 'n' ${CEND}"
  else
    if [ "${IS_MODIFY}" == 'y' ]; then
      while :; do echo
        read -p "请输入【Billing验证端口】：(默认: ${BILLING_DEFAULT_PORT}): " BILLING_NEW_PORT
        BILLING_NEW_PORT=${BILLING_NEW_PORT:-${BILLING_DEFAULT_PORT}}
        if [ ${BILLING_NEW_PORT} == ${BILLING_DEFAULT_PORT} >/dev/null 2>&1 -o ${BILLING_NEW_PORT} -gt 1024 >/dev/null 2>&1 -a ${BILLING_NEW_PORT} -lt 65535 >/dev/null 2>&1 ]; then
          break
        else
          echo "${CWARNING}输入错误! 端口范围: 1025~65534${CEND}"
        fi
      done

      if [ -z "`grep ^'export BILLING_PORT' /etc/profile`" -a "${BILLING_NEW_PORT}" != "${BILLING_DEFAULT_PORT}" ]; then
        echo "export BILLING_PORT=${BILLING_NEW_PORT}" >> /etc/profile
      elif [ -n "`grep ^'export BILLING_PORT' /etc/profile`" ]; then
        sed -i "s@^export BILLING_PORT.*@export BILLING_PORT=${BILLING_NEW_PORT}@" /etc/profile
      fi
    else
      if [ -z "`grep ^'export BILLING_PORT' /etc/profile`" ]; then
        echo "export BILLING_PORT=${BILLING_DEFAULT_PORT}" >> /etc/profile
      elif [ -n "`grep ^'export BILLING_PORT' /etc/profile`" -a "${BILLING_PORT}" != "${BILLING_DEFAULT_PORT}" ]; then
        sed -i "s@^export BILLING_PORT.*@export BILLING_PORT=${BILLING_DEFAULT_PORT}@" /etc/profile
      fi
    fi
    break;
  fi
done

# 修改mysql_Port参数
source /etc/profile
[ -z "`grep ^'export TL_MYSQL_PORT' /etc/profile`" ] && TL_MYSQL_PORT=${TL_MYSQL_DEFAULT_PORT} || TL_MYSQL_PORT=${TL_MYSQL_PORT}
while :; do echo
  read  -e -p "当前【mysql端口】为：${CBLUE}[${TL_MYSQL_PORT}]${CEND}，是否需要修改【mysql端口】 [y/n](默认: n): " IS_MODIFY
  IS_MODIFY=${IS_MODIFY:-'n'}
  if [[ ! ${IS_MODIFY} =~ ^[y,n]$ ]]; then
      echo "${CWARNING}输入错误! 请输入 'y' 或者 'n',当前【mysql端口】为：[${TL_MYSQL_PORT}]${CEND}"
  else
    if [ "${IS_MODIFY}" == 'y' ]; then
      while :; do echo
        read -p "请输入【mysql端口】：(默认: ${TL_MYSQL_DEFAULT_PORT}): " TL_MYSQL_NEW_PORT
        TL_MYSQL_NEW_PORT=${TL_MYSQL_NEW_PORT:-${TL_MYSQL_DEFAULT_PORT}}
        if [ ${TL_MYSQL_NEW_PORT} -eq ${TL_MYSQL_DEFAULT_PORT} >/dev/null 2>&1 -o ${TL_MYSQL_NEW_PORT} -gt 1024 >/dev/null 2>&1 -a ${TL_MYSQL_NEW_PORT} -lt 65535 >/dev/null 2>&1 ]; then
          break
        else
          echo "${CWARNING}输入错误! 端口范围: 1025~65534${CEND}"
        fi
      done

      if [ -z "`grep ^'export TL_MYSQL_PORT' /etc/profile`" -a "${TL_MYSQL_NEW_PORT}" != "${TL_MYSQL_DEFAULT_PORT}" ]; then
        echo "export TL_MYSQL_PORT=${TL_MYSQL_NEW_PORT}" >> /etc/profile
      elif [ -n "`grep ^'export TL_MYSQL_PORT' /etc/profile`" ]; then
        sed -i "s@^export TL_MYSQL_PORT.*@export TL_MYSQL_PORT=${TL_MYSQL_NEW_PORT}@" /etc/profile
      fi
    else
      if [ -z "`grep ^'export TL_MYSQL_PORT' /etc/profile`" ]; then
        echo "export TL_MYSQL_PORT=${TL_MYSQL_DEFAULT_PORT}" >> /etc/profile
      elif [ -n "`grep ^'export TL_MYSQL_PORT' /etc/profile`" -a "${TL_MYSQL_PORT}" != "${TL_MYSQL_DEFAULT_PORT}" ]; then
        sed -i "s@^export TL_MYSQL_PORT.*@export TL_MYSQL_PORT=${TL_MYSQL_DEFAULT_PORT}@" /etc/profile
      fi
    fi
    break
  fi
done

# 修改login_Port参数
source /etc/profile
[ -z "`grep ^'export LOGIN_PORT' /etc/profile`" ] && LOGIN_PORT=${LOGIN_DEFAULT_PORT} || LOGIN_PORT=${LOGIN_PORT}
while :; do echo
  read  -e -p "当前【登录端口】为：${CBLUE}[${LOGIN_PORT}]${CEND}，是否需要修改【登录端口】 [y/n](默认: n): " IS_MODIFY
  IS_MODIFY=${IS_MODIFY:-'n'}
  if [[ ! ${IS_MODIFY} =~ ^[y,n]$ ]]; then
      echo "${CWARNING}输入错误! 请输入 'y' 或者 'n',当前【登录端口】为：[${LOGIN_PORT}]${CEND}"
  else
    if [ "${IS_MODIFY}" == 'y' ]; then
      while :; do echo
        read -p "请输入【登录端口】：(默认: ${LOGIN_DEFAULT_PORT}): " LOGIN_NEW_PORT
        LOGIN_NEW_PORT=${LOGIN_NEW_PORT:-${LOGIN_PORT}}
        if [ ${LOGIN_NEW_PORT} -eq ${LOGIN_DEFAULT_PORT} >/dev/null 2>&1 -o ${LOGIN_NEW_PORT} -gt 1024 >/dev/null 2>&1 -a ${LOGIN_NEW_PORT} -lt 65535 >/dev/null 2>&1 ]; then
          break
        else
          echo "${CWARNING}输入错误! 端口范围: 1025~65534${CEND}"
        fi
      done

      if [ -z "`grep ^'export LOGIN_PORT' /etc/profile`" -a "${LOGIN_NEW_PORT}" != "${LOGIN_DEFAULT_PORT}" ]; then
         echo "export LOGIN_PORT=${LOGIN_NEW_PORT}" >> /etc/profile
      elif [ -n "`grep ^'export LOGIN_PORT' /etc/profile`" ]; then
        sed -i "s@^export LOGIN_PORT.*@export LOGIN_PORT=${LOGIN_NEW_PORT}@" /etc/profile
      fi
    else
      if [ -z "`grep ^'export LOGIN_PORT' /etc/profile`" ]; then
        echo "export LOGIN_PORT=${LOGIN_DEFAULT_PORT}" >> /etc/profile
      elif [ -n "`grep ^'export LOGIN_PORT' /etc/profile`" -a "${LOGIN_PORT}" != "${LOGIN_DEFAULT_PORT}" ]; then
        sed -i "s@^export LOGIN_PORT.*@export LOGIN_PORT=${LOGIN_DEFAULT_PORT}@" /etc/profile
      fi
    fi
    break
  fi
done

# 修改Game_Port参数
source /etc/profile
[ -z "`grep ^'export SERVER_PORT' /etc/profile`" ] && SERVER_PORT=${SERVER_DEFAULT_PORT} || SERVER_PORT=${SERVER_PORT}
while :; do echo
  read  -e -p "当前【游戏端口】为：${CBLUE}[${SERVER_PORT}]${CEND}，是否需要修改【游戏端口】 [y/n](默认: n): " IS_MODIFY
  IS_MODIFY=${IS_MODIFY:-'n'}
  if [[ ! ${IS_MODIFY} =~ ^[y,n]$ ]]; then
      echo "${CWARNING}输入错误! 请输入 'y' 或者 'n',当前【游戏端口】为：[${SERVER_PORT}]${CEND}"
  else
    if [ "${IS_MODIFY}" == 'y' ]; then
      while :; do echo
        read -p "请输入【游戏端口】：(默认: ${SERVER_DEFAULT_PORT}): " SERVER_NEW_PORT
        SERVER_NEW_PORT=${SERVER_NEW_PORT:-${SERVER_DEFAULT_PORT}}
        if [ ${SERVER_NEW_PORT} -eq ${SERVER_DEFAULT_PORT} >/dev/null 2>&1 -o ${SERVER_NEW_PORT} -gt 1024 >/dev/null 2>&1 -a ${SERVER_NEW_PORT} -lt 65535 >/dev/null 2>&1 ]; then
          break
        else
          echo "${CWARNING}输入错误! 端口范围: 1025~65534${CEND}"
        fi
      done

      if [ -z "`grep ^'export SERVER_PORT' /etc/profile`" -a "${SERVER_NEW_PORT}" != "${SERVER_DEFAULT_PORT}" ]; then
        echo "export SERVER_PORT=${SERVER_NEW_PORT}" >> /etc/profile
      elif [ -n "`grep ^'export SERVER_PORT' /etc/profile`" ]; then
        sed -i "s@^export SERVER_PORT.*@export SERVER_PORT=${SERVER_NEW_PORT}@" /etc/profile
      fi
    else
      if [ -z "`grep ^'export SERVER_PORT' /etc/profile`" ]; then
        echo "export SERVER_PORT=${SERVER_DEFAULT_PORT}" >> /etc/profile
      elif [ -n "`grep ^'export SERVER_PORT' /etc/profile`" -a "${SERVER_PORT}" != "${SERVER_DEFAULT_PORT}" ]; then
        sed -i "s@^export SERVER_PORT.*@export SERVER_PORT=${SERVER_DEFAULT_PORT}@" /etc/profile
      fi
    fi
    break
  fi
done

# 修改WEB_Port参数
source /etc/profile
[ -z "`grep ^'export WEB_PORT' /etc/profile`" ] && WEB_PORT=${WEB_DEFAULT_PORT} || WEB_PORT=${WEB_PORT}
while :; do echo
  read  -e -p "当前【网站端口】为：${CBLUE}[${WEB_PORT}]${CEND}，是否需要修改【网站端口】 [y/n](默认: n): " IS_MODIFY
  IS_MODIFY=${IS_MODIFY:-'n'}
  if [[ ! ${IS_MODIFY} =~ ^[y,n]$ ]]; then
      echo "${CWARNING}输入错误! 请输入 'y' 或者 'n',当前【网站端口】为：[${WEB_PORT}]${CEND}"
  else
    if [ "${IS_MODIFY}" == 'y' ]; then
      while :; do echo
        read -p "请输入【网站端口】：(默认: ${WEB_DEFAULT_PORT}): " WEB_NEW_PORT
        WEB_NEW_PORT=${WEB_NEW_PORT:-${WEB_PORT}}
        if [ ${WEB_NEW_PORT} -eq ${WEB_DEFAULT_PORT} >/dev/null 2>&1 -o ${WEB_NEW_PORT} -gt 1024 >/dev/null 2>&1 -a ${WEB_NEW_PORT} -lt 65535 >/dev/null 2>&1 ]; then
          break
        else
          echo "${CWARNING}输入错误! 端口范围: 1025~65534${CEND}"
        fi
      done

      if [ -z "`grep ^'export WEB_PORT' /etc/profile`" -a "${WEB_NEW_PORT}" != "${WEB_DEFAULT_PORT}" ]; then
        echo "export WEB_PORT=${WEB_NEW_PORT}" >> /etc/profile
      elif [ -n "`grep ^'export WEB_PORT' /etc/profile`" ]; then
        sed -i "s@^export WEB_PORT.*@export WEB_PORT=${WEB_NEW_PORT}@" /etc/profile
      fi
    else
      if [ -z "`grep ^'export WEB_PORT' /etc/profile`" ]; then
        echo "export WEB_PORT=${WEB_DEFAULT_PORT}" >> /etc/profile
      elif [ -n "`grep ^'export WEB_PORT' /etc/profile`" -a "${WEB_PORT}" != "${WEB_DEFAULT_PORT}" ]; then
        sed -i "s@^export WEB_PORT.*@export WEB_PORT=${WEB_DEFAULT_PORT}@" /etc/profile
      fi
    fi
    break
  fi
done

# 修改数据库密码
source /etc/profile
[ -z "`grep ^'export TL_MYSQL_PASSWORD' /etc/profile`" ] && TL_MYSQL_PASSWORD=${TL_MYSQL_DEFAULT_PASSWORD} || TL_MYSQL_PASSWORD=${TL_MYSQL_PASSWORD}
while :; do echo
  read  -e -p "当前【数据库密码】为：${CBLUE}[${TL_MYSQL_PASSWORD}]${CEND}，是否需要修改【数据库密码】 [y/n](默认: n): " IS_MODIFY
  IS_MODIFY=${IS_MODIFY:-'n'}
  if [[ ! ${IS_MODIFY} =~ ^[y,n]$ ]]; then
      echo "${CWARNING}输入错误! 请输入 'y' 或者 'n',当前【数据库密码】为：[${TL_MYSQL_PASSWORD}]${CEND}"
  else
    if [ "${IS_MODIFY}" == 'y' ]; then
      while :; do echo
        read -p "请输入【数据库密码】(默认: ${TL_MYSQL_DEFAULT_PASSWORD}): " TL_MYSQL_NEW_PASSWORD
        TL_MYSQL_NEW_PASSWORD=${TL_MYSQL_NEW_PASSWORD:-${TL_MYSQL_PASSWORD}}
        if (( ${#TL_MYSQL_NEW_PASSWORD} >= 5 )); then
          break
        else
          echo "${CWARNING}密码最少要6个字符! ${CEND}"
        fi
      done

      if [ -z "`grep ^'export TL_MYSQL_PASSWORD' /etc/profile`" -a "${TL_MYSQL_NEW_PASSWORD}" != "${TL_MYSQL_DEFAULT_PASSWORD}" ]; then
        echo "export TL_MYSQL_PASSWORD=${TL_MYSQL_NEW_PASSWORD}" >> /etc/profile
      elif [ -n "`grep ^'export TL_MYSQL_PASSWORD' /etc/profile`" ]; then
        sed -i "s@^export TL_MYSQL_PASSWORD.*@export TL_MYSQL_PASSWORD=${TL_MYSQL_NEW_PASSWORD}@" /etc/profile
      fi
    else
      if [ -z "`grep ^'export TL_MYSQL_PASSWORD' /etc/profile`" ]; then
        echo "export TL_MYSQL_PASSWORD=${TL_MYSQL_DEFAULT_PASSWORD}" >> /etc/profile
      elif [ -n "`grep ^'export TL_MYSQL_PASSWORD' /etc/profile`" -a "${TL_MYSQL_PASSWORD}" != "${TL_MYSQL_DEFAULT_PASSWORD}" ]; then
        sed -i "s@^export TL_MYSQL_PASSWORD.*@export TL_MYSQL_PASSWORD=${TL_MYSQL_DEFAULT_PASSWORD}@" /etc/profile
      fi
    fi
    break
  fi
done
#############################################################################################################################
# 配置完成，加载读取配置。进行重新生成
upenv
# 先停止容器，再将容器删除，重新根据镜像文件以及配置文件，通过docker-compose重新生成容器环境
docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)
# 开环境
cd /root/gs_tl_env && docker-compose up -d
if [ $? == 0 ]; then
  echo -e "\e[43m 配置写入成功！！\e[0m"
else
  echo -e "\e[43m 配置写入失败，请移除环境重新安装！！\e[0m"
fi
