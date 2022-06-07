import 'package:equatable/equatable.dart' show Equatable;

import 'members/members.dart' show MemberId;

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
