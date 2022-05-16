import 'package:equatable/equatable.dart';

import '../client.dart';
import '../trello_object_model.dart';

class TrelloCard extends TrelloObject<CardFields> {
  TrelloCard(source, List<CardFields> fields)
      : super(source, fields, all: fields.contains(CardFields.all));

  // factory TrelloCard.fromJson(Map<String, dynamic> json) =>
  //     TrelloCard(json, [CardFields.all]);

  CardId get id => CardId(getValue(CardFields.id));

  CardBadges get badges {
    var e = (getValue(CardFields.badges) as Map<String, dynamic>);
    return CardBadges(
        e['votes'],
        e['viewingMemberVoted'],
        e['subscribed'],
        e['fogbugz'],
        e['checkItems'],
        e['checkItemsChecked'],
        e['comments'],
        e['attachments'],
        e['description'],
        DateTime.parse(e['due']),
        e['dueComplete']);
  }

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

  List<String> get idChecklists =>
      getValueAsListString(CardFields.idChecklists);

  List<String> get idLabels => getValueAsListString(CardFields.idLabels);

  String get idList => getValue(CardFields.idList);

  List<String> get idMembers => getValueAsListString(CardFields.idMembers);

  List<String> get idMembersVoted =>
      getValueAsListString(CardFields.idMembersVoted);

  int get idShort => getValue(CardFields.idShort);

  List<CardLabel> get labels => (getValue(CardFields.labels) as List<dynamic>)
      .map((e) => CardLabel(e['id'], e['idBoard'], e['name'], e['color']))
      .toList();

  bool get manualCoverAttachment => getValue(CardFields.manualCoverAttachment);

  String get name => getValue(CardFields.name);

  double get pos => getValue(CardFields.pos);

  String get shortLink => getValue(CardFields.shortLink);

  String get shortUrl => getValue(CardFields.shortUrl);

  bool get subscribed => getValue(CardFields.subscribed);

  String get url => getValue(CardFields.url);

  String get address => getValue(CardFields.address);

  String get locationName => getValue(CardFields.locationName);

  CardCoordinates get coordinates {
    var value = getValue(CardFields.coordinates);
    if (value is String) {
      List<String> split = value.split(',');
      return CardCoordinates(
          latitude: double.parse(split[0]), longitude: double.parse(split[1]));
    }
    return CardCoordinates(
        latitude: value['latitude'], longitude: value['longitude']);
  }

  @override
  String toString() {
    return 'TrelloCard{$raw';
  }
}

class CardId extends StringValue {
  CardId(super.id);
}

class AttachmentId extends StringValue {
  AttachmentId(super.id);
}

class FileName extends StringValue {
  FileName(super.fileName);
}

// Field vale may come from Trello as 'latitude,longitude'
class CardCoordinates with EquatableMixin {
  late double latitude;
  late double longitude;

  CardCoordinates({required this.latitude, required this.longitude});

  @override
  List<Object?> get props => [latitude, longitude];
}

class CardLabel with EquatableMixin {
  late String id;
  late String idBoard;
  late String name;
  late String color;

  CardLabel(this.id, this.idBoard, this.name, this.color);

  @override
  List<Object?> get props => [id, idBoard, name, color];
}

class CardBadges with EquatableMixin {
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

  CardBadges(
      this.votes,
      this.viewingMemberVoted,
      this.subscribed,
      this.fogbugz,
      this.checkItems,
      this.checkItemsChecked,
      this.comments,
      this.attachments,
      this.description,
      this.due,
      this.dueComplete);

  @override
  List<Object?> get props => [
        votes,
        viewingMemberVoted,
        subscribed,
        fogbugz,
        checkItems,
        checkItemsChecked,
        comments,
        attachments,
        description,
        due,
        dueComplete
      ];
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
  coordinates,
}

enum CardFilter {
  all,
  closed,
  none,
  open,
}

class TrelloAttachment extends TrelloObject<AttachmentFields> {
  TrelloAttachment(source, List<AttachmentFields> fields)
      : super(source, fields);

  String get id => getValue(AttachmentFields.id);

  String get bytes => getValue(AttachmentFields.bytes);

  DateTime? get date => toDateTime(getValue(AttachmentFields.date));

  String get edgeColor => getValue(AttachmentFields.edgeColor);

  String get idMember => getValue(AttachmentFields.idMember);

  bool get isUpload => getValue(AttachmentFields.isUpload);

  String get mimeType => getValue(AttachmentFields.mimeType);

  String get name => getValue(AttachmentFields.name);

  List<String> get previews => getValueAsListString(AttachmentFields.previews);

  String get url => getValue(AttachmentFields.url);

  double get pos => getValue(AttachmentFields.pos);
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
  FALSE,
  COVER;

  @override
  String toString() => name.toLowerCase();
}
