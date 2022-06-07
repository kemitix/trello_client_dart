enum AllOrNone { all, none }

enum OpenClosedFilter { all, closed, none, open }

enum OpenClosedVisibleFilter { all, closed, none, open, visible }

typedef CardFilter = OpenClosedFilter;
typedef ListFilter = OpenClosedFilter;

enum MembersPublic { all, members, none, public }

typedef Organizations = MembersPublic;

enum OrganizationFields { all, id, name }

typedef OrganizationsInvited = MembersPublic;

typedef OrganizationsInvitedFields = OrganizationFields;
