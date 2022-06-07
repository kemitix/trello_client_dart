import '../trello_object.dart' show TrelloObject;
import 'attachment_fields.dart' show AttachmentFields;

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
