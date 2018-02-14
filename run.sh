#!/bin/sh
sh /usr/local/bin/dind dockerd --host=unix:///var/run/docker.sock --log-level fatal &

env

echo "$DOCKER_PASSWORD" |docker login -u "$DOCKER_USERNAME" --password-stdin

docker manifest create "$PLUGIN_REPO":"$PLUGIN_TAG" $(echo "$PLUGIN_IMAGES" |jq -r 'map(.repo + ":" + .tag)[]')

for image in $(echo "$PLUGIN_IMAGES" |jq -rMc '.[]'); do
  docker manifest annotate "$PLUGIN_REPO":"$PLUGIN_TAG" "$(echo "$image" |jq -r '.repo + ":" + .tag')" $(echo "$image" |jq -r '.annotations |to_entries |map("--" + .key + "=" + .value)[]')
done

docker manifest push "$PLUGIN_REPO":"$PLUGIN_TAG"

kill -TERM $(cat /var/run/docker.pid)
