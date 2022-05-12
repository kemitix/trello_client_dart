#!/usr/bin/env bash

set -ex

cd $(dirname "$0")/..

rm -r coverage/iconv.info coverage/report coverage/test 2>/dev/null && true

# Coverage 1.2.0 - pinned due to possible bug in 1.3.0
dart run test --coverage=./coverage
dart pub global activate coverage 1.2.0
dart pub global run coverage:format_coverage 1.2.0 --packages=.packages --report-on=lib --lcov -o ./coverage/lcov.info -i ./coverage

# Coverage 1.3.0 - doesn't complete - bug?
#dart pub global run coverage:test_with_coverage

genhtml -o ./coverage/report ./coverage/lcov.info
