import '../members/member_models.dart' show MemberId;
import '../trello_object.dart' show TrelloObject;
import 'board_id.dart' show BoardId;
import 'board_models.dart' show BoardFields;

class TrelloBoard extends TrelloObject<BoardFields> {
  TrelloBoard(source, List<BoardFields> fields)
      : super(source, fields, all: fields.contains(BoardFields.all));

  BoardId get id => BoardId(getValue(BoardFields.id));

  String get name => getValue(BoardFields.name);

  String get desc => getValue(BoardFields.desc);

  String get descData => getValue(BoardFields.descData);

  bool get closed => getValue(BoardFields.closed);

  MemberId get idMemberCreator =>
      MemberId(getValue(BoardFields.idMemberCreator));

  String get idOrganization => getValue(BoardFields.idOrganization);

  bool get pinned => getValue(BoardFields.pinned);

  String get url => getValue(BoardFields.url);

  String get shortUrl => getValue(BoardFields.shortUrl);

  bool get starred => getValue(BoardFields.starred);

  String get memberships => getValue(BoardFields.memberships);

  String get enterpriseOwned => getValue(BoardFields.enterpriseOwned);
// TODO prefs
// TODO labelNames
// TODO limits
}
