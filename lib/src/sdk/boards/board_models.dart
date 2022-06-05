import '../client.dart';

class BoardId extends StringValue {
  BoardId(String id) : super(id);
}

enum BoardFields {
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
  //prefs,
  //labelNames,
  starred,
  //limits, -- https://developer.atlassian.com/cloud/trello/guides/rest-api/limits/
  memberships,
  enterpriseOwned
}
