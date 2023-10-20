ARG GOVERSION=1.21.1-202309200830

FROM nexus.adsrv.wtf/click/golang:${GOVERSION} as builder

WORKDIR /build
COPY --chown=1000:1000 . .
RUN make build


FROM ubuntu:jammy-20231004

RUN apt-get update && apt-get install -y --no-install-recommends \
	keepalived openssl && \
	apt-get clean && rm -fr /var/cache/apt/ && rm /usr/sbin/keepalived
COPY --from=builder /build/keepalived-exporter .
EXPOSE 9165
ENTRYPOINT [ "./keepalived-exporter" ]
