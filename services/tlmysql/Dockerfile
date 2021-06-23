# FROM registry.cn-hangzhou.aliyuncs.com/yulinzhihou/gs_tlmysql:v1.0

# 因为直接引用打包好的镜像，下面的操作可以直接不用，如果为开发环境，需要重新打包镜像，就需要开
#
FROM mysql:5.7
LABEL author="yulinzhihou"
LABEL website="https://gsgameshare.com"

COPY ./initdb.d/*.sql /docker-entrypoint-initdb.d/
COPY ./config/* /tmp/
RUN chmod a+x /tmp/create.sh
CMD ["mysqld"]