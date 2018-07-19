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
        man
RUN apk add --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ tor

# Add tor configuration
ADD etc/torrc /etc/tor/