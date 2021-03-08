#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gs_tl_env.git
# Date :  2021-02-01
# Notes:  GS_TL_Env for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 当用户需要重新生成数据库端口，密码时，则使用此命令进行重装写入配置，注意，执行完成后需要重启服务器再进行配置。否则需要使用 upenv.d 让数据临时生效
# 修改billing参数
# 颜色代码
if [ -f ./color.sh ]; then
  . ./color.sh
else
  . ./color
fi

FILE_PATH="/root/.tlgame/.env"
if [ -f ${FILE_PATH} ]; then
  touch ${FILE_PATH}
fi

upenv
[ -z "`grep ^'BILLING_PORT' ${FILE_PATH}`" ] && BILLING_PORT=${BILLING_DEFAULT_PORT} || BILLING_PORT=${BILLING_PORT}
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

      if [ -z "`grep ^'BILLING_PORT' ${FILE_PATH}`" -a "${BILLING_NEW_PORT}" != "${BILLING_DEFAULT_PORT}" ]; then
        echo "export BILLING_PORT=${BILLING_NEW_PORT}" >> ${FILE_PATH}
      elif [ -n "`grep ^'BILLING_PORT' ${FILE_PATH}`" ]; then
        sed -i "s@^BILLING_PORT.*@BILLING_PORT=${BILLING_NEW_PORT}@" ${FILE_PATH}
      fi
    else
      if [ -z "`grep ^'BILLING_PORT' ${FILE_PATH}`" ]; then
        echo "BILLING_PORT=${BILLING_DEFAULT_PORT}" >> ${FILE_PATH}
      elif [ -n "`grep ^'BILLING_PORT' ${FILE_PATH}`" -a "${BILLING_PORT}" != "${BILLING_DEFAULT_PORT}" ]; then
        sed -i "s@^BILLING_PORT.*@BILLING_PORT=${BILLING_DEFAULT_PORT}@" ${FILE_PATH}
      fi
    fi
    break;
  fi
done

# 修改mysql_Port参数
upenv
[ -z "`grep ^'TL_MYSQL_PORT' ${FILE_PATH}`" ] && TL_MYSQL_PORT=${TL_MYSQL_DEFAULT_PORT} || TL_MYSQL_PORT=${TL_MYSQL_PORT}
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

      if [ -z "`grep ^'TL_MYSQL_PORT' ${FILE_PATH}`" -a "${TL_MYSQL_NEW_PORT}" != "${TL_MYSQL_DEFAULT_PORT}" ]; then
        echo "TL_MYSQL_PORT=${TL_MYSQL_NEW_PORT}" >> ${FILE_PATH}
      elif [ -n "`grep ^'TL_MYSQL_PORT' ${FILE_PATH}`" ]; then
        sed -i "s@^TL_MYSQL_PORT.*@TL_MYSQL_PORT=${TL_MYSQL_NEW_PORT}@" ${FILE_PATH}
      fi
    else
      if [ -z "`grep ^'TL_MYSQL_PORT' ${FILE_PATH}`" ]; then
        echo "TL_MYSQL_PORT=${TL_MYSQL_DEFAULT_PORT}" >> ${FILE_PATH}
      elif [ -n "`grep ^'TL_MYSQL_PORT' ${FILE_PATH}`" -a "${TL_MYSQL_PORT}" != "${TL_MYSQL_DEFAULT_PORT}" ]; then
        sed -i "s@^TL_MYSQL_PORT.*@TL_MYSQL_PORT=${TL_MYSQL_DEFAULT_PORT}@" ${FILE_PATH}
      fi
    fi
    break
  fi
done

# 修改login_Port参数
upenv
[ -z "`grep ^'LOGIN_PORT' ${FILE_PATH}`" ] && LOGIN_PORT=${LOGIN_DEFAULT_PORT} || LOGIN_PORT=${LOGIN_PORT}
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

      if [ -z "`grep ^'LOGIN_PORT' ${FILE_PATH}`" -a "${LOGIN_NEW_PORT}" != "${LOGIN_DEFAULT_PORT}" ]; then
         echo "LOGIN_PORT=${LOGIN_NEW_PORT}" >> ${FILE_PATH}
      elif [ -n "`grep ^'LOGIN_PORT' ${FILE_PATH}`" ]; then
        sed -i "s@^LOGIN_PORT.*@LOGIN_PORT=${LOGIN_NEW_PORT}@" ${FILE_PATH}
      fi
    else
      if [ -z "`grep ^'LOGIN_PORT' ${FILE_PATH}`" ]; then
        echo "LOGIN_PORT=${LOGIN_DEFAULT_PORT}" >> ${FILE_PATH}
      elif [ -n "`grep ^'LOGIN_PORT' ${FILE_PATH}`" -a "${LOGIN_PORT}" != "${LOGIN_DEFAULT_PORT}" ]; then
        sed -i "s@^LOGIN_PORT.*@LOGIN_PORT=${LOGIN_DEFAULT_PORT}@" ${FILE_PATH}
      fi
    fi
    break
  fi
