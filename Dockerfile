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
       libcurl \
       libcrypto3 \
       libssl3 \
       aws-cli \
       sqlite \
       sqlite-dev \
       sqlite-libs \
    # Remove GnuPG
    && apk del gnupg gnupg-dirmngr gnupg-gpgconf gnupg-keyboxd gnupg-utils \
              gnupg-wks-client gpg gpg-agent gpg-wks-server gpgsm gpgv || true \
    && rm -rf /var/cache/apk /root/.cache

# Create Python venv + Ansible (secrets FP ignored via Trivy flags)
RUN python3 -m venv /opt/venv \
    && /opt/venv/bin/pip install --upgrade pip urllib3 \
    && /opt/venv/bin/pip install "pywinrm>=0.3.0" "cryptography>=41.0.2" "ansible"

ENV VIRTUAL_ENV=/opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Packer user + config
RUN adduser -D packer
COPY conf.pkr.hcl /home/packer/.packer.d/conf.pkr.hcl
RUN packer init /home/packer/.packer.d/conf.pkr.hcl
RUN chown -R packer:packer /home/packer

RUN rm -rf /root/.config/packer/plugins /home/packer/.packer.d/plugins || true

USER packer
ENV USER=packer
ENV HOME=/home/packer
WORKDIR /home/packer

RUN packer plugins install github.com/hashicorp/amazon
RUN packer plugins install github.com/hashicorp/ansible