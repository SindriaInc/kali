FROM kalilinux/kali-rolling:latest

ARG TAG_VERSION
ARG HOST_USER_UID
ARG TIMEZONE

LABEL \
	name="registry.sindria.org/security/kali" \
	image="kali" \
	tag="${TAG_VERSION}" \
	vendor="sindria"

ENV DEBIAN_FRONTEND="noninteractive"
ENV HOST_USER_UID ${HOST_USER_UID}
ENV TZ=${TIMEZONE}
ENV SINDRIA_USER="hackerino"
ENV SINDRIA_USER_HOME="/home/hackerino"
ENV DEFAULT_SINDRIA_USER_PASSWORD="hackerino"

# Install base software and all pentesting tools
RUN apt update && \
    echo "deb-src http://http.kali.org/kali kali-rolling main non-free contrib" >> /etc/apt/sources.list && \
    apt update && \
    apt install -y vim wget curl git screen openssh-server cron supervisor && \
    apt install -y kali-linux-everything && \
    rm -rf /var/lib/apt/lists/*

# Adding sindria user
RUN useradd ${SINDRIA_USER} -u ${HOST_USER_UID} -d ${SINDRIA_USER_HOME} -s /bin/bash && \
    groupmod ${SINDRIA_USER} -g ${HOST_USER_UID} && \
    mkdir -p ${SINDRIA_USER_HOME}/bin/installers && \
    mkdir -p ${SINDRIA_USER_HOME}/config && \
    mkdir -p /var/www/app

# SSH configuration
COPY resources/ssh/sshd_config /etc/ssh/sshd_config
RUN mkdir -p /run/sshd && \
    ln -s /var/www/app ${SINDRIA_USER_HOME}/app && \
    chmod 751 /home && \
    chmod 751 /var && \
    mkdir -p ${SINDRIA_USER_HOME}/.ssh && \
    touch ${SINDRIA_USER_HOME}/.ssh/authorized_keys && \
    chmod 700 ${SINDRIA_USER_HOME}/.ssh && \
    chmod 600 ${SINDRIA_USER_HOME}/.ssh/* && \
    chown -R ${SINDRIA_USER}:${SINDRIA_USER} ${SINDRIA_USER_HOME} && \
    echo "${DEFAULT_SINDRIA_USER_PASSWORD}:${SINDRIA_USER}" | chpasswd && \
    chown -R ${SINDRIA_USER}:${SINDRIA_USER} /var/www/app

# Supervisor configuration
COPY resources/supervisor/supervisord.conf /etc/supervisor/supervisord.conf
COPY resources/supervisor/conf.d/*.conf /etc/supervisor/conf.d/

WORKDIR /var/www/app

SHELL ["/bin/bash", "-c"]

# Add and execute startup command
COPY startup.sh /startup.sh
CMD ["/bin/bash", "/startup.sh"]

EXPOSE 80 443 22 4444