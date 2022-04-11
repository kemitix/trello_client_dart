# Trello Client for Dart

- trello_client_dart

Status: experimental/alpha/development

Developing a client library for interacting with Trello API. Includes a command line tool to exercise and test the client library that will provide *some* functionality as a simple Trello Client in itself. Ultimately these should be broken into two packages - when I figure out how to do that, but it's not a priority.

## Test Drive

```bash
$ dart run bin/trello_client.dart $TRELLO_USERNAME $TRELLO_KEY $TRELLO_TOKEN 
```

# API Coverage

This list of API actions was retrieved from the [Trello Reference REST API](https://developer.atlassian.com/cloud/trello/rest/api-group-actions/#api-actions-idaction-reactionssummary-get) on 11th April 2022.

- ✔ Done
- 𐄂 To do

## Actions

| Status  | Label                               |
|:-------:|:------------------------------------|
|   𐄂    | Get an Action                       |
|   𐄂    | Update an Action                    |
|   𐄂    | Delete an Action                    |
|   𐄂    | Get a specific field on an Action   |
|   𐄂    | Get the Board for an Action         |
|   𐄂    | Get the Card for an Action          |
|   𐄂    | Get the List for an Action          |
|   𐄂    | Get the Member of an Action         |
|   𐄂    | Get the Member Creator of an Action |
|   𐄂    | Get the Organization of an Action   |
|   𐄂    | Update a Comment Action             |
|   𐄂    | Get Action's Reactions              |
|   𐄂    | Create Reaction for Action          |
|   𐄂    | Get Action's Reaction               |
|   𐄂    | Delete Action's Reaction            |
|   𐄂    | List Action's summary of Reactions  |

## Applications

| Status | Label                             |
|:------:|:----------------------------------|
|  𐄂    | Get Application's compliance data |

## Batch

| Status | Label          |
|:------:|:---------------|
|  𐄂    | Batch Requests |

## Boards

| Status | Label                                          | .boards    |
|:------:|:-----------------------------------------------|------------|
|   𐄂   | Get Memberships of a Board                     |            |
|   𐄂   | Get a Board                                    |            |
|   𐄂   | Update a Board                                 |            |
|   𐄂   | Delete a Board                                 |            |
|   𐄂   | Get a field on a Board                         |            |
|   𐄂   | Get Actions of a Board                         |            |
|   𐄂   | Get a Card on a Board                          |            |
|   𐄂   | Get boardStars on a Board                      |            |
|   𐄂   | Get Checklists on a Board                      |            |
|   𐄂   | Create Checklist on a Board                    |            |
|   𐄂   | Get Cards on a Board                           |            |
|   𐄂   | Get filtered Cards on a Board                  |            |
|   𐄂   | Get Custom Fields for Board                    |            |
|   𐄂   | Get Labels on a Board                          |            |
|   𐄂   | Create a Label on a Board                      |            |
|   ✔    | Get Lists on a Board                           | .lists.get |
|   𐄂   | Create a List on a Board                       |            |
|   𐄂   | Get filtered Lists on a Board                  |            |
|   𐄂   | Get the Members of a Board                     |            |
|   𐄂   | Invite Member to Board via email               |            |
|   𐄂   | Add a Member to a Board                        |            |
|   𐄂   | Remove Member from Board                       |            |
|   𐄂   | Update Membership of Member on a Board         |            |
|   𐄂   | Update emailPosition Pref on a Board           |            |
|   𐄂   | Update idEmailList Pref on a Board             |            |
|   𐄂   | Update showListGuide Pref on a Board           |            |
|   𐄂   | Update showSidebar Pref on a Board             |            |
|   𐄂   | Update showSidebarActivity Pref on a Board     |            |
|   𐄂   | Update showSidebarBoardActions Pref on a Board |            |
|   𐄂   | Update showSidebarMembers Pref on a Board      |            |
|   𐄂   | Create a Board                                 |            |
|   𐄂   | Create a calendarKey for a Board               |            |
|   𐄂   | Create a emailKey for a Board                  |            |
|   𐄂   | Create a Tag for a Board                       |            |
|   𐄂   | Mark Board as viewed                           |            |
|   𐄂   | Get Enabled Power-Ups on Board                 |            |
|   𐄂   | (deprecated) Enable a Power-Up on a Board      |            |
|   𐄂   | (deprecated) Disable a Power-Up on a Board     |            |
|   𐄂   | Get Power-Ups on a Board                       |            |

## Cards

| Status | Label                                 |
|:------:|:--------------------------------------|
|   𐄂   | Create a new Card                     |
|   𐄂   | Get a Card                            |
|   𐄂   | Update a Card                         |
|   𐄂   | Delete a Card                         |
|   𐄂   | Get a field on a Card                 |
|   𐄂   | Get Actions on a Card                 |
|   𐄂   | Get Attachments on a Card             |
|   𐄂   | Create Attachment On Card             |
|   𐄂   | Get an Attachment on a Card           |
|   𐄂   | Delete an Attachment on a Card        |
|   𐄂   | Get the Board the Card is on          |
|   𐄂   | Get checkItems on a Card              |
|   𐄂   | Get Checklists on a Card              |
|   𐄂   | Create Checklist on a Card            |
|   𐄂   | Get checkItem on a Card               |
|   𐄂   | Update a checkItem on a Card          |
|   𐄂   | Delete checkItem on a Card            |
|   𐄂   | Get the List of a Card                |
|   𐄂   | Get the Members of a Card             |
|   𐄂   | Get Members who have voted on a Card  |
|   𐄂   | Add Member vote to Card               |
|   𐄂   | Get pluginData on a Card              |
|   𐄂   | Get Stickers on a Card                |
|   𐄂   | Add a Sticker to a Card               |
|   𐄂   | Get a Sticker on a Card               |
|   𐄂   | Update a Sticker on a Card            |
|   𐄂   | Delete a Sticker on a Card            |
|   𐄂   | Update Comment Action on a Card       |
|   𐄂   | Delete a comment on a Card            |
|   𐄂   | Update Custom Field item on Card      |
|   𐄂   | Get Custom Field Items for a Card     |
|   𐄂   | Add a new comment to a Card           |
|   𐄂   | Add a Label to a Card                 |
|   𐄂   | Add a Member to a Card                |
|   𐄂   | Create a new Label on a Card          |
|   𐄂   | Mark a Card's Notifications as read   |
|   𐄂   | Remove a Label from a Card            |
|   𐄂   | Remove a Member from a Card           |
|   𐄂   | Remove a Member's Vote on a Card      |
|   𐄂   | Update Checkitem on Checklist on Card |
|   𐄂   | Delete a Checklist on a Card          |

## Checklists

| Status | Label                             |
|:------:|:----------------------------------|
|   𐄂   | Create a Checklist                |
|   𐄂   | Get a Checklist                   |
|   𐄂   | Update a Checklist                |
|   𐄂   | Delete a Checklist                |
|   𐄂   | Get field on a Checklist          |
|   𐄂   | Update field on a Checklist       |
|   𐄂   | Get the Board the Checklist is on |
|   𐄂   | Get the Card a Checklist is on    |
|   𐄂   | Get Checkitems on a Checklist     |
|   𐄂   | Create Checkitem on Checklist     |
|   𐄂   | Get a Checkitem on a Checklist    |
|   𐄂   | Delete Checkitem from Checklist   |

## CustomFields

| Status | Label                                  |
|:------:|:---------------------------------------|
|   𐄂   | Create a new Custom Field on a Board   |
|   𐄂   | Get a Custom Field                     |
|   𐄂   | Update a Custom Field definition       |
|   𐄂   | Delete a Custom Field definition       |
|   𐄂   | Get Options of Custom Field drop down  |
|   𐄂   | Add Option to Custom Field dropdown    |
|   𐄂   | Get Option of Custom Field dropdown    |
|   𐄂   | Delete Option of Custom Field dropdown |

## Emoji

| Status | Label                |
|:------:|:---------------------|
|   𐄂   | List available Emoji |

## Enterprises

| Status | Label                                                            |
|:------:|:-----------------------------------------------------------------|
|   𐄂   | Get an Enterprise                                                |
|   𐄂   | Get auditlog data for an Enterprise                              |
|   𐄂   | Get Enterprise admin Members                                     |
|   𐄂   | Get signupUrl for Enterprise                                     |
|   𐄂   | Get Members of Enterprise                                        |
|   𐄂   | Get a Member of Enterprise                                       |
|   𐄂   | Get whether an organization can be transferred to an enterprise. |
|   𐄂   | Get ClaimableOrganizations of an Enterprise                      |
|   𐄂   | Get PendingOrganizations of an Enterprise                        |
|   𐄂   | Create an auth Token for an Enterprise.                          |
|   𐄂   | Transfer an Organization to an Enterprise.                       |
|   𐄂   | Update a Member's licensed status                                |
|   𐄂   | Deactivate a Member of an Enterprise.                            |
|   𐄂   | Update Member to be admin of Enterprise                          |
|   𐄂   | Remove a Member as admin from Enterprise.                        |
|   𐄂   | Delete an Organization from an Enterprise.                       |

## Labels

| Status | Label                     |
|:------:|:--------------------------|
|   𐄂   | Get a Label               |
|   𐄂   | Update a Label            |
|   𐄂   | Delete a Label            |
|   𐄂   | Update a field on a label |
|   𐄂   | Create a Label            |

## Lists

| Status | Label                       | .lists     |
|:------:|:----------------------------|------------|
|   𐄂   | Get a List                  |            |
|   𐄂   | Update a List               |            |
|   𐄂   | Create a new List           |            |
|   𐄂   | Archive all Cards in List   |            |
|   𐄂   | Move all Cards in List      |            |
|   𐄂   | Archive or unarchive a list |            |
|   𐄂   | Move List to Board          |            |
|   𐄂   | Update a field on a List    |            |
|   𐄂   | Get Actions for a List      |            |
|   𐄂   | Get the Board a List is on  |            |
|   ✔   | Get Cards in a List         | .cards.get |

## Members

| Status | Label                                          | .members    |
|:------:|:-----------------------------------------------|-------------|
|   𐄂   | Get a Member                                   |             |
|   𐄂   | Update a Member                                |             |
|   𐄂   | Get a field on a Member                        |             |
|   𐄂   | Get a Member's Actions                         |             |
|   𐄂   | Get Member's custom Board backgrounds          |             |
|   𐄂   | Upload new boardBackground for Member          |             |
|   𐄂   | Get a boardBackground of a Member              |             |
|   𐄂   | Update a Member's custom Board background      |             |
|   𐄂   | Delete a Member's custom Board background      |             |
|   𐄂   | Get a Member's boardStars                      |             |
|   𐄂   | Create Star for Board                          |             |
|   𐄂   | Get a boardStar of Member                      |             |
|   𐄂   | Update the position of a boardStar of Member   |             |
|   𐄂   | Delete Star for Board                          |             |
|   ✔   | Get Boards that Member belongs to              | .boards.get |
|   𐄂   | Get Boards the Member has been invited to      |             |
|   𐄂   | Get Cards the Member is on                     |             |
|   𐄂   | Get a Member's custom Board Backgrounds        |             |
|   𐄂   | Create a new custom Board Background           |             |
|   𐄂   | Get custom Board Background of Member          |             |
|   𐄂   | Update custom Board Background of Member       |             |
|   𐄂   | Delete custom Board Background of Member       |             |
|   𐄂   | Get a Member's customEmojis                    |             |
|   𐄂   | Create custom Emoji for Member                 |             |
|   𐄂   | Get a Member's custom Emoji                    |             |
|   𐄂   | Get Member's custom Stickers                   |             |
|   𐄂   | Create custom Sticker for Member               |             |
|   𐄂   | Get a Member's custom Sticker                  |             |
|   𐄂   | Delete a Member's custom Sticker               |             |
|   𐄂   | Get Member's Notifications                     |             |
|   𐄂   | Get Member's Organizations                     |             |
|   𐄂   | Get Organizations a Member has been invited to |             |
|   𐄂   | Get Member's saved searched                    |             |
|   𐄂   | Create saved Search for Memer                  |             |
|   𐄂   | Get a saved search                             |             |
|   𐄂   | Update a saved search                          |             |
|   𐄂   | Delete a saved search                          |             |
|   𐄂   | Get Member's Tokens                            |             |
|   𐄂   | Create Avatar for Member                       |             |
|   𐄂   | Dismiss a message for Member                   |             |

## Notifications

| Status | Label                                                    |
|:------:|:---------------------------------------------------------|
|   𐄂   | Get a Notification                                       |
|   𐄂   | Update a Notification's read status                      |
|   𐄂   | Get a field of a Notification                            |
|   𐄂   | Mark all Notifications as read                           |
|   𐄂   | Update Notification's read status                        |
|   𐄂   | Get the Board a Notification is on                       |
|   𐄂   | Get the Card a Notification is on                        |
|   𐄂   | Get the List a Notification is on                        |
|   𐄂   | Get the Member a Notification is about (not the creator) |
|   𐄂   | Get the Member who created the Notification              |
|   𐄂   | Get a Notification's associated Organization             |

## Organizations

| Status | Label                                                                      |
|:------:|:---------------------------------------------------------------------------|
|   𐄂   | Create a new Organization                                                  |
|   𐄂   | Get an Organization                                                        |
|   𐄂   | Update an Organization                                                     |
|   𐄂   | Delete an Organization                                                     |
|   𐄂   | Get field on Organization                                                  |
|   𐄂   | Get Actions for Organization                                               |
|   𐄂   | Get Boards in an Organization                                              |
|   𐄂   | Retrieve Organization's Exports                                            |
|   𐄂   | Create Export for Organizations                                            |
|   𐄂   | Get the Members of an Organization                                         |
|   𐄂   | Update an Organization's Members                                           |
|   𐄂   | Get Memberships of an Organization                                         |
|   𐄂   | Get a Membership of an Organization                                        |
|   𐄂   | Get the pluginData Scoped to Organization                                  |
|   𐄂   | Get Tags of an Organization                                                |
|   𐄂   | Create a Tag in Organization                                               |
|   𐄂   | Update a Member of an Organization                                         |
|   𐄂   | Remove a Member from an Organization                                       |
|   𐄂   | Deactivate or reactivate a member of an Organization                       |
|   𐄂   | Update logo for an Organization                                            |
|   𐄂   | Delete Logo for Organization                                               |
|   𐄂   | Remove a Member from an Organization and all Organization Boards           |
|   𐄂   | Remove the associated Google Apps domain from a Workspace                  |
|   𐄂   | Delete the email domain restriction on who can be invited to the Workspace |
|   𐄂   | Delete an Organization's Tag                                               |
|   𐄂   | Get Organizations new billable guests                                      |

## Plugins

| Status | Label                                  |
|:------:|:---------------------------------------|
|   𐄂   | Get a Plugin                           |
|   𐄂   | Update a Plugin                        |                        
|   𐄂   | Create a Listing for Plugin            |
|   𐄂   | Get Plugin's Member privacy compliance |
|   𐄂   | Updating Plugin's Listing              |

## Search

| Status | Label              |
|:------:|:-------------------|
|   𐄂   | Search Trello      |
|   𐄂   | Search for Members |

## Tokens

| Status | Label                              |
|:------:|:-----------------------------------|
|   𐄂   | Get a Token                        |
|   𐄂   | Get Token's Member                 |
|   𐄂   | Get Webhooks for Token             |
|   𐄂   | Create Webhooks for Token          |
|   𐄂   | Get a Webhook belonging to a Token |
|   𐄂   | Update a Webhook created by Token  |
|   𐄂   | Delete a Webhook created by Token  |
|   𐄂   | Delete a Token                     |

## Webhooks

| Status | Label                    |
|:------:|:-------------------------|
|   𐄂   | Create a Webhook         |
|   𐄂   | Get a Webhook            |
|   𐄂   | Update a Webhook         |
|   𐄂   | Delete a Webhook         |
|   𐄂   | Get a field on a Webhook |
