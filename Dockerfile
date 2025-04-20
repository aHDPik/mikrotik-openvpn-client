FROM alpine:3.16

RUN apk add --no-cache \
        bash \
        bind-tools \
        iptables

COPY data/ /data/

RUN /data/scripts/openssh.sh

ENV VPN_LOG_LEVEL=3
ENV IPTABLES_RULES=iptables_rules

WORKDIR /data

ENTRYPOINT [ "scripts/entry.sh" ]
