FROM alpine:3.11.5

LABEL maintainer="mei-admin@heig-vd.ch"

RUN apk add --no-cache bash openssh-keygen && \
    mkdir /target

COPY entrypoint.sh /usr/local/bin/

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]