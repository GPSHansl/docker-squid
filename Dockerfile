FROM ubuntu:bionic-20190612
LABEL maintainer="sameer@damagehead.com"

ENV SQUID_VERSION=3.5.27 \
    SQUID_CACHE_DIR=/var/spool/squid \
    SQUID_LOG_DIR=/var/log/squid \
    SQUID_USER=proxy \
    SQUID_SQUISH_VERSION=0.0.18 \
    SQUID_SQUISH_DEST=

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y squid=${SQUID_VERSION}* curl \
 && rm -rf /var/lib/apt/lists/*

RUN sed -i.bak /etc/squid/squid.conf \
 -e 's/^#acl localnet src 172.16.0.0\/12/acl localnet src 172.16.0.0\/12/' \
 -e 's/^#acl localnet src 192.168.0.0\/16/acl localnet src 192.168.0.0\/16/' \
 -e 's/^#http_access allow localnet/http_access allow localnet/' \
 -e '/^[ \t]*#/d' -e '/^\t*$/d'

# RUN curl https://www.mcgill.org.za/software/squish/squish-${SQUID_SQUISH_VERSION}.tar.gz -o squish-${SQUID_SQUISH_VERSION}.tar.gz  \
# && tar xzf squish-${SQUID_SQUISH_VERSION}.tar.gz \
# && cd squish-${SQUID_SQUISH_VERSION} \
# && mkdir -p /usr/local/squish \
# && install squish.pl squish.cron.sh squish.cgi squish.pm rrdsquish.pm apache-squish.conf /usr/local/squish \
# && install squish.conf /etc/squid/ \
# && cd /usr/local/squish \
# && sed -e "s/use rrdsquish;/use lib \".\/rrdsquish.pm\";/g" -e "s/do \"squish.pm\"/do \".\/squish.pm\"/g" -i.bak squish.pl \
# && export PERL5LIB=/usr/local/squish \
# && /usr/local/squish/squish.pl --install \
# && touch /etc/squid/squished \
# && /usr/local/squish/squish.cron.sh --install

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 3128/tcp
ENTRYPOINT ["/sbin/entrypoint.sh"]
