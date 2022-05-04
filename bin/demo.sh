#!/usr/bin/env bash

set -e

cd "$(dirname $(dirname $0))"

dart compile exe --output ./trello bin/trello.dart
TRELLO="./trello"

function trello() {
  label "trello $*"
  case $# in
  1) $TRELLO "$1"  ;;
  2) $TRELLO "$1" "$2"  ;;
  3) $TRELLO "$1" "$2" "$3"  ;;
  4) $TRELLO "$1" "$2" "$3" "$4"  ;;
  5) $TRELLO "$1" "$2" "$3" "$4" "$5"  ;;
  6) $TRELLO "$1" "$2" "$3" "$4" "$5" "$6" ;;
  7) $TRELLO "$1" "$2" "$3" "$4" "$5" "$6" "$7" ;;
  8) $TRELLO "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" ;;
  9) $TRELLO "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9" ;;
  *) echo "ERROR(demo): unexpected number of parameters: $#" ; exit 1;;
  esac
}

MEMBER="kemitix"
MEMBER_ID="5d999fc87ac5a442f45cb8eb"
BOARD="5eccb96b04b4dc5666c64b7c"
LIST="5de68ade15e1dc10b583219e"
CARD="5dc1b58de65da8806ebabba8"
MUTABLE_CARD="61b32a083270082adf87ffb1"
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
trello card download-attachment $CARD $ATTACHMENT $FILE_NAME ; ls -l $FILE_NAME ; rm $FILE_NAME
trello card get $MUTABLE_CARD
trello card update $MUTABLE_CARD --name "$(date --iso-8601=seconds)" --member-ids ''
trello card get $MUTABLE_CARD
trello card add-member $MUTABLE_CARD $MEMBER_ID
trello card get $MUTABLE_CARD
