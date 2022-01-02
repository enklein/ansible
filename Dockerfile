FROM ubuntu:focal AS base
WORKDIR /usr/local/bin
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common curl git build-essential && \
    apt-add-repository -y ppa:ansible/ansible && \
    apt-get update && \
    apt-get install -y curl git ansible build-essential sudo && \
    apt-get clean autoclean && \
    apt-get autoremove --yes

FROM base AS new-init
ARG TAGS
RUN addgroup --gid 1000 orphie
RUN echo "orphie ALL=(ALL) ALL" >> /etc/sudoers
RUN adduser --gecos orphie --uid 1000 --gid 1000 --disabled-password orphie
RUN echo "orphie:pizza" | (chpasswd)
USER orphie
WORKDIR /home/orphie

FROM new-init
RUN mkdir /home/orphie/whatever
COPY . /home/orphie/whatever
WORKDIR /home/orphie/whatever
CMD ["sh", "-c", "ansible-playbook $TAGS init.yml"]