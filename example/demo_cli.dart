#!/usr/bin/env dcli

import 'dart:io' show Platform;

import 'package:dcli/dcli.dart' show calculateHash, delete, lastModified;
import 'package:trello_client/external/dio_client_factory.dart'
    show dioClientFactory;
import 'package:trello_client/trello_cli.dart' show EnvArgsEnvironment, app;

const String member = "kemitix";
const String memberId = "5d999fc87ac5a442f45cb8eb";
const String boardId = "5eccb96b04b4dc5666c64b7c";
const String listId = "5de68ade15e1dc10b583219e";
const String cardId = "5dc1b58de65da8806ebabba8";
const String mutableCardId = "61b32a083270082adf87ffb1";
const String attachmentId = "5dc1b58ee65da8806ebabbc7";
const String fileName = "larkspur.rtf";

void main() async {
  await trello('member get $member');
  await trello('member list-boards $member');
  await trello('board list-lists $boardId');
  await trello('list list-cards $listId');
  await trello('card get $cardId');
  await trello('card list-attachments $cardId');
  await trello('card get-attachment $cardId $attachmentId');
  await trello('card download-attachment $cardId $attachmentId $fileName');
  print('$fileName - ${lastModified(fileName)} - ${calculateHash(fileName)}');
  delete(fileName);
  await trello('card get $mutableCardId');
  await trello(
      'card update $mutableCardId --name ${DateTime.now().toString().replaceAll(' ', '-')} --member-ids ');
  await trello('card get $mutableCardId');
  await trello('card add-member $mutableCardId $memberId');
  await trello('card get $mutableCardId');
  await trello('card remove-member $mutableCardId $memberId');
  await trello('card get $mutableCardId');
}

Future<void> trello(String command) {
  print('\n> trello $command\n');
  return app().run(
    EnvArgsEnvironment(
        platformEnvironment: Platform.environment,
        arguments: command.split(' '),
        clientFactory: dioClientFactory,
        printer: (s) => print(s)),
  );
}
