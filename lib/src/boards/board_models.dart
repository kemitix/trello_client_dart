class Board {
  final dynamic _source;
  final List<BoardFields> _fields;

  Board(this._source, this._fields) {}

  String get id => _getValue(BoardFields.id);
  String get name => _getValue(BoardFields.name);
  String get desc => _getValue(BoardFields.desc);
  String get descData => _getValue(BoardFields.descData);
  bool get closed => _getValue(BoardFields.closed);
  String get idMemberCreator => _getValue(BoardFields.idMemberCreator);
  String get idOrganization => _getValue(BoardFields.idOrganization);
  bool get pinned => _getValue(BoardFields.pinned);
  String get url => _getValue(BoardFields.url);
  String get shortUrl => _getValue(BoardFields.shortUrl);
  BoardPrefs get prefs => BoardPrefs(_getValue(BoardFields.prefs));
  BoardLabelNames get labelNames =>
      BoardLabelNames(_getValue(BoardFields.labelNames));
  bool get starred => _getValue(BoardFields.starred);
  //TODO BoardLimits get limit => _getValue(BoardFields.limits);
  String get memberships => _getValue(BoardFields.memberships);
  String get enterpriseOwned => _getValue(BoardFields.enterpriseOwned);

  T _getValue<T>(BoardFields field) {
    if (_fields.contains(BoardFields.all) || _fields.contains(field)) {
      return _source[field.name];
    }
    throw AssertionError(
        'Board: Attempt to access field not retrieved: ${field.name}');
  }
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
      _getValue(BoardPrefsFields.permissionLevel); //org or board
  bool get hideVotes => _getValue(BoardPrefsFields.hideVotes);
  String get voting => _getValue(BoardPrefsFields.voting); //disabled or enabled
  String get comments => _getValue(BoardPrefsFields.comments);
  //TODO dynamic get invitations => _getValue(BoardPrefsFields.invitations);
  bool get selfJoin => _getValue(BoardPrefsFields.selfJoin);
  bool get cardCovers => _getValue(BoardPrefsFields.cardCovers);
  bool get isTemplate => _getValue(BoardPrefsFields.isTemplate);
  String get cardAging =>
      _getValue(BoardPrefsFields.cardAging); //pirate or regular
  bool get calendarFeedEnabled =>
      _getValue(BoardPrefsFields.calendarFeedEnabled);
  String get background => _getValue(BoardPrefsFields.background);
  String get backgroundImage => _getValue(BoardPrefsFields.backgroundImage);
  List<BoardBackgroundImageScaledDescriptor> get backgroundImageScaled {
    var value = _getValue(BoardPrefsFields.backgroundImageScaled);
    List<BoardBackgroundImageScaledDescriptor> result = [];
    if (value != null) {
      value
          .map((item) => BoardBackgroundImageScaledDescriptor(item))
          .forEach(result.add);
    }
    return result;
  }

  bool get backgroundTile => _getValue(BoardPrefsFields.backgroundTile);
  String get backgroundBrightness =>
      _getValue(BoardPrefsFields.backgroundBrightness);
  String get backgroundBottomColor =>
      _getValue(BoardPrefsFields.backgroundBottomColor);
  String get backgroundTopColor =>
      _getValue(BoardPrefsFields.backgroundTopColor);
  bool get canBePublic => _getValue(BoardPrefsFields.canBePublic);
  bool get canBeEnterprise => _getValue(BoardPrefsFields.canBeEnterprise);
  bool get canBeOrg => _getValue(BoardPrefsFields.canBeOrg);
  bool get canBePrivate => _getValue(BoardPrefsFields.canBePrivate);
  bool get canInvite => _getValue(BoardPrefsFields.canInvite);

  T _getValue<T>(BoardPrefsFields field) {
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
