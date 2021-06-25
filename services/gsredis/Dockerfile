ARG REDIS_VERSION
FROM redis:${REDIS_VERSION}

LABEL author="yulinzhihou@gmail.com" website="https://gsgameshare.com"

COPY ./redis.conf /etc/

ENTRYPOINT ["redis-server", "/etc/redis.conf"]