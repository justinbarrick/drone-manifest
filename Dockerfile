FROM docker:18.02.0-ce-dind

RUN apk update && apk add jq

COPY config.json /root/.docker/config.json
COPY run.sh /run.sh

CMD ["/run.sh"]
