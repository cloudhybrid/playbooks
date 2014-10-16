#!/bin/bash

owner='evgenyg'
image="$1"
tag="$2"
dockerfile="docker/$image/Dockerfile"

if [ "$image" == "" ] || [ "$tag" == "" ]; then
  echo "Arguments: <image> <tag>"
  exit 1
fi

echo '-------------------------------------------------------------------------'
echo "Building and pushing '$owner/$image:$tag' from '$dockerfile'"
echo '-------------------------------------------------------------------------'

set -e
set -x

cp "$dockerfile" .
docker build --rm --no-cache -t="$owner/$image" .
rm  Dockerfile
docker push "$owner/$image"

image_id="$(docker images "$owner/$image" | grep latest | awk '{print $3}')"
docker tag "$image_id" "$owner/$image:$tag"
docker push            "$owner/$image:$tag"

set +e
set +x
