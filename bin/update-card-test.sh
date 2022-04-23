#!/usr/bin/env bash

set -e

cd "$(dirname $(dirname $0))"

TRELLO="dart run ./bin/trello.dart"

function trello() {
  label "trello $*"
  $TRELLO $*
}

CARD="5da0e355c43743693e1cc3e8"

function label() {
  echo -e "\n> $1\n"
}

#label "original card"
#$TRELLO card get $CARD

FOO=$(date --iso-8601=seconds)

#label "set name to $FOO"
trello card update $CARD --name "$FOO"

#label "updated card"
#$TRELLO card get $CARD
