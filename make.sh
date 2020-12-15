#!/bin/bash

set -e

REPONAME="aronpc/php-alpine"
LATEST_VERSION="7.4"
# Tag and push image for each additional tag
# 
for TAG in {7.1,7.2,7.3,7.4}; do
	FROM_PHP_IMAGE="${TAG}-fpm-alpine"
	FPM_IMAGE_NAME="${REPONAME}:${TAG}-fpm"
	if docker build --file fpm/Dockerfile . --tag ${FPM_IMAGE_NAME} --build-arg PHP_IMAGE=${FROM_PHP_IMAGE} --build-arg PHP_VERSION_BASE=${TAG} ; then
    	docker push ${FPM_IMAGE_NAME}
    	if [[ "$TAG" == "$LATEST_VERSION" ]] ; then
    		docker tag `docker image ls $FPM_IMAGE_NAME | awk -F ' ' 'NR==2 {print $3}'` "${REPONAME}:latest-fpm"
    		docker push "${REPONAME}:latest-fpm"
    	fi
	fi

	FROM_FPM_IMAGE="${REPONAME}:${TAG}-fpm"
	NGINX_IMAGE_NAME="${REPONAME}:${TAG}-nginx"
	if docker build --file nginx/Dockerfile . --no-cache --tag ${NGINX_IMAGE_NAME} --build-arg FROM_FPM_IMAGE=${FROM_FPM_IMAGE}; then
    	docker push ${NGINX_IMAGE_NAME}
    	if [[ "$TAG" == "$LATEST_VERSION" ]] ; then
    		docker tag `docker image ls $NGINX_IMAGE_NAME | awk -F ' ' 'NR==2 {print $3}'` "${REPONAME}:latest-nginx"
    		docker push "${REPONAME}:latest-nginx"
    	fi

	fi
done