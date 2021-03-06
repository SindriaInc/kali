#!/usr/bin/env bash

# Override cron.d configuration
if [ -e /home/hackerino/config/cron.d/app ]; then
    cp /home/hackerino/config/cron.d/app /etc/cron.d/
fi

# Fix permission
chown root:root /etc/cron.d/*
chmod 644 /etc/cron.d/*
chown -R hackerino:hackerino /var/www/app

# Override timezone by env
if [ "$TZ" != "" ] || [ "$TZ" != "Europe/Rome" ]; then
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
fi

# Override host user uid by env
if [ "$HOST_USER_UID" != "1000" ]; then
    usermod -u $HOST_USER_UID hackerino && groupmod hackerino -g $HOST_USER_UID
fi

# Override default sindria user password by env
if [ "$DEFAULT_SINDRIA_USER_PASSWORD" != "hackerino" ]; then
    echo "${DEFAULT_SINDRIA_USER_PASSWORD}:hackerino" | chpasswd
fi

/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
