FROM ubuntu:focal

ARG BUILD_DATE
LABEL maintainer="luanvt"

# environment settings
ARG DEBIAN_FRONTEND="noninteractive"
ENV TZ="Etc/UTC"

RUN \
  apt-get update \
  && apt-get install --no-install-recommends -y \
    ca-certificates \
    wget \
    net-tools \
    gnupg \
    tzdata \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN \
  wget https://as-repository.openvpn.net/as-repo-public.asc -qO /etc/apt/trusted.gpg.d/as-repository.asc \
  && echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/as-repository.asc] http://as-repository.openvpn.net/as/debian focal main">/etc/apt/sources.list.d/openvpn-as-repo.list \
  && apt-get update && apt-get -y install --no-install-recommends  openvpn-as \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

COPY scripts/ /scripts
RUN \
	cp -r /usr/local/openvpn_as/etc /sample_etc && \
	chmod -R +x /scripts && \
	ln -s /usr/local/openvpn_as /app

COPY pyovpn-2.0-py3.8.egg /usr/local/openvpn_as/lib/python/pyovpn-2.0-py3.8.egg
ENV PATH="/scripts:${PATH}"

EXPOSE 943/tcp 1194/udp 9443/tcp

WORKDIR /app

ENTRYPOINT ["entrypoint.sh"]
