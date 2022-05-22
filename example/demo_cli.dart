#!/usr/bin/env dcli

import 'dart:io';

import 'package:dcli/dcli.dart';
import 'package:trello_sdk/external/dio_client_factory.dart';
import 'package:trello_sdk/trello_cli.dart';

const String MEMBER = "kemitix";
const String MEMBER_ID = "5d999fc87ac5a442f45cb8eb";
const String BOARD = "5eccb96b04b4dc5666c64b7c";
const String LIST = "5de68ade15e1dc10b583219e";
const String CARD = "5dc1b58de65da8806ebabba8";
const String MUTABLE_CARD = "61b32a083270082adf87ffb1";
const String ATTACHMENT = "5dc1b58ee65da8806ebabbc7";
const String FILE_NAME = "larkspur.rtf";

void main() async {
  await trello('member get $MEMBER');
  await trello('member list-boards $MEMBER');
  await trello('board list-lists $BOARD');
  await trello('list list-cards $LIST');
  await trello('card get $CARD');
  await trello('card list-attachments $CARD');
  await trello('card get-attachment $CARD $ATTACHMENT');
  await trello('card download-attachment $CARD $ATTACHMENT $FILE_NAME');
  print(
      '$FILE_NAME - ${lastModified(FILE_NAME)} - ${calculateHash(FILE_NAME)}');
  delete(FILE_NAME);
  await trello('card get $MUTABLE_CARD');
  await trello(
      'card update $MUTABLE_CARD --name ${DateTime.now().toString().replaceAll(' ', '-')} --member-ids ');
  await trello('card get $MUTABLE_CARD');
  await trello('card add-member $MUTABLE_CARD $MEMBER_ID');
  await trello('card get $MUTABLE_CARD');
  await trello('card remove-member $MUTABLE_CARD $MEMBER_ID');
  await trello('card get $MUTABLE_CARD');
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
