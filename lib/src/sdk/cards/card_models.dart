import '../trello_object.dart' show TrelloObject;

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
