#!/usr/bin/env bash
# Author: yulinzhihou <yulinzhihou@gmail.com>
# Forum:  https://gsgamesahre.com
# Project: https://github.com/yulinzhihou/gs_tl_env.git
# Date :  2021-02-01
# Notes:  GS_TL_Env for CentOS/RedHat 7+ Debian 10+ and Ubuntu 18+
# comment: 当用户需要重新生成数据库端口，密码时，则使用此命令进行重装写入配置，注意，执行完成后需要重启服务器再进行配置。否则需要使用 source /etc/profile.d 让数据临时生效
# 修改billing参数
source /etc/profile
# 初始化配置
param1=('BILLING_PORT' 'LOGIN_PORT' 'TL_MYSQL_PORT' 'SERVER_PORT' 'WEB_PORT' 'TL_MYSQL_PASSWORD')
param2=('BILLING_DEFAULT_PORT' 'LOGIN_DEFAULT_PORT' 'TL_MYSQL_DEFAULT_PORT' 'SERVER_DEFAULT_PORT' 'WEB_DEFAULT_PORT' 'TL_MYSQL_DEFAULT_PASSWORD')
param3=('BILLING验证端口' '登录端口' 'mysql端口' '游戏端口' '网站端口' '数据库密码')
param4=('BILLING_NEW_PORT' 'TL_MYSQL_NEW_PORT' 'SERVER_NEW_PORT' 'WEB_NEW_PORT' 'TL_MYSQL_NEW_PASSWORD')

 for i in $(seq 0 1 5)
 do
    index=$i
    source /etc/profile;
    param11=${param1[index]};
    param111=${!param1[index]};
    param221=${!param2[index]};
    param31=${param3[index]};
    param41=${param4[index]};
    param441=${!param4[index]};
    str='grep '${param1[index]}' /etc/profile';
    [ -z "`${str}`" ] && param11=${param221} || param11=${param111};
    while :; do echo
        read -e -p "当前【${param31}】为：${CBLUE}[${param111}]${CEND}，是否需要修改【${param31}】 [y/n](默认: n): " IS_MODIFY
        IS_MODIFY=${IS_MODIFY:-'n'}
        if [[ ! ${IS_MODIFY} =~ ^[y,n]$ ]]; then
            echo "${CWARNING}输入错误! 请输入 'y' 或者 'n' ${CEND}"
        else
            if [ "${IS_MODIFY}" == 'y' ]; then
                while :; do echo
                    read -p "请输入【${param31}】：(默认: ${param221}): " param41
                    param41=${param41:-${param221}}
                    if ((index==5)); then
                        if (( ${#param41} >= 5 )); then
                            break;
                        else
                            echo "${CWARNING}密码最少要6个字符! ${CEND}"
                        fi
                    else
                        if [ ${param4[index]} == ${param221} >/dev/null 2>&1 -o ${param41} -gt 1024 >/dev/null 2>&1 -a ${param41} -lt 65535 >/dev/null 2>&1 ]; then
                            break;
                        else
                            echo "${CWARNING}输入错误! 端口范围: 1025~65534${CEND}"
                        fi
                    fi
                done

                str1='grep '${param1[index]}' /etc/profile'
                if [ -z "`${str1}`" -a "${param441}" != "${param221}" ]; then
                    echo "export ${param1[index]}=${param41}" >> /etc/profile
                elif [ -n "`${str1}`" ]; then
                    sed -i "s@export ${param1[index]}.*@export ${param1[index]}=${param41}@" /etc/profile
                fi
            fi
            break;
        fi
    done
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
