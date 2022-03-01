# build environment
FROM node:12.2.0-alpine as build
RUN apk add --no-cache git

ARG GIT_REVISION
ARG GIT_REPO_URL

WORKDIR /app/

RUN set -ex \
  && git clone $GIT_REPO_URL release -b $GIT_REVISION --depth 1

WORKDIR /app/release/frontend

RUN set -ex \
 && npm install \
 && npm run build

# production environment
FROM nginx:1.16.0-alpine
COPY --from=build /app/release/frontend/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]