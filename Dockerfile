FROM alpine:3.12.0 as builder

RUN apk add --no-cache --virtual build-dependencies \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    git \
    build-base \
    tk-dev

RUN git clone git://opencircuitdesign.com/qrouter /qrouter

WORKDIR /qrouter

RUN ./configure --prefix=/opt/qrouter/
# FIXME
#RUN make
#RUN make install

#FROM alpine:3.12.0

#COPY --from=builder /opt/qrouter/ /opt/qrouter/

#ENV PATH /opt/qrouter/bin/:$PATH

