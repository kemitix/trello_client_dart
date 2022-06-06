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
