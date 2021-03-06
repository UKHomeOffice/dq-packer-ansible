FROM hashicorp/packer:1.3.1

RUN apk add --no-cache --virtual .run-deps \
       python2 \
       openssh \
    && apk add --no-cache --virtual .build-deps \
        alpine-sdk \
        py-setuptools \
        libffi-dev \
        python2-dev \
        openssl-dev \
    && easy_install-2.7 pip \
    && pip install 'ansible==2.4.6.0' \
    && apk --purge del .build-deps \
    && rm -rf /var/cache/apk /root/.cache \
    && adduser -D packer

USER packer
ENV USER=packer
ENV HOME=/home/packer
WORKDIR /home/packer
