#! /bin/bash

id -nu ${uid} || useradd binduser -u ${uid}
USER=$(id -nu ${uid})

ls -alh /etc/bind/
whoami
/usr/sbin/named -g -c /etc/bind/named.conf -u $USER