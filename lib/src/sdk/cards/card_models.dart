import 'package:equatable/equatable.dart' show EquatableMixin;

import '../client.dart' show StringValue;
import '../trello_object.dart' show TrelloObject;

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
  falsE,
  cover;

  @override
  String toString() => name.toLowerCase();
}
