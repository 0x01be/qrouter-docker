FROM 0x01be/base as build


ENV REVISION=master
RUN apk add --no-cache --virtual qrouter-build-dependencies \
    git \
    build-base \
    tcl-dev \
    tk-dev \
    libxt-dev &&\
    git clone --depth 1 --branch master https://github.com/tcltk/tcllib.git /tmp/tcllib && cd /tmp/tcllib && ./configure --prefix=/usr && make install && rm -rf /tmp/*

WORKDIR /qrouter
RUN git clone --depth 1 --branch ${REVISION} git://opencircuitdesign.com/qrouter /qrouter &&\
    sed -i.bak '31 a typedef int (*__compar_fn_t) (const void*, const void*);' mask.c &&\
    sed -i.bak '36 a typedef int (*__compar_fn_t) (const void*, const void*);' lef.c &&\
    sed -i.bak '31 a typedef int (*__compar_fn_t) (const void*, const void*);' tclqrouter.c &&\
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
    tcl \
    tk \
    libxt &&\
    adduser -D -u ${UID} ${USER} &&\
    chown -R ${USER}:${USER} ${WORKSPACE}

USER ${USER}
ENV PATH=${PATH}:/opt/qrouter/bin/

