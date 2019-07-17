FROM alpine:3.10

ARG VERSION

COPY start /

RUN apk add --no-cache --update samba=${VERSION} && \
    chmod 755 /start && \
    addgroup -g 2000 samba && \
    adduser -S -h /config -s /bin/false -u 2000 -G samba samba

EXPOSE 137/udp 138/udp 139 445

CMD ["/start"]

VOLUME ["/var/lib/samba", "/run/samba", "/var/cache"]

HEALTHCHECK --interval=200s --timeout=15s \
            CMD smbclient -L '\\\\localhost\\' -U 'guest%' -m SMB3

LABEL org.label-schema.name="Samba" \
      org.label-schema.version=${VERSION} \
      org.label-schema.docker.schema-version="1.0"