done

# 修改Game_Port参数
upenv
[ -z "`grep ^'SERVER_PORT' ${FILE_PATH}`" ] && SERVER_PORT=${SERVER_DEFAULT_PORT} || SERVER_PORT=${SERVER_PORT}
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

      if [ -z "`grep ^'SERVER_PORT' ${FILE_PATH}`" -a "${SERVER_NEW_PORT}" != "${SERVER_DEFAULT_PORT}" ]; then
        echo "SERVER_PORT=${SERVER_NEW_PORT}" >> ${FILE_PATH}
      elif [ -n "`grep ^'SERVER_PORT' ${FILE_PATH}`" ]; then
        sed -i "s@^SERVER_PORT.*@SERVER_PORT=${SERVER_NEW_PORT}@" ${FILE_PATH}
      fi
    else
      if [ -z "`grep ^'SERVER_PORT' ${FILE_PATH}`" ]; then
        echo "SERVER_PORT=${SERVER_DEFAULT_PORT}" >> ${FILE_PATH}
      elif [ -n "`grep ^'SERVER_PORT' ${FILE_PATH}`" -a "${SERVER_PORT}" != "${SERVER_DEFAULT_PORT}" ]; then
        sed -i "s@^SERVER_PORT.*@SERVER_PORT=${SERVER_DEFAULT_PORT}@" ${FILE_PATH}
      fi
    fi
    break
  fi
done

# 修改WEB_Port参数
upenv
[ -z "`grep ^'WEB_PORT' ${FILE_PATH}`" ] && WEB_PORT=${WEB_DEFAULT_PORT} || WEB_PORT=${WEB_PORT}
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

      if [ -z "`grep ^'WEB_PORT' ${FILE_PATH}`" -a "${WEB_NEW_PORT}" != "${WEB_DEFAULT_PORT}" ]; then
        echo "WEB_PORT=${WEB_NEW_PORT}" >> ${FILE_PATH}
      elif [ -n "`grep ^'WEB_PORT' ${FILE_PATH}`" ]; then
        sed -i "s@^WEB_PORT.*@WEB_PORT=${WEB_NEW_PORT}@" ${FILE_PATH}
      fi
    else
      if [ -z "`grep ^'WEB_PORT' ${FILE_PATH}`" ]; then
        echo "WEB_PORT=${WEB_DEFAULT_PORT}" >> ${FILE_PATH}
      elif [ -n "`grep ^'WEB_PORT' ${FILE_PATH}`" -a "${WEB_PORT}" != "${WEB_DEFAULT_PORT}" ]; then
        sed -i "s@^WEB_PORT.*@WEB_PORT=${WEB_DEFAULT_PORT}@" ${FILE_PATH}
      fi
    fi
    break
  fi
done

# 修改数据库密码
upenv
[ -z "`grep ^'TL_MYSQL_PASSWORD' ${FILE_PATH}`" ] && TL_MYSQL_PASSWORD=${TL_MYSQL_DEFAULT_PASSWORD} || TL_MYSQL_PASSWORD=${TL_MYSQL_PASSWORD}
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

      if [ -z "`grep ^'TL_MYSQL_PASSWORD' ${FILE_PATH}`" -a "${TL_MYSQL_NEW_PASSWORD}" != "${TL_MYSQL_DEFAULT_PASSWORD}" ]; then
        echo "TL_MYSQL_PASSWORD=${TL_MYSQL_NEW_PASSWORD}" >> ${FILE_PATH}
      elif [ -n "`grep ^'TL_MYSQL_PASSWORD' ${FILE_PATH}`" ]; then
        sed -i "s@^TL_MYSQL_PASSWORD.*@TL_MYSQL_PASSWORD=${TL_MYSQL_NEW_PASSWORD}@" ${FILE_PATH}
      fi
    else
      if [ -z "`grep ^'TL_MYSQL_PASSWORD' ${FILE_PATH}`" ]; then
        echo "TL_MYSQL_PASSWORD=${TL_MYSQL_DEFAULT_PASSWORD}" >> ${FILE_PATH}
      elif [ -n "`grep ^'TL_MYSQL_PASSWORD' ${FILE_PATH}`" -a "${TL_MYSQL_PASSWORD}" != "${TL_MYSQL_DEFAULT_PASSWORD}" ]; then
        sed -i "s@^TL_MYSQL_PASSWORD.*@TL_MYSQL_PASSWORD=${TL_MYSQL_DEFAULT_PASSWORD}@" ${FILE_PATH}
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
cd /root/.tlgame && docker-compose up -d
if [ $? == 0 ]; then
  echo -e "${CBLUE} 配置写入成功！！${CEND}"
else
  echo -e "${CRED} 配置写入失败，请移除环境重新安装！！${CEND}"
fi
