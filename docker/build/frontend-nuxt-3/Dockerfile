# build environment
FROM node:20-bullseye AS build

ARG GIT_REVISION
ARG GIT_REPO_URL

WORKDIR /app/

RUN set -ex \
  && git clone $GIT_REPO_URL release -b $GIT_REVISION --depth 1

WORKDIR /app/release/frontend-nuxt-3/

RUN set -ex \ 
 && yarn install && yarn run build

# production environment
FROM node:20-bullseye
ENV TZ=Europe/Stockholm
WORKDIR /app/
COPY --from=build /app/release/frontend-nuxt-3/ ./
ENV NUXT_HOST=0.0.0.0
# set app port
ENV NUXT_PORT=5000
# expose 5000 on container
EXPOSE 5000

# start the app
CMD ["node", ".output/server/index.mjs"]


