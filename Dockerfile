FROM alpine as build

RUN apk add --no-cache --virtual qrouter-build-dependencies \
    git \
    build-base \
    tk-dev

ENV REVISION=master
RUN git clone --depth 1 --branch ${REVISION} git://opencircuitdesign.com/qrouter /qrouter

WORKDIR /qrouter

RUN ./configure --prefix=/opt/qrouter/
RUN make
RUN make install

FROM alpine

COPY --from=build /opt/qrouter/ /opt/qrouter/

RUN apk add --no-cache --virtual qrouter-runtime-dependencies \
    tk

ENV UID=1000 \
    USER=qrouter \
    WORKSPACE=/workspace
RUN adduser -D -u ${UID} ${USER} &&\
    mkdir -p ${WORKSPACE} &&\
    chown -R ${USER}:${USER} ${WORKSPACE}

USER ${USER}
WORKDIR ${WORKSPACE}
ENV PATH=${PATH}:/opt/qrouter/bin/

