FROM hashicorp/packer:light


RUN apk update \
    && apk upgrade \
    && apk add --no-cache --virtual .run-deps \
       python3 \
       py3-pip \
       git \
       krb5-dev \
       openssh \
       openssl-dev \
       ansible-core \
       ansible \
       libcurl

RUN apk update \
    && apk upgrade \
    && rm -rf /var/cache/apk /root/.cache

RUN pip install "pywinrm>=0.3.0" "cryptography>=41.0.2"

RUN adduser -D packer
RUN go get google.golang.org/grpc@latest && go get google.golang.org/http2@latest

COPY conf.pkr.hcl /home/packer/.packer.d/conf.pkr.hcl
RUN packer init /home/packer/.packer.d/conf.pkr.hcl

USER packer
ENV USER=packer
ENV HOME=/home/packer
WORKDIR /home/packer
