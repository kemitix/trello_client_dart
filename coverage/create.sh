#!/usr/bin/env bash

set -ex

cd $(dirname "$0")/..

rm -r coverage/iconv.info coverage/report coverage/test 2>/dev/null && true

dart pub global activate coverage
dart pub global run coverage:test_with_coverage

genhtml -o ./coverage/report ./coverage/lcov.info
