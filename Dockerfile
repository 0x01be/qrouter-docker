FROM alpine:3.12.0 as builder

RUN apk add --no-cache --virtual build-dependencies \
    git \
    build-base \
    tk-dev

RUN git clone git://opencircuitdesign.com/qrouter /qrouter

WORKDIR /qrouter

RUN ./configure --prefix=/opt/qrouter/
RUN make
RUN make install

FROM alpine:3.12.0

COPY --from=builder /opt/qrouter/ /opt/qrouter/

ENV PATH /opt/qrouter/bin/:$PATH

