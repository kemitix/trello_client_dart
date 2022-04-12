import 'package:trello_client/src/trello_object_model.dart';

import '../../trello_client.dart';
import '../trello_models.dart';

class Member extends TrelloObject<MemberFields> {
  Member(source, List<MemberFields> fields) : super(source, fields);

  MemberId get id => MemberId(getValue(MemberFields.id));
}

class MemberId extends StringId {
  MemberId(id) : super(id);
}

enum MemberFields { all, id }

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
