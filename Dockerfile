FROM alpine:latest

MAINTAINER Ogromny <ogromnycoding@gmail.com>

RUN apk update
RUN apk upgrade
RUN apk add tor --update-cache


