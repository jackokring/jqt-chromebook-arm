#!/bin/bash
# change for origin of git submodule repo in response to fork
# ./gitfork.sh <submodule-dir> <git-url>
pushd $1
git remote rename origin upstream
git fetch --set-upstream upstream
git remote set-url --add --push origin $2
git push --set-upstream origin --all
git push --set-upstream origin --tags
popd
