#!/bin/bash

set -e

if [ "$TRAVIS_REPO_SLUG" == "gal-orlanczyk/GoSwiftyM3U8" ] && [ "$TRAVIS_PULL_REQUEST" == "false" ] && [ "$TRAVIS_BRANCH" == "initial-ci" ]; then
    cd ..
    jazzy
fi
