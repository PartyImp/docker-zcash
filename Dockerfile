FROM debian:jessie
MAINTAINER kost - https://github.com/kost

ADD ./entrypoint.sh /entrypoint.sh

ENV	ZCASH_URL=https://github.com/zcash/zcash.git \
	ZCASH_VERSION=v1.0.8 \
	ZCASH_CONF=/home/zcash/.zcash/zcash.conf

RUN apt-get autoclean && apt-get autoremove && apt-get update && \
    build_deps='\
        apt-utils \
        autoconf \
        automake \
        bsdmainutils \
        build-essential \
        ca-certificates \
        git \
        g++-multilib \
        libc6-dev \
        libcurl3-dev \
        libcurl4-openssl-dev \
        libgtest-dev \
        libssl-dev \
        libtool \
        libudev-dev \
        m4 \
        make \
        ncurses-dev \
        pkg-config \
        python \
        unzip \
        wget \
        zlib1g-dev \
    ' && \
    apt-get -qqy install --no-install-recommends \
        $build_deps pwgen tor && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /src/zcash/; cd /src/zcash; \
    git clone ${ZCASH_URL} zcash && cd zcash && git checkout ${ZCASH_VERSION} && \
    ./zcutil/fetch-params.sh && ./zcutil/build.sh -j$(nproc) && cd /src/zcash/zcash/src && \
    /usr/bin/install -c zcash-tx zcashd zcash-cli zcash-gtest -t /usr/local/bin/ && \
    rm -rf /src/zcash/ && \
    adduser --uid 1000 --system zcash && \
    mv /root/.zcash-params /home/zcash/ && \ 
    mkdir -p /home/zcash/.zcash/ && \
    chown -R zcash /home/zcash && \
    apt-get purge -y $build_deps && \
    echo "Success"

USER zcash
RUN echo "rpcuser=zcash" > ${ZCASH_CONF} && \
	echo "rpcpassword=`pwgen 20 1`" >> ${ZCASH_CONF} && \
	echo "Success"

VOLUME ["/home/zcash/.zcash"]

ENTRYPOINT /entrypoint.sh
