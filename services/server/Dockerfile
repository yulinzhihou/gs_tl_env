#FROM registry.cn-hangzhou.aliyuncs.com/yulinzhihou/gs_server:v0.1
#
#WORKDIR /home/tlbb
#
#COPY ./config/odbc.ini /etc/odbc.ini
#RUN ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo 'Asia/Shanghai' > /etc/timezone
#CMD tail -f /dev/null

FROM centos:6.8
LABEL author="yulinzhihou"
LABEL document="https://gsgameshare.com"

WORKDIR /home/tlbb

COPY ./config/mysql-connector-odbc-5.1.5r1144-7.el6.i686.rpm /tmp/mysql-connector-odbc-5.1.5r1144-7.el6.i686.rpm
COPY ./config/*.repo /etc/yum.repos.d/

RUN yum clean all && \
    yum makecache && \
    yum update -y && \
    yum check && \
    yum install -y libstdc++.i686 unixODBC.i686 && \
    ln -s /usr/lib/libodbc.so /usr/lib/libodbc.so.1 && \
    yum localinstall -y /tmp/mysql-connector-odbc-5.1.5r1144-7.el6.i686.rpm && \
    ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo 'Asia/Shanghai' > /etc/timezone && \
    rm -f /tmp/mysql-connector-odbc-5.1.5r1144-7.el6.i686.rpm

CMD tail -f /dev/null