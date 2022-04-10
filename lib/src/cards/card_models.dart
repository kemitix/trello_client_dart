import 'dart:ffi';

class Card {
  final dynamic _source;
  final List<CardFields> _fields;

  Card(this._source, this._fields);

  String get id => _getValue(CardFields.id);
  CardBadges get badges => _getValue(CardFields.badges);
  //List<?> get checkItemStates => _getValue(CardFields.checkItemStates);
  bool get closed => _getValue(CardFields.closed);
  DateTime get dateLastActivity => _getValue(CardFields.dateLastActivity);
  String get desc => _getValue(CardFields.desc);
  //? get descData => _getValue(CardFields.descData);
  DateTime get due => _getValue(CardFields.due);
  bool get dueComplete => _getValue(CardFields.dueComplete);
  String get idAttachmentCover => _getValue(CardFields.idAttachmentCover);
  String get idBoard => _getValue(CardFields.idBoard);
  List<String> get idChecklists => _getValue(CardFields.idChecklists);
  List<String> get idLabels => _getValue(CardFields.idLabels);
  String get idList => _getValue(CardFields.idList);
  List<String> get idMembers => _getValue(CardFields.idMembers);
  List<String> get idMembersVoted => _getValue(CardFields.idMembersVoted);
  int get idShort => _getValue(CardFields.idShort);
  List<CardLabel> get labels => _getValue(CardFields.labels);
  bool get manualCoverAttachment => _getValue(CardFields.manualCoverAttachment);
  String get name => _getValue(CardFields.name);
  Float get pos => _getValue(CardFields.pos);
  String get shortLink => _getValue(CardFields.shortLink);
  String get shortUrl => _getValue(CardFields.shortUrl);
  bool get subscribed => _getValue(CardFields.subscribed);
  String get url => _getValue(CardFields.url);
  String get address => _getValue(CardFields.address);
  String get locationName => _getValue(CardFields.locationName);
  CardCoordinates get coodinates => _getValue(CardFields.coodinates);

  T _getValue<T>(CardFields field) {
    if (_fields.contains(CardFields.all) || _fields.contains(field)) {
      return _source[field.name];
    }
    throw AssertionError(
        'List: Attempt to access field not retrieved: ${field.name}');
  }
}

// Field vale may come from Trello as 'latitude,longitude'
class CardCoordinates {
  late Float latitude;
  late Float longitude;
}

class CardLabel {
  late String id;
  late String idBoard;
  late String name;
  late String color;
}

class CardBadges {
  late int votes;
  late bool viewingMemberVoted;
  late bool subscribed;
  late String fogbugz;
  late int checkItems;
  late int checkItemsChecked;
  late int comments;
  late int attachments;
  late bool description;
  late DateTime due;
  late bool dueComplete;
}

enum CardFields {
  all,
  id,
  badges,
  checkItemStates,
  closed,
  dateLastActivity,
  desc,
  descData,
  due,
  dueComplete,
  idAttachmentCover,
  idBoard,
  idChecklists,
  idLabels,
  idList,
  idMembers,
  idMembersVoted,
  idShort,
  labels,
  manualCoverAttachment,
  name,
  pos,
  shortLink,
  shortUrl,
  subscribed,
  url,
  address,
  locationName,
  coodinates,
}

enum CardFilter {
  all,
  closed,
  none,
  open,
}
