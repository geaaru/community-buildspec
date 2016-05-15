#!/bin/bash
# written by mudler@sabayon.org

. /vagrant/scripts/functions.sh

update_vagrant_repo

IMAGES=( $(docker images | awk '{ print $1 }' | grep -v "REPOSITORY") )
for i in "${IMAGES[@]}"
do
if [ -n "${i}" ]; then
  docker-companion squash --remove ${i}
fi
done

docker_clean

EMERGE_DEFAULTS_ARGS="--accept-properties=-interactive -t --verbose --update --nospinner --oneshot --complete-graph --buildpkg" /vagrant/scripts/nightly.sh

rm -rfv /tmp/.*
rm -rfv /tmp/*
