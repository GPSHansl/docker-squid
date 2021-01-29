FROM ubuntu:bionic-20190612
LABEL maintainer="sameer@damagehead.com"

ENV SQUID_VERSION=3.5.27 \
    SQUID_CACHE_DIR=/var/spool/squid \
    SQUID_LOG_DIR=/var/log/squid \
    SQUID_USER=proxy \
    SQUID_SQUISH_VERSION=0.0.18

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y squid=${SQUID_VERSION}* \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y perl-CGI perl-GD \
 && rm -rf /var/lib/apt/lists/*

RUN curl https://www.mcgill.org.za/software/squish/squish-${SQUID_SQUISH_VERSION}.tar.gz \
 && tar xzf squish-${SQUID_SQUISH_VERSION}.tar.gz \
 && cd squish-${SQUID_SQUISH_VERSION} \
 && make install

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 3128/tcp
ENTRYPOINT ["/sbin/entrypoint.sh"]
