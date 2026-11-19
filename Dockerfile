FROM ubuntu:26.04@sha256:d66b366dac61b575bee2aef07e9c26e8070096fbe84a3d4d3eb0da069b5d76db

LABEL org.opencontainers.image.title="ansible" \
      org.opencontainers.image.description="Ansible, ansible-lint and common connection plugins in a non-root image" \
      org.opencontainers.image.vendor="Think-Cube" \
      org.opencontainers.image.authors="contact@thinkcube.dev" \
      org.opencontainers.image.licenses="MIT"

ENV LANG=C.UTF-8 \
    PATH="/opt/ansible-env/bin:$PATH"

# The upgrade is what lets the weekly rebuild pick up security patches
# while the base image stays pinned by digest.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        ca-certificates \
        git \
        gnupg2 \
        openssh-client \
        python3-venv \
        sshpass && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt /tmp/requirements.txt

RUN python3 -m venv /opt/ansible-env && \
    /opt/ansible-env/bin/pip install --no-cache-dir --only-binary=:all: --require-hashes \
        -r /tmp/requirements.txt && \
    rm /tmp/requirements.txt

RUN groupadd --gid 10001 ansible && \
    useradd --uid 10001 --gid 10001 --create-home --shell /bin/bash ansible && \
    install -d -o ansible -g ansible /ansible && \
    mkdir -p /etc/ansible && \
    echo 'localhost' > /etc/ansible/hosts

WORKDIR /ansible

USER 10001:10001

CMD ["ansible-playbook", "--version"]
