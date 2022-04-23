#!/usr/bin/env bash

set -e

cd "$(dirname $(dirname $0))"

TRELLO="dart run ./bin/trello.dart"

function trello() {
  label "trello $*"
  $TRELLO $*
}

MEMBER="kemitix"
BOARD="5eccb96b04b4dc5666c64b7c"
LIST="5de68ade15e1dc10b583219e"
CARD="5dc1b58de65da8806ebabba8"
ATTACHMENT="5dc1b58ee65da8806ebabbc7"
FILE_NAME="larkspur.rtf"

function label() {
  echo -e "\n> $1\n"
}

trello member get $MEMBER

trello member list-boards $MEMBER

trello board list-lists $BOARD

trello list list-cards $LIST

trello card get $CARD

trello card list-attachments $CARD

trello card get-attachment $CARD $ATTACHMENT

trello card download-attachment $CARD $ATTACHMENT $FILE_NAME
ls -l $FILE_NAME
rm $FILE_NAME
