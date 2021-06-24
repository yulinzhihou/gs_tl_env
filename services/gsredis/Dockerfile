FROM 5.0.3-alpine

LABEL author="yulinzhihou@gmail.com" website="https://gsgameshare.com"

COPY ./redis.conf /etc/

ENTRYPOINT ["redis-server", "/etc/redis.conf"]