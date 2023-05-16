FROM elixir:1.13

ENV MIX_ENV=prod
ENV DATABASE_URL=ecto://postgres:postgres@db/databases
ENV SECRET_KEY_BASE=verysecretkeybasetobehiddenverysecretkeybasetobehiddenverysecretkeybasetobehiddenverysecretkeybasetobehiddenverysecretkeybasetobehiddenverysecretkeybasetobehidden
ENV TZ=Europe/Stockholm



RUN apt-get update && \
    apt-get install -y postgresql-client && \
    apt-get install -y inotify-tools && \
    #apt-get install -y nodejs && \
    #curl -L https://npmjs.org/install.sh | sh && \
    mix local.hex --force && \
    mix archive.install hex phx_new 1.5.10 --force && \
    mix local.rebar --force
#RUN npm -g install webpack-cli webpack

ARG GIT_REVISION
ARG GIT_REPO_URL

RUN set -ex \
  && git clone $GIT_REPO_URL release -b $GIT_REVISION --depth 1

ENV APP_HOME /release/backend-admin/

#RUN mkdir $APP_HOME
#COPY repo/mix.exs repo/mix.lock repo/README.md $APP_HOME/
#COPY repo/assets $APP_HOME/assets
#COPY repo/config $APP_HOME/config
#COPY repo/lib $APP_HOME/lib
#COPY repo/priv $APP_HOME/priv
WORKDIR $APP_HOME
#RUN (cd assets && npm install --save glob)
RUN mix deps.get && mix deps.compile && mix compile && mix phx.digest

COPY wait-for-it.sh /usr/local/bin/wait-for-it.sh
CMD ["/usr/local/bin/wait-for-it.sh", "db:5432", "elasticsearch:9200", "-t", "0", "--", "mix", "phx.server"]