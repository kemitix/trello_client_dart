import 'dart:ffi';

import '../client.dart';
import '../trello_object_model.dart';

class Card extends TrelloObject<CardFields> {
  Card(source, List<CardFields> fields)
      : super(source, fields, all: fields.contains(CardFields.all));

  CardId get id => CardId(getValue(CardFields.id));
  CardBadges get badges => getValue(CardFields.badges);
  //List<?> get checkItemStates => getValue(CardFields.checkItemStates);
  bool get closed => getValue(CardFields.closed);
  DateTime? get dateLastActivity =>
      toDateTime(getValue(CardFields.dateLastActivity));
  String get desc => getValue(CardFields.desc);
  //? get descData => getValue(CardFields.descData);
  DateTime? get due => toDateTime(getValue(CardFields.due));
  bool get dueComplete => getValue(CardFields.dueComplete);
  String get idAttachmentCover => getValue(CardFields.idAttachmentCover);
  String get idBoard => getValue(CardFields.idBoard);
  List<String> get idChecklists => getValue(CardFields.idChecklists);
  List<String> get idLabels => getValue(CardFields.idLabels);
  String get idList => getValue(CardFields.idList);
  List<String> get idMembers => getValue(CardFields.idMembers);
  List<String> get idMembersVoted => getValue(CardFields.idMembersVoted);
  int get idShort => getValue(CardFields.idShort);
  List<CardLabel> get labels => getValue(CardFields.labels);
  bool get manualCoverAttachment => getValue(CardFields.manualCoverAttachment);
  String get name => getValue(CardFields.name);
  Float get pos => getValue(CardFields.pos);
  String get shortLink => getValue(CardFields.shortLink);
  String get shortUrl => getValue(CardFields.shortUrl);
  bool get subscribed => getValue(CardFields.subscribed);
  String get url => getValue(CardFields.url);
  String get address => getValue(CardFields.address);
  String get locationName => getValue(CardFields.locationName);
  CardCoordinates get coodinates {
    var value = raw[CardFields.coodinates.name];
    if (value is String) {
      List<String> split = value.split(',');
      return CardCoordinates(latitude: split[0], longitude: split[1]);
    }
    return CardCoordinates(
        latitude: value['latitude'], longitude: value['longitude']);
  }
}

class CardId extends StringId {
  CardId(String id) : super(id);
}

// Field vale may come from Trello as 'latitude,longitude'
class CardCoordinates {
  late Float latitude;
  late Float longitude;

  CardCoordinates({required latitude, required longitude}) {
    this.latitude = latitude;
    this.longitude = longitude;
  }
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

class Attachment extends TrelloObject<AttachmentFields> {
  Attachment(source, List<AttachmentFields> fields) : super(source, fields);

  //TODO add field getters
}

enum AttachmentFields {
  all,
  id,
  bytes,
  date,
  edgeColor,
  idMember,
  isUpload,
  mimeType,
  name,
  pos,
  previews,
  url,
}

enum AttachmentFilter {
  falsE, // Uppercase E to avoid clashing with language keyword - use toLowerCase when passing to API
  cover,
}
