CLI and SDK for accessing the Trello API

- `package:trello_sdk/trello_sdk.dart` - Access the Trello API
- `bin/trello.dart` - CLI to access Trello

Status: **experimental/alpha/development**

Developing a client library for interacting with Trello API.
Includes a CLI to exercise and test `trello_sdk`.
The CLI will provide *some* functionality as a simple Trello Client in itself.

## Test Drive

```bash
$ dart run bin/trello.dart --help
```

Or, once installed and `trello` is on `PATH`:

```bash
trello --help
```

## Example - Demo

The demo uses the CLI interface to obtain member info, boards, lists, cards and attachments from Trello.
It also downloads an attachment and updates a card.

Update the constants at the top of the file to match your own account and permissions.
Set the `MEMBER` value first then iteratively run the demo to identify the ID of the next value to set.

## API Coverage

This list of API actions was retrieved from the
[Trello Reference REST API](https://developer.atlassian.com/cloud/trello/rest/api-group-actions/#api-actions-idaction-reactionssummary-get)
on 11th April 2022.

Key:

- ✔ Done

### Actions

| Status | Label                               |
|:------:|:------------------------------------|
|        | Get an Action                       |
|        | Update an Action                    |
|        | Delete an Action                    |
|        | Get a specific field on an Action   |
|        | Get the Board for an Action         |
|        | Get the Card for an Action          |
|        | Get the List for an Action          |
|        | Get the Member of an Action         |
|        | Get the Member Creator of an Action |
|        | Get the Organization of an Action   |
|        | Update a Comment Action             |
|        | Get Action's Reactions              |
|        | Create Reaction for Action          |
|        | Get Action's Reaction               |
|        | Delete Action's Reaction            |
|        | List Action's summary of Reactions  |

### Applications

| Status | Label                             |
|:------:|:----------------------------------|
|        | Get Application's compliance data |

### Batch

| Status | Label          |
|:------:|:---------------|
|        | Batch Requests |

### Boards

| Status | Label                                          | SDK: .board(id) | CLI: board    | Query Path                |
|:------:|:-----------------------------------------------|-----------------|---------------|---------------------------|
|        | Get Memberships of a Board                     |                 |               |                           |
|        | Get a Board                                    |                 |               |                           |
|        | Update a Board                                 |                 |               |                           |
|        | Delete a Board                                 |                 |               |                           |
|        | Get a field on a Board                         |                 |               |                           |
|        | Get Actions of a Board                         |                 |               |                           |
|        | Get a Card on a Board                          |                 |               |                           |
|        | Get boardStars on a Board                      |                 |               |                           |
|        | Get Checklists on a Board                      |                 |               |                           |
|        | Create Checklist on a Board                    |                 |               |                           |
|        | Get Cards on a Board                           |                 |               |                           |
|        | Get filtered Cards on a Board                  |                 |               |                           |
|        | Get Custom Fields for Board                    |                 |               |                           |
|        | Get Labels on a Board                          |                 |               |                           |
|        | Create a Label on a Board                      |                 |               |                           |
|   ✔    | Get Lists on a Board                           | .getLists()     | list-lists ID | GET /1/boards/{id}/lists  |
|        | Create a List on a Board                       |                 |               |                           |
|        | Get filtered Lists on a Board                  |                 |               |                           |
|        | Get the Members of a Board                     |                 |               |                           |
|        | Invite Member to Board via email               |                 |               |                           |
|        | Add a Member to a Board                        |                 |               |                           |
|        | Remove Member from Board                       |                 |               |                           |
|        | Update Membership of Member on a Board         |                 |               |                           |
|        | Update emailPosition Pref on a Board           |                 |               |                           |
|        | Update idEmailList Pref on a Board             |                 |               |                           |
|        | Update showListGuide Pref on a Board           |                 |               |                           |
|        | Update showSidebar Pref on a Board             |                 |               |                           |
|        | Update showSidebarActivity Pref on a Board     |                 |               |                           |
|        | Update showSidebarBoardActions Pref on a Board |                 |               |                           |
|        | Update showSidebarMembers Pref on a Board      |                 |               |                           |
|        | Create a Board                                 |                 |               |                           |
|        | Create a calendarKey for a Board               |                 |               |                           |
|        | Create a emailKey for a Board                  |                 |               |                           |
|        | Create a Tag for a Board                       |                 |               |                           |
|        | Mark Board as viewed                           |                 |               |                           |
|        | Get Enabled Power-Ups on Board                 |                 |               |                           |
|        | (deprecated) Enable a Power-Up on a Board      |                 |               |                           |
|        | (deprecated) Disable a Power-Up on a Board     |                 |               |                           |
|        | Get Power-Ups on a Board                       |                 |               |                           |

### Cards

| Status | Label                                 | SDK: .card(id)                               | CLI: card                                     | Query Path                                   |
|:------:|:--------------------------------------|----------------------------------------------|-----------------------------------------------|----------------------------------------------|
|        | Create a new Card                     |                                              |                                               |                                              |
|   ✔    | Get a Card                            | .get()                                       | get ID                                        | GET /1/cards/{id}                            |
|   ✔    | Update a Card                         | .put(card)                                   | update ID [options] [flags]                   | PUT /1/cards/{id}                            |
|        | Delete a Card                         | .delete()                                    | delete ID                                     |                                              |
|        | Get a field on a Card                 | .getField(field)                             |                                               |                                              |
|        | Get Actions on a Card                 | .actions()                                   |                                               |                                              |
|   ✔    | Get Attachments on a Card             | .attachments()                               | list-attachments ID                           | GET /1/cards/{id}/attachments                |
|        | Create Attachment On Card             | .createAttachment(...)                       |                                               |                                              |
|   ✔    | Get an Attachment on a Card           | .attachment(idAttachment).get()              | get-attachment ID ATTACHMENT_ID               | GET /1/cards/{id}/attachments/{idAttachment} |
|   ✔    | Dowload an Attachment on a Card       | .attachment(idAttachment).download(filename) | download-attachment ID ATTACHMENT_ID FILENAME | ...                                          |
|        | Delete an Attachment on a Card        | .attachment(idAttachment).delete()           |                                               |                                              |
|        | Get the Board the Card is on          | .board()                                     |                                               |                                              |
|        | Get checkItems on a Card              | .checkItems()                                |                                               |                                              |
|        | Get Checklists on a Card              | .checkLists()                                |                                               |                                              |
|        | Create Checklist on a Card            | .createCheckList(...)                        |                                               |                                              |
|        | Get checkItem on a Card               | .checkItem(idCheckItem).get()                |                                               |                                              |
|        | Update a checkItem on a Card          | .checkItem(idCheckItem).update(checkitem)    |                                               |                                              |
|        | Delete checkItem on a Card            | .checkItem(idCheckItem).delete()             |                                               |                                              |
|        | Get the List of a Card                | .list()                                      |                                               |                                              |
|        | Get the Members of a Card             | .members()                                   |                                               |                                              |
|        | Get Members who have voted on a Card  | .membersVoted()                              |                                               |                                              |
|        | Add Member vote to Card               | .addMemberVote(idMember)                     |                                               |                                              |
|        | Get pluginData on a Card              | .pluginData()                                |                                               |                                              |
|        | Get Stickers on a Card                | .stickers()                                  |                                               |                                              |
|        | Add a Sticker to a Card               | .createSticker()                             |                                               |                                              |
|        | Get a Sticker on a Card               | .sticker(idSticker).get()                    |                                               |                                              |
|        | Update a Sticker on a Card            | .sticker(idSticker).put(sticker)             |                                               |                                              |
|        | Delete a Sticker on a Card            | .sticker(idSticker).delete()                 |                                               |                                              |
|        | Update Comment Action on a Card       | .comment(idComment).put(comment)             |                                               |                                              |
|        | Delete a comment on a Card            | .comment(idComment).delete()                 |                                               |                                              |
|        | Update Custom Field item on Card      | .customField(idField).put(customField)       |                                               |                                              |
|        | Get Custom Field Items for a Card     | .customFields()                              |                                               |                                              |
|        | Add a new comment to a Card           | .addComment(...)                             |                                               |                                              |
|        | Add a Label to a Card                 | .addLabel(...)                               |                                               |                                              |
|   ✔    | Add a Member to a Card                | .addMember(idMember)                         | add-member ID MEMBER_ID                       | POST /1/cards/{id}/idMembers                 |
|        | Create a new Label on a Card          | .createLabel(...)                            |                                               |                                              |
|        | Mark a Card's Notifications as read   | .readNotifications()                         |                                               |                                              |
|        | Remove a Label from a Card            | .removeLabel(idLabel)                        |                                               |                                              |
|   ✔    | Remove a Member from a Card           | .removeMember(idMember)                      |                                               |                                              |
|        | Remove a Member's Vote on a Card      | .removeMemberVote(idMember)                  |                                               |                                              |
|        | Update Checkitem on Checklist on Card | .checkList(idCheckList).updateCheckItem(...) |                                               |                                              |
|        | Delete a Checklist on a Card          | .checkList(idCheckList).delete()             |                                               |                                              |

### Checklists

| Status | Label                             |
|:------:|:----------------------------------|
|        | Create a Checklist                |
|        | Get a Checklist                   |
|        | Update a Checklist                |
|        | Delete a Checklist                |
|        | Get field on a Checklist          |
|        | Update field on a Checklist       |
|        | Get the Board the Checklist is on |
|        | Get the Card a Checklist is on    |
|        | Get Checkitems on a Checklist     |
|        | Create Checkitem on Checklist     |
|        | Get a Checkitem on a Checklist    |
|        | Delete Checkitem from Checklist   |

### CustomFields

| Status | Label                                  |
|:------:|:---------------------------------------|
|        | Create a new Custom Field on a Board   |
|        | Get a Custom Field                     |
|        | Update a Custom Field definition       |
|        | Delete a Custom Field definition       |
|        | Get Options of Custom Field drop down  |
|        | Add Option to Custom Field dropdown    |
|        | Get Option of Custom Field dropdown    |
|        | Delete Option of Custom Field dropdown |

### Emoji

| Status | Label                |
|:------:|:---------------------|
|        | List available Emoji |

### Enterprises

| Status | Label                                                            |
|:------:|:-----------------------------------------------------------------|
|        | Get an Enterprise                                                |
|        | Get auditlog data for an Enterprise                              |
|        | Get Enterprise admin Members                                     |
|        | Get signupUrl for Enterprise                                     |
|        | Get Members of Enterprise                                        |
|        | Get a Member of Enterprise                                       |
|        | Get whether an organization can be transferred to an enterprise. |
|        | Get ClaimableOrganizations of an Enterprise                      |
|        | Get PendingOrganizations of an Enterprise                        |
|        | Create an auth Token for an Enterprise.                          |
|        | Transfer an Organization to an Enterprise.                       |
|        | Update a Member's licensed status                                |
|        | Deactivate a Member of an Enterprise.                            |
|        | Update Member to be admin of Enterprise                          |
|        | Remove a Member as admin from Enterprise.                        |
|        | Delete an Organization from an Enterprise.                       |

### Labels

| Status | Label                     |
|:------:|:--------------------------|
|        | Get a Label               |
|        | Update a Label            |
|        | Delete a Label            |
|        | Update a field on a label |
|        | Create a Label            |

### Lists

| Status | Label                       | SDK: .list(id) | CLI: list     | Query Path              |
|:------:|:----------------------------|----------------|---------------|-------------------------|
|        | Get a List                  |                |               |                         |
|        | Update a List               |                |               |                         |
|        | Create a new List           |                |               |                         |
|        | Archive all Cards in List   |                |               |                         |
|        | Move all Cards in List      |                |               |                         |
|        | Archive or unarchive a list |                |               |                         |
|        | Move List to Board          |                |               |                         |
|        | Update a field on a List    |                |               |                         |
|        | Get Actions for a List      |                |               |                         |
|        | Get the Board a List is on  |                |               |                         |
|   ✔    | Get Cards in a List         | .getCards()    | list-cards ID | GET /1/lists/{id}/cards |

### Members

| Status | Label                                          | SDK: .member(id)                            | CLI: member    | Query Path                                                   |
|:------:|:-----------------------------------------------|---------------------------------------------|----------------|--------------------------------------------------------------|
|   ✔    | Get a Member                                   | .get()                                      | get ID         | GET /1/members/{id}                                          |
|        | Update a Member                                | .put(...)                                   |                | PUT /1/members/{id}                                          |
|        | Get a field on a Member                        | .get(field)                                 |                | GET /1/members/{id}/{field}                                  |
|        | Get a Member's Actions                         | .getActions()                               |                | GET /1/members/{id}/actions                                  |
|        | Upload new boardBackground for Member          | .uploadBackground(...)                      |                | POST /1/members/{id}/boardBackgrounds                        |
|        | Get Member's custom Board backgrounds          | .getBackgrounds()                           |                | GET /1/members/{id}/boardBackgrounds                         |
|        | Get a boardBackground of a Member              | .background(idBackground).get()             |                | GET /1/members/{id}/boardBackgrounds/{idBackground}          |
|        | Update a Member's custom Board background      | .background(idBackground).put(...)          |                | PUT /1/members/{id}/boardBackgrounds/{idBackground}          |
|        | Delete a Member's custom Board background      | .background(idBackground).delete()          |                | DELETE /1/members/{id}/boardBackgrounds/{idBackground}       |
|        | Get a Member's custom Board Backgrounds        | .getCustomBackgrounds()                     |                | GET /1/members/{id}/customBoardBackgrounds                   |
|        | Create a new custom Board Background           | .uploadCustomBackground(...)                |                | POST /1/members/{id}/customBoardBackgrounds                  |
|        | Get custom Board Background of Member          | .customBackground(idBackground).get()       |                | GET /1/members/{id}/customBoardBackgrounds/{idBackground}    |
|        | Update custom Board Background of Member       | .customBackground(idBackground).update(...) |                | PUT /1/members/{id}/customBoardBackgrounds/{idBackground}    |
|        | Delete custom Board Background of Member       | .customBackground(idBackground).delete()    |                | DELETE /1/members/{id}/customBoardBackgrounds/{idBackground} |
|        | Get a Member's boardStars                      | .getStars()                                 |                | GET /1/members/{id}/boardStars                               |
|        | Create Star for Board                          | .createStar(...)                            |                | POST /1/members/{id}/boardStars                              |
|        | Get a boardStar of Member                      | .star(idStart).get()                        |                | GET /1/members/{id}/boardStars/{idStar}                      |
|        | Update the position of a boardStar of Member   | .star(idStar).put()                         |                | PUT /1/members/{id}/boardStars/{idStar}                      |
|        | Delete Star for Board                          | .star(idStar).delete()                      |                | DELETE /1/members/{id}/boardStars/{idStar}                   |
|   ✔    | Get Boards that Member belongs to              | .getBoards()                                | list-boards ID | GET /1/members/{id}/boards                                   |
|        | Get Boards the Member has been invited to      | .getBoardsInvited()                         |                | GET /1/members/{id}/boardsInvited                            |
|        | Get Cards the Member is on                     | .getCards()                                 |                | GET /1/members/{id}/cards                                    |
|        | Get a Member's customEmojis                    | .getEmoji()                                 |                | GET /1/members/{id}/customEmoji                              |
|        | Create custom Emoji for Member                 | .createEmoji(...)                           |                | POST /1/members/{id}/customEmoji                             |
|        | Get a Member's custom Emoji                    | .emoji(idEmoji).get()                       |                | GET /1/members/{id}/customEmoji/{idEmoji}                    |
|        | Get Member's custom Stickers                   | .getStickers()                              |                | GET /1/members/{id}/customStickers                           |
|        | Create custom Sticker for Member               | .createSticker(...)                         |                | POST /1/members/{id}/customStickers                          |
|        | Get a Member's custom Sticker                  | .sticker(idSticker).get()                   |                | GET /1/members/{id}/customStickers/{idSticker}               |
|        | Delete a Member's custom Sticker               | .sticker(idSticker).delete()                |                | DELETE /1/members/{id}/customStickers/{idSticker}            |
|        | Get Member's Notifications                     | .getNotifications()                         |                | GET /1/members/{id}/notifications                            |
|        | Get Member's Organizations                     | .getOrganizations()                         |                | GET /1/members/{id}/organizations                            |
|        | Get Organizations a Member has been invited to | .getOrganizationsInvited()                  |                | GET /1/members/{id}/organizationsInvited                     |
|        | Get Member's saved searched                    | .getSavedSearches()                         |                | GET /1/members/{id}/savedSearches                            |
|        | Create saved Search for Memer                  | .createSavedSearch(...)                     |                | POST /1/members/{id}/savedSearches                           |
|        | Get a saved search                             | .savedSearch(idSearch).get()                |                | GET /1/members/{id}/savedSearches/{idSearch}                 |
|        | Update a saved search                          | .savedSearch(idSearch).put(...)             |                | PUT /1/members/{id}/savedSearches/{idSearch}                 |
|        | Delete a saved search                          | .savedSearch(idSearch).delete()             |                | DELETE /1/members/{id}/savedSearches/{idSearch}              |
|        | Get Member's Tokens                            | .getTokens()                                |                | GET /1/members/{id}/tokens                                   |
|        | Create Avatar for Member                       | .createAvatar(...)                          |                | POST /1/members/{id}/avatar                                  |
|        | Dismiss a message for Member                   | .dismissMessage(...)                        |                | POST /1/members/{id}/oneTimeMessagesDismissed                |

### Notifications

| Status | Label                                                    |
|:------:|:---------------------------------------------------------|
|        | Get a Notification                                       |
|        | Update a Notification's read status                      |
|        | Get a field of a Notification                            |
|        | Mark all Notifications as read                           |
|        | Update Notification's read status                        |
|        | Get the Board a Notification is on                       |
|        | Get the Card a Notification is on                        |
|        | Get the List a Notification is on                        |
|        | Get the Member a Notification is about (not the creator) |
|        | Get the Member who created the Notification              |
|        | Get a Notification's associated Organization             |

### Organizations

| Status | Label                                                                      |
|:------:|:---------------------------------------------------------------------------|
|        | Create a new Organization                                                  |
|        | Get an Organization                                                        |
|        | Update an Organization                                                     |
|        | Delete an Organization                                                     |
|        | Get field on Organization                                                  |
|        | Get Actions for Organization                                               |
|        | Get Boards in an Organization                                              |
|        | Retrieve Organization's Exports                                            |
|        | Create Export for Organizations                                            |
|        | Get the Members of an Organization                                         |
|        | Update an Organization's Members                                           |
|        | Get Memberships of an Organization                                         |
|        | Get a Membership of an Organization                                        |
|        | Get the pluginData Scoped to Organization                                  |
|        | Get Tags of an Organization                                                |
|        | Create a Tag in Organization                                               |
|        | Update a Member of an Organization                                         |
|        | Remove a Member from an Organization                                       |
|        | Deactivate or reactivate a member of an Organization                       |
|        | Update logo for an Organization                                            |
|        | Delete Logo for Organization                                               |
|        | Remove a Member from an Organization and all Organization Boards           |
|        | Remove the associated Google Apps domain from a Workspace                  |
|        | Delete the email domain restriction on who can be invited to the Workspace |
|        | Delete an Organization's Tag                                               |
|        | Get Organizations new billable guests                                      |

### Plugins

| Status | Label                                  |
|:------:|:---------------------------------------|
|        | Get a Plugin                           |
|        | Update a Plugin                        |
|        | Create a Listing for Plugin            |
|        | Get Plugin's Member privacy compliance |
|        | Updating Plugin's Listing              |

### Search

| Status | Label              |
|:------:|:-------------------|
|        | Search Trello      |
|        | Search for Members |

### Tokens

| Status | Label                              |
|:------:|:-----------------------------------|
|        | Get a Token                        |
|        | Get Token's Member                 |
|        | Get Webhooks for Token             |
|        | Create Webhooks for Token          |
|        | Get a Webhook belonging to a Token |
|        | Update a Webhook created by Token  |
|        | Delete a Webhook created by Token  |
|        | Delete a Token                     |

### Webhooks

| Status | Label                    |
|:------:|:-------------------------|
|        | Create a Webhook         |
|        | Get a Webhook            |
|        | Update a Webhook         |
|        | Delete a Webhook         |
|        | Get a field on a Webhook |
