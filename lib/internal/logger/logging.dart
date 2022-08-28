import 'package:logger/logger.dart';

class Logging {
  static Logger? _logger;

  static Logger logger() {
    _logger ??= Logger(
      printer: PrettyPrinter(
        colors: true,
        printTime: true,
      ),
    );
    return _logger!;
  }
}
