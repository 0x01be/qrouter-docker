FROM 0x01be/base as build

WORKDIR /qrouter

ENV REVISION=master
RUN apk add --no-cache --virtual qrouter-build-dependencies \
    git \
    build-base \
    tk-dev &&\
    git clone --depth 1 --branch ${REVISION} git://opencircuitdesign.com/qrouter /qrouter &&\
    ./configure --prefix=/opt/qrouter/ &&\
    make
RUN make install

FROM 0x01be/base

COPY --from=build /opt/qrouter/ /opt/qrouter/

ENV UID=1000 \
    USER=qrouter \
    WORKSPACE=/workspace
WORKDIR ${WORKSPACE}
RUN apk add --no-cache --virtual qrouter-runtime-dependencies \
    tk &&\
    adduser -D -u ${UID} ${USER} &&\
    chown -R ${USER}:${USER} ${WORKSPACE}

USER ${USER}
ENV PATH=${PATH}:/opt/qrouter/bin/

