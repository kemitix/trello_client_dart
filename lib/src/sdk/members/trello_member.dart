import '../trello_object.dart' show TrelloObject;
import 'member_id.dart';
import 'member_models.dart' show MemberFields;

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
