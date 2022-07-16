import 'package:trello_client/src/sdk/types.dart';

export 'member_board_filter.dart';
export 'member_client.dart';
export 'member_fields.dart';
export 'member_id.dart';
export 'trello_member.dart';

typedef MemberOrganizations = Organizations;
typedef MemberTokens = AllOrNone;
typedef MemberCustomStickers = AllOrNone;
typedef MemberCustomEmoji = AllOrNone;
typedef MemberCustomBoardBackground = AllOrNone;
typedef MemberActions = String;
typedef MemberBoards = String;
typedef MemberCards = OpenClosedVisibleFilter;
typedef MemberBoardBackgrounds = BoardBackgrounds;
typedef MemberBoardsInvited = BoardsInvited;
typedef MemberBoardsInvitedFields = BoardsInvitedFields;
typedef MemberNotifications = String;
typedef MemberOrganizationFields = OrganizationFields;
typedef MemberOrganizationsInvited = OrganizationsInvited;
typedef MemberOrganizationsInvitedFields = OrganizationsInvitedFields;

/// 'default' is a reserved word, so is here in uppercase
/// use the names in lowercase to get correct form
enum BoardBackgrounds {
  all,
  custom,
  defaulT,
  none,
  premium;
}

enum BoardsInvited {
  all,
  closed,
  members,
  open,
  organization,
  pinned,
  public,
  starred,
  unpinned
}

enum BoardsInvitedFields {
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
  limits,
  memberships,
  enterpriseOwned
}
