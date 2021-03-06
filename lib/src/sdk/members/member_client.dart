import 'package:trello_client/trello_sdk.dart'
    show
        BoardFields,
        HttpClient,
        MemberActions,
        MemberBoardBackgrounds,
        MemberBoards,
        MemberBoardsInvited,
        MemberBoardsInvitedFields,
        MemberCards,
        MemberCustomBoardBackground,
        MemberCustomEmoji,
        MemberCustomStickers,
        MemberFields,
        MemberId,
        MemberNotifications,
        MemberOrganizationFields,
        MemberOrganizations,
        MemberOrganizationsInvited,
        MemberOrganizationsInvitedFields,
        MemberTokens,
        TrelloBoard,
        TrelloMember,
        asCsv;

import '../query_options.dart' show QueryOptions;
import 'member_board_filter.dart' show MemberBoardFilter;

class MemberClient {
  final HttpClient _client;
  final MemberId _id;

  MemberClient(this._client, this._id);

  /// Get a Member
  ///
  /// GET /1/members/{id}
  ///
  /// Get a member
  Future<TrelloMember> get({
    MemberActions? actions,
    MemberBoards? boards,
    MemberBoardBackgrounds boardBackgrounds = MemberBoardBackgrounds.none,
    List<MemberBoardsInvited>? boardsInvited,
    List<MemberBoardsInvitedFields>? boardsInvitedFields,
    bool boardStars = false,
    MemberCards cards = MemberCards.none,
    MemberCustomBoardBackground customBoardBackground =
        MemberCustomBoardBackground.none,
    MemberCustomEmoji customEmoji = MemberCustomEmoji.none,
    MemberCustomStickers customStickers = MemberCustomStickers.none,
    List<MemberFields>? fields,
    MemberNotifications? notifications,
    MemberOrganizations organizations = MemberOrganizations.none,
    List<MemberOrganizationFields>? organizationFields,
    bool organizationPaidAccount = false,
    MemberOrganizationsInvited organizationsInvited =
        MemberOrganizationsInvited.none,
    List<MemberOrganizationsInvitedFields>? organizationsInvitedFields,
    bool paidAccount = false,
    bool savedSearches = false,
    MemberTokens tokens = MemberTokens.none,
  }) {
    Map<String, String> queryParameters = {
      'boardBackgrounds': boardBackgrounds.name,
      'boardStars': boardStars.toString(),
      'boardsInvited': asCsv(boardsInvited ?? [MemberBoardsInvited.all]),
      'boardsInvitedFields':
          asCsv(boardsInvitedFields ?? [MemberBoardsInvitedFields.all]),
      'cars': cards.name,
      'customBoardBackground': customBoardBackground.name,
      'customEmoji': customEmoji.name,
      'customStickers': customStickers.name,
      'fields': asCsv(fields ?? [MemberFields.all]),
      'organizations': organizations.name,
      'organization_fields':
          asCsv(organizationFields ?? [MemberOrganizationFields.all]),
      'organization_paid_account': organizationPaidAccount.toString(),
      'organizationsInvited': organizationsInvited.name,
      'organizationsInvited_fields': asCsv(
          organizationsInvitedFields ?? [MemberOrganizationsInvitedFields.all]),
      'paid_account': paidAccount.toString(),
      'savedSearches': savedSearches.toString(),
      'tokens': tokens.name,
    };
    if (actions != null) queryParameters['actions'] = actions;
    if (boards != null) queryParameters['boards'] = boards;
    if (notifications != null) queryParameters['notifications'] = notifications;
    return _client
        .get<dynamic>(QueryOptions(
            path: '/1/members/$_id', queryParameters: queryParameters))
        .then((r) => r.data)
        .then((item) => TrelloMember(item, fields ?? [MemberFields.all]));
  }

  /// Get Boards that Member belongs to
  ///
  /// GET /1/members/{id}/boards
  ///
  /// Lists the boards that the user is a member of.
  ///
  /// https://developer.atlassian.com/cloud/trello/rest/api-group-members/#api-members-id-boards-get
  Future<List<TrelloBoard>> getBoards({
    MemberBoardFilter filter = MemberBoardFilter.all,
    List<BoardFields>? fields,
  }) =>
      _client
          .get<List<dynamic>>(QueryOptions(
            path: '/1/members/$_id/boards',
            queryParameters: {
              'filter': filter.name,
              'fields': asCsv(fields ?? [BoardFields.all])
            },
          ))
          .then((response) => response.data ?? [])
          .then((items) => items
              .map((item) => TrelloBoard(item, fields ?? [BoardFields.all]))
              .toList(growable: false));
}
