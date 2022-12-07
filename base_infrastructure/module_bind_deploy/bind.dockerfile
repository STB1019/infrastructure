FROM internetsystemsconsortium/bind9:9.18

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get install -y dnsutils