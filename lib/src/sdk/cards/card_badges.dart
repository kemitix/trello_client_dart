import 'package:equatable/equatable.dart' show EquatableMixin;

class CardBadges with EquatableMixin {
  late int votes;
  late bool viewingMemberVoted;
  late bool subscribed;
  late String fogbugz;
  late int checkItems;
  late int checkItemsChecked;
  late int comments;
  late int attachments;
  late bool description;
  late DateTime due;
  late bool dueComplete;

  CardBadges(
      this.votes,
      this.viewingMemberVoted,
      this.subscribed,
      this.fogbugz,
      this.checkItems,
      this.checkItemsChecked,
      this.comments,
      this.attachments,
      this.description,
      this.due,
      this.dueComplete);

  @override
  List<Object?> get props => [
        votes,
        viewingMemberVoted,
        subscribed,
        fogbugz,
        checkItems,
        checkItemsChecked,
        comments,
        attachments,
        description,
        due,
        dueComplete
      ];
}
