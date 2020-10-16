FROM alpine as builder

RUN apk add --no-cache --virtual qrouter-build-dependencies \
    git \
    build-base \
    tk-dev

ENV QROUTER_REVISION master
RUN git clone --depth 1 --branch ${QROUTER_REVISION} git://opencircuitdesign.com/qrouter /qrouter

WORKDIR /qrouter

RUN ./configure --prefix=/opt/qrouter/
RUN make
RUN make install

FROM alpine

COPY --from=builder /opt/qrouter/ /opt/qrouter/

RUN apk add --no-cache --virtual qrouter-runtime-dependencies \
    tk

RUN adduser -D -u 1000 qrouter

WORKDIR /workspace

RUN chown qrouter:qrouter /workspace

USER qrouter

ENV PATH /opt/qrouter/bin/:$PATH

