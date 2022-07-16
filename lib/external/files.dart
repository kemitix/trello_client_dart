import 'dart:io' show File, FileMode;

import 'package:trello_client/trello_sdk.dart' show FileName;

Future<void> defaultFileWriter(FileName fileName, dynamic data) {
  var f = File(fileName.value).openSync(mode: FileMode.write);
  f.writeFromSync(data);
  return f.close();
}
