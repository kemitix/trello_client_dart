import 'package:dartz/dartz.dart' show Function1;
import 'package:equatable/equatable.dart' show Equatable, EquatableMixin;

import 'boards/boards.dart' show BoardClient, BoardId;
import 'cards/cards.dart' show CardClient, CardId;
import 'http_client.dart' show HttpClient;
import 'lists/lists.dart' show ListClient, ListId;
import 'members/members.dart' show MemberClient, MemberId;

class TrelloAuthentication extends Equatable {
  final String _key;

  String get key => _key;

  final String _token;

  String get token => _token;

  final MemberId _memberId;

  MemberId get memberId => _memberId;

  TrelloAuthentication.of(this._memberId, this._key, this._token);

  @override
  List<Object?> get props => [memberId, key, token];
}

class TrelloClient {
  late final HttpClient _httpClient;
  late final Function1<MemberId, MemberClient> _member;
  late final Function1<BoardId, BoardClient> _board;
  late final Function1<ListId, ListClient> _list;
  late final Function1<CardId, CardClient> _card;

  TrelloClient(this._httpClient, TrelloAuthentication authentication) {
    _member = (id) => MemberClient(_httpClient, id);
    _board = (id) => BoardClient(_httpClient, id);
    _list = (id) => ListClient(_httpClient, id);
    _card = (id) => CardClient(_httpClient, id, authentication);
  }

  MemberClient member(MemberId id) => _member(id);

  BoardClient board(BoardId id) => _board(id);

  ListClient list(ListId id) => _list(id);

  CardClient card(CardId id) => _card(id);

  void close() {
    _httpClient.close();
  }
}

abstract class StringValue with EquatableMixin {
  final String value;

  StringValue(this.value);

  @override
  List<Object?> get props => [value];

  @override
  String toString() {
    return value;
  }
}
