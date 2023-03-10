FROM hashicorp/packer:light

RUN apk upgrade \
    && apk add --no-cache --virtual .run-deps \
       python3 \
       openssh \
       ansible-core \
       ansible \
       libcurl \
    && rm -rf /var/cache/apk /root/.cache \
    && adduser -D packer


USER packer
ENV USER=packer
ENV HOME=/home/packer
WORKDIR /home/packer
