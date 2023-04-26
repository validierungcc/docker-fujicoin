FROM alpine:3.17.3
RUN apk add --no-cache autoconf automake git pkgconf libtool make g++ boost-dev bash libevent-dev

RUN addgroup --gid 1000 fuji
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home /fuji \
    --ingroup fuji \
    --uid 1000 \
    fuji

USER fuji
RUN mkdir /fuji/.fujicoin
VOLUME /fuji/.fujicoin

RUN git clone https://github.com/fujicoin/fujicoin.git /fuji/fujicoin
WORKDIR /fuji/fujicoin
RUN git checkout tags/v24.0

RUN ./autogen.sh
RUN ./configure --without-gui
RUN make

COPY ./entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
EXPOSE 38348/tcp
EXPOSE 8048/tcp
