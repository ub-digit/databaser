#!/bin/bash
source ./git_revision.sh
git tag $GIT_REVISION
git push origin $GIT_REVISION
