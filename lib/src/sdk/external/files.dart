import 'dart:io';

import '../cards/card_models.dart';

Future<void> defaultFileWriter(FileName fileName, dynamic data) {
  var f = File(fileName.value).openSync(mode: FileMode.write);
  f.writeFromSync(data);
  return f.close();
}
