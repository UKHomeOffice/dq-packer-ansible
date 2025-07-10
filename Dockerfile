FROM hashicorp/packer:light

# Install system dependencies
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
       aws-cli 

# Clean up APK cache
RUN rm -rf /var/cache/apk /root/.cache

# Create a Python virtual environment and install packages inside it
RUN python3 -m venv /opt/venv \
    && /opt/venv/bin/pip install --upgrade pip \
    && /opt/venv/bin/pip install "pywinrm>=0.3.0" "cryptography>=41.0.2" "ansible"

# Set environment variables so venv is always active
ENV VIRTUAL_ENV=/opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Add packer user
RUN adduser -D packer

# Copy Packer config and initialize
COPY conf.pkr.hcl /home/packer/.packer.d/conf.pkr.hcl
RUN packer init /home/packer/.packer.d/conf.pkr.hcl

# Allow packer user to install plugins
RUN chown -R packer:packer /home/packer

USER packer
ENV USER=packer
ENV HOME=/home/packer
WORKDIR /home/packer

# Install amazon-ebs plugins

RUN packer plugins install github.com/hashicorp/amazon
RUN packer plugins install github.com/hashicorp/ansible