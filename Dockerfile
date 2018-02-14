FROM docker:18.02.0-ce

RUN apk update && apk add jq

COPY config.json /root/.docker/config.json
COPY run.sh /run.sh

ENTRYPOINT ["/run.sh"]
