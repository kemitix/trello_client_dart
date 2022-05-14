import '../client.dart';
import '../trello_models.dart';
import '../trello_object_model.dart';

class TrelloMember extends TrelloObject<MemberFields> {
  TrelloMember(super.source, super.fields);

  MemberId get id => MemberId(getValue(MemberFields.id));

  String get fullName => getValue(MemberFields.fullName);

  String get url => getValue(MemberFields.url);

  get username => getValue(MemberFields.username);

  get email => getValue(MemberFields.email);

  get initials => getValue(MemberFields.initials);

  get confirmed => getValue(MemberFields.confirmed);

  get memberType => getValue(MemberFields.memberType);

  get status => getValue(MemberFields.status);

  get bio => getValue(MemberFields.bio);

//TODO add more fields
//TODO add a toString
}

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
