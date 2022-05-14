@echo off

dart compile exe --output ./trello.exe bin/trello.dart

set MEMBER="kemitix"
set MEMBER_ID="5d999fc87ac5a442f45cb8eb"
set BOARD="5eccb96b04b4dc5666c64b7c"
set LIST="5de68ade15e1dc10b583219e"
set CARD="5dc1b58de65da8806ebabba8"
set MUTABLE_CARD="61b32a083270082adf87ffb1"
set ATTACHMENT="5dc1b58ee65da8806ebabbc7"
set FILE_NAME="larkspur.rtf"

trello.exe member get %MEMBER%
trello member list-boards %MEMBER%
trello board list-lists %BOARD%
trello list list-cards %LIST%
trello card get %CARD%
trello card list-attachments %CARD%
trello card get-attachment %CARD% %ATTACHMENT%
trello card download-attachment %CARD% %ATTACHMENT% %FILE_NAME%
dir %FILE_NAME%
del %FILE_NAME%
trello card get %MUTABLE_CARD%
rem trello card update %MUTABLE_CARD% --name "$(date --iso-8601=seconds)" --member-ids ''
rem trello card get $MUTABLE_CARD
trello card add-member %MUTABLE_CARD% %MEMBER_ID%
trello card get %MUTABLE_CARD%
trello card remove-member %MUTABLE_CARD% %MEMBER_ID%
trello card get %MUTABLE_CARD%
