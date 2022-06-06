import '../coordinates.dart' show Coordinates;
import '../trello_object.dart' show TrelloObject;
import 'card_id.dart' show CardId;
import 'card_label.dart' show CardLabel;
import 'card_models.dart' show CardBadges, CardFields;

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

  Coordinates get coordinates {
    var value = getValue(CardFields.coordinates);
    if (value is String) {
      List<String> split = value.split(',');
      return Coordinates(
          latitude: double.parse(split[0]), longitude: double.parse(split[1]));
    }
    return Coordinates(
        latitude: value['latitude'], longitude: value['longitude']);
  }
}
