FROM hashicorp/packer:light

# libcurl because there is a critical vulnerability in the version of Alpine inherited from packer image
RUN apk update \
    && apk add --no-cache --virtual .run-deps \
       python3 \
       openssh \
       ansible-core \
       ansible \
    && apk upgrade libcurl=7.88.1-r1 \
    && rm -rf /var/cache/apk /root/.cache \
    && adduser -D packer


USER packer
ENV USER=packer
ENV HOME=/home/packer
WORKDIR /home/packer
