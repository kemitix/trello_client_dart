/// 'default' is a reserved word, so is here in uppercase
/// use the names in lowercase to get correct form
enum BoardBackgrounds { all, custom, defaulT, none, premium }

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

enum AllOrNone { all, none }

typedef NestedActionsQueryParamsActions = String;
typedef NestedBoardsQueryParamsBoards = String;

enum NestedCardQueryParametersCards { all, closed, none, open, visible }

typedef NestedNotificationsQueryParametersNotifications = String;

enum Organizations { all, members, none, public }

enum OrganizationFields { all, id, name }

enum OrganizationsInvited { all, members, none, public }

enum OrganizationsInvitedFields { all, id, name }
