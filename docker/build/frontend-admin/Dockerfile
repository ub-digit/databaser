# build environment
FROM node:16-bullseye AS build

ARG GIT_REVISION
ARG GIT_REPO_URL

WORKDIR /build/

RUN set -ex \
  && git clone $GIT_REPO_URL release -b $GIT_REVISION --depth 1


WORKDIR /build/release/frontend-admin/

RUN set -ex \ 
 && npm install \
 && npm run build

# production environment
FROM httpd:2.4-bullseye
ENV TZ=Europe/Stockholm
RUN sed -i 's/#\(LoadModule cgid_module modules\/mod_cgid.so\)/\1/' /usr/local/apache2/conf/httpd.conf
RUN echo 'FallbackResource /' >> /usr/local/apache2/conf/httpd.conf
RUN echo 'PassEnv DATABASER_BACKEND_ADMIN_URL' >> /usr/local/apache2/conf/httpd.conf
#RUN echo 'PassEnv DB_LIST_ALERT_URL' >> /usr/local/apache2/conf/httpd.conf
COPY backend.cgi /usr/local/apache2/cgi-bin/backend.cgi
COPY --from=build /build/release/frontend-admin/dist/. /usr/local/apache2/htdocs/