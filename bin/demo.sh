#!/usr/bin/env bash

set -e

cd "$(dirname $(dirname $0))"

TRELLO="dart run ./bin/trello.dart"

MEMBER="kemitix"
BOARD="5eccb96b04b4dc5666c64b7c"
LIST="5de68ade15e1dc10b583219e"
CARD="5dc1b58de65da8806ebabba8"
ATTACHMENT="5dc1b58ee65da8806ebabbc7"
FILE_NAME="larkspur.rtf"

echo "member get:"
$TRELLO member get $MEMBER
echo "member list-boards:"
$TRELLO member list-boards $MEMBER
echo "board list-lists:"
$TRELLO board list-lists $BOARD
echo "list list-cards:"
$TRELLO list list-cards $LIST
echo "card get"
$TRELLO card get $CARD
echo "card list-attachments:"
$TRELLO card list-attachments $CARD
echo "card get-attachment"
$TRELLO card get-attachment $CARD $ATTACHMENT
echo "card download-attachment:"
$TRELLO card download-attachment $CARD $ATTACHMENT $FILE_NAME
ls -l $FILE_NAME
rm $FILE_NAME
