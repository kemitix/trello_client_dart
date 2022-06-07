/// 'default' is a reserved word, so is here in uppercase
/// use the names in lowercase to get correct form
enum BoardBackgrounds {
  all,
  custom,
  defaulT,
  none,
  premium;
}

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
