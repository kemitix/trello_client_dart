#!/usr/bin/env bash

set -e

cd $(dirname "$0")/report

python3 -m http.server 8000
