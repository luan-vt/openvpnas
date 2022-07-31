FROM ubuntu:focal

# set version label
ARG BUILD_DATE
ARG VERSION
ARG OPENVPNAS_VERSION 
LABEL maintainer="luanvt"

# environment settings
ARG DEBIAN_FRONTEND="noninteractive"

RUN \
   CODENAME=$(cat /etc/os-release | grep UBUNTU_CODENAME | awk -F '=' '{print $2}') && \
   echo "**** install dependencies ****" && \
   apt-get update && \
   apt-get install --no-install-recommends -y \
      ca-certificates \
      python3 \
      curl \
      wget \
      net-tools \
      gnupg \
      bridge-utils \
      dmidecode \
      iptables \
      iproute2 \
      libc6 \
      libffi7 \
      libgcc-s1 \
      liblz4-1 \
      liblzo2-2 \
      libmariadb3 \
      libpcap0.8 \
      libssl1.1 \
      libstdc++6 \
      libsasl2-2 \
      libsqlite3-0 \
      net-tools \
      python3-pkg-resources \
      python3-migrate \
      python3-sqlalchemy \
      python3-mysqldb \
      python3-ldap3 \
      sqlite3 \
      mysql-client libmysqlclient-dev \
      zlib1g && \
   echo "**** add openvpn-as repo ****" && \
   curl -s https://as-repository.openvpn.net/as-repo-public.gpg | apt-key add - && \
   echo "deb http://as-repository.openvpn.net/as/debian $CODENAME main">/etc/apt/sources.list.d/openvpn-as-repo.list && \
   if [ -z ${OPENVPNAS_VERSION+x} ]; then \
      OPENVPNAS_VERSION=$(curl -sX GET http://as-repository.openvpn.net/as/debian/dists/$CODENAME/main/binary-amd64/Packages.gz | gunzip -c \
      |grep -A 7 -m 1 "Package: openvpn-as" | awk -F ": " '/Version/{print $2;exit}');\
   fi && \
   echo "$OPENVPNAS_VERSION" > /version.txt && \
   apt update && \
   rm -rf \
      /tmp/* /var/lib/apt/lists/*

# ports and volumes
ADD scripts/ /scripts
RUN chmod -R +x /scripts
ENV PATH="/scripts:${PATH}"

EXPOSE 943/tcp 1194/udp 9443/tcp

RUN ln -s /app /usr/local/openvpn_as
WORKDIR /app

VOLUME /app
ENTRYPOINT ["entrypoint.sh"]
