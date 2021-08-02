FROM kalilinux/kali-rolling:latest

ARG TAG_VERSION
ARG HOST_USER_UID
ARG TIMEZONE

LABEL \
	name="sindriainc/kali" \
	image="kali" \
	tag="${TAG_VERSION}" \
	vendor="sindria"

ENV DEBIAN_FRONTEND="noninteractive"
ENV HOST_USER_UID ${HOST_USER_UID}
ENV TZ=${TIMEZONE}
ENV SINDRIA_USER="hackerino"
ENV SINDRIA_USER_HOME="/home/hackerino"

# Install base software and settings
RUN apt update && \
    echo "deb-src http://http.kali.org/kali kali-rolling main non-free contrib" >> /etc/apt/sources.list && \
    apt update && \
    apt upgrade -y && \
    apt dist-upgrade -y && \
    apt install -y python3-pip && \
    apt install -y vim wget curl git screen sudo

# Install base pentesting tools
RUN apt update && \
    apt install -y kali-linux-default && \
    rm -rf /var/lib/apt/lists/*

# Adding sindria user
RUN useradd ${SINDRIA_USER} -u ${HOST_USER_UID} -d ${SINDRIA_USER_HOME} -s /bin/bash && \
    groupmod ${SINDRIA_USER} -g ${HOST_USER_UID} && \
    mkdir -p ${SINDRIA_USER_HOME}/bin/installers && \
    mkdir -p ${SINDRIA_USER_HOME}/config && \
    mkdir -p /var/www/app && \
    chmod -R 755 /var/www/app && \
    chown -R ${SINDRIA_USER}:${SINDRIA_USER} /var/www/app

WORKDIR /var/www/app

# Install sublister
COPY resources/scripts/sublister.sh /opt/sublister
RUN cd /opt && \
    git clone https://github.com/aboul3la/Sublist3r.git && \
    cd Sublist3r && \
    pip install -r requirements.txt && \
    chmod +x /opt/sublister/sublister.sh && \
    ln -s /opt/sublister/sublister.sh /usr/local/bin/sublister && \
    rm -Rf /opt/Sublist3r/.git

SHELL ["/bin/bash", "-c"]

# Add and setup entrypont
COPY resources/bin/entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]

CMD ["tail", "-f", "/dev/null"]

EXPOSE 80 443 4444