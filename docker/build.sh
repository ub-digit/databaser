#!/bin/bash

if test "x$1" = "x"
then
  echo "Usage: $0 image-version [frontend|backend]"
  exit 0
fi

if test -f "$PWD/.docker-root-dir"
then
  ROOTDIR="$PWD/.."
elif test -f "$PWD/docker/.docker-root-dir"
then
  ROOTDIR="$PWD"
else
  echo "Root dir not found..."
  exit 1
fi

BUILD_FE=yes
BUILD_BE=yes

if test "x$2" = "xfrontend"
then
  BUILD_FE=yes
  BUILD_BE=no
fi

if test "x$2" = "xbackend"
then
  BUILD_FE=no
  BUILD_BE=yes
fi

FRONTEND="$ROOTDIR/frontend"
BACKEND="$ROOTDIR/backend"
DOCKERDIR="$ROOTDIR/docker"
FE_DOCKER="$DOCKERDIR/frontend"
BE_DOCKER="$DOCKERDIR/backend"
DB_DOCKER="$DOCKERDIR/db"
FE_REPO="$FE_DOCKER/repo"
BE_REPO="$BE_DOCKER/repo"
IMAGE_VERSION="$1"
IMAGE_BASE_NAME="docker.ub.gu.se/minalan"
FE_IMAGE_NAME="${IMAGE_BASE_NAME}-frontend:$IMAGE_VERSION"
BE_IMAGE_NAME="${IMAGE_BASE_NAME}-backend:$IMAGE_VERSION"
SQL_SRC_DIR="$BACKEND/data"
LOCALE_SRC_DIR="$BACKEND/data"
SQL_INIT_DIR="$DB_DOCKER/initialize"
LOCALE_DST_DIR="$DOCKERDIR/data"

# Build frontend
if test "x$BUILD_FE" = "xyes"
then
  cd "$FE_DOCKER"
  rm -Rf "$FE_DOCKER/repo"
  mkdir -p "$FE_REPO"
  cp -a "$FRONTEND/." "$FE_REPO/."
  docker build -t "$FE_IMAGE_NAME" .
fi

# Build backend
if test "x$BUILD_BE" = "xyes"
then
  cd "$BE_DOCKER"
  rm -Rf "$BE_DOCKER/repo"
  mkdir -p "$BE_REPO"
  cp -a "$BACKEND/." "$BE_REPO/."
  docker build -t "$BE_IMAGE_NAME" .
fi

# Copy SQL file
mkdir -p "$SQL_INIT_DIR"
cp "$SQL_SRC_DIR/schema.sql" "$SQL_INIT_DIR/1-schema.sql"

# Copy locale
mkdir -p "$LOCALE_DST_DIR"
cp "$LOCALE_SRC_DIR"/locale_*.json "$LOCALE_DST_DIR/"
