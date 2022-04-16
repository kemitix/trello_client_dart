import '../client.dart';
import '../trello_models.dart';
import '../trello_object_model.dart';

class Member extends TrelloObject<MemberFields> {
  Member(source, List<MemberFields> fields) : super(source, fields);

  MemberId get id => MemberId(getValue(MemberFields.id));
  String get fullName => getValue(MemberFields.fullName);
  String get url => getValue(MemberFields.url);
  //TODO add more fields
  //TODO add a toString
}

class MemberId extends StringId {
  MemberId(id) : super(id);
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
