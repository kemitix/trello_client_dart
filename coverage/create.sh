#!/usr/bin/env bash

set -e

cd $(dirname "$0")/..

dart run test --coverage=./coverage
dart pub global activate coverage
dart pub global run coverage:format_coverage --packages=.packages --report-on=lib --lcov -o ./coverage/lcov.info -i ./coverage
genhtml -o ./coverage/report ./coverage/lcov.info
