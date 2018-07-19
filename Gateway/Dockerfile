FROM alpine:latest

# Labels
LABEL maintainer="Ogromny <ogromnycoding@gmail.com>"

# Update and upgrade the system
RUN apk update && apk upgrade

# Install necessaries packages
RUN apk add \
        sudo \
        fish \
        vim \
        bash \
        man \
        supervisor
RUN apk add --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ tor

# Add tor configuration
ADD etc/torrc.default /etc/tor/

# Add supervisord configuration file
ADD etc/supervisord.conf /etc/supervisor/conf.d/

# Run supervisord
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]