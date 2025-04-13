FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Встановлюємо залежності
RUN apt-get update && apt-get install -y \
    git cmake build-essential libconfig-dev libwebsockets-dev \
    libssl-dev libsrtp2-dev libnice-dev libjansson-dev libglib2.0-dev \
    zlib1g-dev pkg-config libtool automake gengetopt doxygen graphviz curl \
    libusrsctp-dev nano && \
    rm -rf /var/lib/apt/lists/*

# Клонуємо Janus та збираємо
RUN git clone https://github.com/meetecho/janus-gateway.git /janus && \
    cd /janus && \
    sh autogen.sh && \
    ./configure --prefix=/opt/janus && \
    make && make install && make configs

COPY ./config/ /opt/janus/etc/janus/

# Переходимо в директорію з janus-бінарником
WORKDIR /opt/janus

# Exposes the WebSocket API port for Janus (ws:// or wss://)
EXPOSE 8188

# Exposes the media traffic port (RTP/RTCP) used by Janus
EXPOSE 10000/udp

# Запускаємо Janus
CMD ["./bin/janus"]