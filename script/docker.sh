#!/bin/bash
#
# 1. CircleCI with `Btrfs volume error`
#   https://circleci.com/docs/docker-btrfs-error/
#
set -e

imageName='wechaty:test'

optRm='--rm'
[ -n "$CIRCLECI" ] && optRm='--rm=false'

declare -i ret=0

case "$1" in
  build | '')
    echo docker build "$optRm" -t "$imageName" .
    exec docker build "$optRm" -t "$imageName" .
    ret=$?
    ;;

  test)
    echo "bats test/"
    IMAGE_NAME="$imageName" bats test/

    echo docker run -ti "$optRm" -v /dev/shm:/dev/shm "$imageName" test
    exec docker run -ti "$optRm" -v /dev/shm:/dev/shm "$imageName" test
    ret=$?
    ;;

  *)
    echo docker run -ti "$optRm" -v /dev/shm:/dev/shm "$imageName" "$@"
    exec docker run -ti "$optRm" -v /dev/shm:/dev/shm "$imageName" "$@"
    ret=$?
    ;;
esac

echo "ERROR: exec return $ret ???"
exit $ret
