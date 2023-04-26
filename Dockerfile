# Use a multi-stage build to optimize the final image size
FROM ubuntu:22.04 AS builder

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git \
        make \
        g++ \
        autoconf \
        automake \
        libtool \
        pkg-config \
        libboost-all-dev \
        libevent-dev \
        ca-certificates \
        bsdmainutils && \
    rm -rf /var/lib/apt/lists/*

# Create user and group
RUN addgroup --gid 1000 fuji && \
    adduser --disabled-password --gecos "" --home /fuji --ingroup fuji --uid 1000 fuji

# Switch to the new user
USER fuji

# Clone the repository and build the project
RUN git clone https://github.com/fujicoin/fujicoin.git /fuji/fujicoin
WORKDIR /fuji/fujicoin
RUN git checkout tags/v24.0

RUN ./autogen.sh
RUN ./configure --without-gui -disable-tests
RUN  make

FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libboost-all-dev \
        libevent-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /fuji/fujicoin/src/fujicoind /usr/local/bin/fujicoind
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh

RUN addgroup --gid 1000 fuji && \
    adduser --disabled-password --gecos "" --home /fuji --ingroup fuji --uid 1000 fuji

USER fuji
RUN mkdir /fuji/.fujicoin
VOLUME /fuji/.fujicoin

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
EXPOSE 38348/tcp
EXPOSE 8048/tcp
