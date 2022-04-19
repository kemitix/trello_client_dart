import '../client.dart';
import '../trello_object_model.dart';

class TrelloBoard extends TrelloObject<BoardFields> {
  TrelloBoard(source, List<BoardFields> fields)
      : super(source, fields, all: fields.contains(BoardFields.all));

  BoardId get id => BoardId(getValue(BoardFields.id));
  String get name => getValue(BoardFields.name);
  String get desc => getValue(BoardFields.desc);
  String get descData => getValue(BoardFields.descData);
  bool get closed => getValue(BoardFields.closed);
  String get idMemberCreator => getValue(BoardFields.idMemberCreator);
  String get idOrganization => getValue(BoardFields.idOrganization);
  bool get pinned => getValue(BoardFields.pinned);
  String get url => getValue(BoardFields.url);
  String get shortUrl => getValue(BoardFields.shortUrl);
  BoardPrefs get prefs => BoardPrefs(getValue(BoardFields.prefs));
  BoardLabelNames get labelNames =>
      BoardLabelNames(getValue(BoardFields.labelNames));
  bool get starred => getValue(BoardFields.starred);
  //TODO BoardLimits get limit => getValue(BoardFields.limits);
  String get memberships => getValue(BoardFields.memberships);
  String get enterpriseOwned => getValue(BoardFields.enterpriseOwned);
}

class BoardId extends StringValue {
  BoardId(String id) : super(id);
}

enum BoardFields {
  all,
  id,
  name,
  desc,
  descData,
  closed,
  idMemberCreator,
  idOrganization,
  pinned,
  url,
  shortUrl,
  prefs,
  labelNames,
  starred,
  //limits, -- https://developer.atlassian.com/cloud/trello/guides/rest-api/limits/
  memberships,
  enterpriseOwned
}

enum BoardPrefsFields {
  permissionLevel,
  hideVotes,
  voting,
  comments,
  //invitations,
  selfJoin,
  cardCovers,
  isTemplate,
  cardAging,
  calendarFeedEnabled,
  background,
  backgroundImage,
  backgroundImageScaled,
  backgroundTile,
  backgroundBrightness,
  backgroundBottomColor,
  backgroundTopColor,
  canBePublic,
  canBeEnterprise,
  canBeOrg,
  canBePrivate,
  canInvite,
}

class BoardPrefs {
  final dynamic _source;
  BoardPrefs(this._source);

  String get permissionLevel =>
      getValue(BoardPrefsFields.permissionLevel); //org or board
  bool get hideVotes => getValue(BoardPrefsFields.hideVotes);
  String get voting => getValue(BoardPrefsFields.voting); //disabled or enabled
  String get comments => getValue(BoardPrefsFields.comments);
  //TODO dynamic get invitations => getValue(BoardPrefsFields.invitations);
  bool get selfJoin => getValue(BoardPrefsFields.selfJoin);
  bool get cardCovers => getValue(BoardPrefsFields.cardCovers);
  bool get isTemplate => getValue(BoardPrefsFields.isTemplate);
  String get cardAging =>
      getValue(BoardPrefsFields.cardAging); //pirate or regular
  bool get calendarFeedEnabled =>
      getValue(BoardPrefsFields.calendarFeedEnabled);
  String get background => getValue(BoardPrefsFields.background);
  String get backgroundImage => getValue(BoardPrefsFields.backgroundImage);
  List<BoardBackgroundImageScaledDescriptor> get backgroundImageScaled {
    var value = getValue(BoardPrefsFields.backgroundImageScaled);
    List<BoardBackgroundImageScaledDescriptor> result = [];
    if (value != null) {
      value
          .map((item) => BoardBackgroundImageScaledDescriptor(item))
          .forEach(result.add);
    }
    return result;
  }

  bool get backgroundTile => getValue(BoardPrefsFields.backgroundTile);
  String get backgroundBrightness =>
      getValue(BoardPrefsFields.backgroundBrightness);
  String get backgroundBottomColor =>
      getValue(BoardPrefsFields.backgroundBottomColor);
  String get backgroundTopColor =>
      getValue(BoardPrefsFields.backgroundTopColor);
  bool get canBePublic => getValue(BoardPrefsFields.canBePublic);
  bool get canBeEnterprise => getValue(BoardPrefsFields.canBeEnterprise);
  bool get canBeOrg => getValue(BoardPrefsFields.canBeOrg);
  bool get canBePrivate => getValue(BoardPrefsFields.canBePrivate);
  bool get canInvite => getValue(BoardPrefsFields.canInvite);

  T getValue<T>(BoardPrefsFields field) {
    return _source[field.name];
  }
}

class BoardBackgroundImageScaledDescriptor {
  final dynamic _source;

  BoardBackgroundImageScaledDescriptor(this._source);

  int get width => _source['width'];
  int get height => _source['height'];
  String get url => _source['url'];
}

enum BoardLabelColours {
  green,
  yellow,
  orange,
  red,
  purple,
  blue,
  sky,
  lime,
  pink,
  black,
}

class BoardLabelNames {
  final Map<String, dynamic> _source;
  BoardLabelNames(this._source);

  List<String> get names => _source.keys
      .where((colour) => _source[colour].isNotEmpty)
      .map((colour) => _source[colour].toString())
      .toList(growable: false);

  List<String> get colours => _source.keys
      .where((colour) => _source[colour].isNotEmpty)
      .toList(growable: false);

  List<BoardLabel> get labels => colours
      .map((colour) => BoardLabel(colour, _source[colour]))
      .toList(growable: false);
}

class BoardLabel {
  final String colour;
  final String name;
  BoardLabel(this.colour, this.name);
}
