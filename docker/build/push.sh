#!/bin/bash
source .env

# Overwrite GIT_REVISION with first argument if passed
if [ -n "$1" ]; then
  GIT_REVISION=$1
fi

docker push docker.ub.gu.se/databaser-elasticsearch:${GIT_REVISION} && \
docker push docker.ub.gu.se/databaser-backend-admin:${GIT_REVISION} && \
docker push docker.ub.gu.se/databaser-backend:${GIT_REVISION} && \
docker push docker.ub.gu.se/databaser-frontend-admin:${GIT_REVISION}
docker push docker.ub.gu.se/databaser-frontend-nuxt-3:${GIT_REVISION}