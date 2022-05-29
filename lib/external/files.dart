import 'dart:io' show File, FileMode;

import 'package:trello_sdk/src/sdk/cards/card_models.dart' show FileName;

Future<void> defaultFileWriter(FileName fileName, dynamic data) {
  var f = File(fileName.value).openSync(mode: FileMode.write);
  f.writeFromSync(data);
  return f.close();
}
