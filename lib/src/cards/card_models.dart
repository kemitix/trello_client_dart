class Card {
  final dynamic _source;
  final List<CardFields> _fields;

  Card(this._source, this._fields);

  String get id => _getValue(CardFields.id);
  String get name => _getValue(CardFields.name);
  // badges,
  // checkItemStates,
  // closed,
  // dateLastActivity,
  // desc,
  // descData,
  // due,
  // dueComplete,
  // idAttachmentCover,
  // idBoard,
  // idChecklists,
  // idLabels,
  // idList,
  // idMembers,
  // idMembersVoted,
  // isShort,
  // labels,
  // manualCoverAttachment,
  // pos,
  // shortLink,
  // shortUrl,
  // subscribed,
  // url,
  // address,
  // locationName,
  // coodinates,

  T _getValue<T>(CardFields field) {
    if (_fields.contains(CardFields.all) || _fields.contains(field)) {
      return _source[field.name];
    }
    throw AssertionError(
        'List: Attempt to access field not retrieved: ${field.name}');
  }
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
  isShort,
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
