#!/bin/bash
source ./git_revision.sh

docker push docker.ub.gu.se/databaser-elasticsearch:${GIT_REVISION} && \
docker push docker.ub.gu.se/databaser-backend-admin:${GIT_REVISION} && \
docker push docker.ub.gu.se/databaser-backend:${GIT_REVISION} && \
docker push docker.ub.gu.se/databaser-frontend-admin:${GIT_REVISION} && \
docker push docker.ub.gu.se/databaser-frontend-nuxt-3:${GIT_REVISION}
