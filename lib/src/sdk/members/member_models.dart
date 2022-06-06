import '../client.dart' show StringValue;
import '../trello_models.dart'
    show
        AllOrNone,
        BoardBackgrounds,
        BoardsInvited,
        BoardsInvitedFields,
        NestedActionsQueryParamsActions,
        NestedBoardsQueryParamsBoards,
        NestedCardQueryParametersCards,
        NestedNotificationsQueryParametersNotifications,
        OrganizationFields,
        Organizations,
        OrganizationsInvited,
        OrganizationsInvitedFields;

class MemberId extends StringValue {
  MemberId(super.id);
}

enum MemberFields {
  all,
  id,
  activityBlocked,
  avatarHash,
  avatarUrl,
  bio,
  bioData,
  confirmed,
  fullName,
  idEnterprise,
  idEnterprisesDeactivated,
  idMemberReferrer,
  idPremOrgsAdmin,
  initials,
  memberType,
  nonPublic,
  nonPublicAvailable,
  products,
  url,
  username,
  status,
  aaEmail,
  aaEnrolledDate,
  aaId,
  avatarSource,
  email,
  gravatarHash,
  idBoards,
  idOrganizations,
  idEnterprisesAdmin,
  limits,
  loginTypes,
  marketingOptIn,
  messagesDismissed,
  oneTimeMessagesDismissed,
  prefs,
  trophies,
  uploadedAvatarHash,
  uploadedAvatarUrl,
  premiumFeatures,
  isAaMastered,
  ixUpdate,
  idBoardsPinned,
}

typedef MemberOrganizations = Organizations;
typedef MemberTokens = AllOrNone;
typedef MemberCustomStickers = AllOrNone;
typedef MemberCustomEmoji = AllOrNone;
typedef MemberCustomBoardBackground = AllOrNone;
typedef MemberActions = NestedActionsQueryParamsActions;
typedef MemberBoards = NestedBoardsQueryParamsBoards;
typedef MemberCards = NestedCardQueryParametersCards;
typedef MemberBoardBackgrounds = BoardBackgrounds;
typedef MemberBoardsInvited = BoardsInvited;
typedef MemberBoardsInvitedFields = BoardsInvitedFields;
typedef MemberNotifications = NestedNotificationsQueryParametersNotifications;
typedef MemberOrganizationFields = OrganizationFields;
typedef MemberOrganizationsInvited = OrganizationsInvited;
typedef MemberOrganizationsInvitedFields = OrganizationsInvitedFields;
