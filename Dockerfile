FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive
RUN echo 'exec zsh' > /root/.bashrc
RUN apt-get update && apt-get install -y --no-install-recommends curl dnsutils ipcalc iproute2 iputils-ping jq mtr-tiny nano netcat tcpdump termshark vim-nox zsh && apt-get install iptables sudo -y
RUN curl -L https://grml.org/zsh/zshrc > /root/.zshrc

# bird router
RUN mkdir -p /usr/share/doc/bird2/examples/
RUN touch /usr/share/doc/bird2/examples/bird.conf
RUN apt-get update && apt-get install -y --no-install-recommends bird2
# rpki host
RUN apt-get update && apt-get upgrade -y
RUN apt install rsync grsync -y
RUN apt install build-essential -y
RUN apt-get install manpages-dev
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
RUN . $HOME/.cargo/env
ENV PATH="/root/.cargo/bin:${PATH}"
RUN cargo install --version 0.11.3 -f routinator
RUN routinator init --accept-arin-rpa
RUN rm /root/.rpki-cache/tals/ripe.tal
RUN rm /root/.rpki-cache/tals/lacnic.tal
RUN rm /root/.rpki-cache/tals/arin.tal
RUN rm /root/.rpki-cache/tals/afrinic.tal
RUN routinator -v vrps -o ROAs.csv
RUN apt install traceroute -y