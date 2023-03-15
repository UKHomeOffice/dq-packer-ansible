FROM hashicorp/packer:light

RUN apk upgrade \
    && apk add --no-cache --virtual .run-deps \
       python3 \
       openssh \
       ansible-core \
       ansible \
       libcurl \
    && rm -rf /var/cache/apk /root/.cache

RUN pip install "pywinrm>=0.3.0"

RUN adduser -D packer

COPY conf.pkr.hcl /home/packer/.packer.d/conf.pkr.hcl
RUN packer init /home/packer/.packer.d/conf.pkr.hcl

USER packer
ENV USER=packer
ENV HOME=/home/packer
WORKDIR /home/packer
