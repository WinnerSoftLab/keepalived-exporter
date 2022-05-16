ARG GOVERSION=1.18.1-202204291412

FROM nexus.adsrv.wtf/click/golang:${GOVERSION} as builder

WORKDIR /build
COPY --chown=1000:1000 . .
RUN make build


FROM ubuntu:focal-20220426

RUN apt-get update && apt-get install -y --no-install-recommends \
	keepalived && \
	apt-get clean && rm -fr /var/cache/apt/ && rm /usr/sbin/keepalived
COPY --from=builder /build/keepalived-exporter .
EXPOSE 9165
ENTRYPOINT [ "./keepalived-exporter" ]
