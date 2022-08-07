import 'dart:io';

import 'package:intl/intl.dart';

class MyDateFormat {
  String localeFormat(DateTime dateTime) {
    return DateFormat.yMMMMd(Platform.localeName).format(dateTime);
  }
}
