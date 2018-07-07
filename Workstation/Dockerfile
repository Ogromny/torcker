FROM alpine:latest

# Args
ARG PASS=alpine
ARG VNC_PASS=alpine

# Labels
LABEL maintainer="Ogromny <ogromnycoding@gmail.com>"

# Update and upgrade the system
RUN apk update && apk upgrade

# Install necessaries packages
RUN apk add \
        sudo \
        xvfb \
        x11vnc \
        hicolor-icon-theme \
        supervisor \
        dbus \
        xfconf \
        xfce4 \
        fish \
        vim \
        librsvg \
        bash \
        alpine-sdk \
        man \
        git
RUN apk add --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ firefox

# Add group
RUN addgroup alpine

# Add user
RUN adduser -G alpine -h /home/alpine -s /usr/bin/fish -S alpine

# Set user password
RUN echo -e "${PASS}\n${PASS}" | passwd alpine

# Add user in the sudoers file
RUN echo "alpine ALL=(ALL) ALL" >> /etc/sudoers

# Generate the DBUS UUID
RUN dbus-uuidgen > /etc/machine-id

# Copy start.sh
ADD etc/supervisord.conf /etc/supervisor/conf.d/

# Firefox user.js
RUN git clone https://github.com/pyllyukko/user.js.git && cd user.js && make systemwide_user.js
RUN mv user.js/systemwide_user.js /usr/lib/firefox/mozilla.cfg
RUN rm -r user.js
RUN echo -e "pref(\"general.config.obscure_value\", 0);\npref(\"general.config.filename\", \"mozilla.cfg\");" > /usr/lib/firefox/defaults/pref/local-settings.js

ADD configure_firefox.sh /home/alpine
RUN chmod +x /home/alpine/configure_firefox.sh && /home/alpine/configure_firefox.sh

# alpine configuration
USER alpine
WORKDIR /home/alpine

# Set the VNC password
RUN x11vnc -storepasswd ${VNC_PASS} /home/alpine/.vnc_passwd

# CUSTOMIZATION
ADD custom.zip /home/alpine
RUN unzip custom.zip && rm custom.zip

# Run supervisord
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]