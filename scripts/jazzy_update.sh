#!/bin/bash

set -e

if [ "$TRAVIS_REPO_SLUG" == "gal-orlanczyk/go-swifty-m3u8" ] && [ "$TRAVIS_PULL_REQUEST" == "false" ] && [ "$TRAVIS_BRANCH" == "initial-ci" ]; then
    echo "Starting Jazzy for creating technical docs..."
    jazzy
fi
