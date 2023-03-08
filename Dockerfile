FROM hashicorp/packer:light

RUN apk add --no-cache --virtual .run-deps \
       python3 \
       openssh \
       ansible-core \
       ansible \
#    && apk add --no-cache --virtual .build-deps \
#        alpine-sdk \
#        py-setuptools \
#        libffi-dev \
#        python3-dev \
#        openssl-dev \
#    && easy_install-2.7 pip \
#    && apk add ansible \
#    && apk --purge del .build-deps \
    && rm -rf /var/cache/apk /root/.cache \
    && adduser -D packer

USER packer
ENV USER=packer
ENV HOME=/home/packer
WORKDIR /home/packer
