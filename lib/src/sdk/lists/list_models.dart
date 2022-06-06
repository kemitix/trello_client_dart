import '../client.dart' show StringValue;

class ListId extends StringValue {
  ListId(id) : super(id);
}

enum ListFields {
  all,
  id,
  name,
  closed,
  idBoard,
  pos,
  subscribed,
}

enum ListFilter {
  all,
  closed,
  none,
  open,
}
