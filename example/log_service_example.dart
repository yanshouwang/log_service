import 'dart:async';
import 'dart:developer';

import 'package:log_service/log_service.dart';

void main() {
  // hierarchicalLoggingEnabled = true;
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen(onRecord);
  final creator = LogCreator();
  // messenger.logLevel = Level.WARNING;
  creator.create(Level.FINEST);
  creator.create(Level.FINER);
  creator.create(Level.FINE);
  creator.create(Level.CONFIG);
  creator.create(Level.INFO);
  creator.create(Level.WARNING);
  creator.create(Level.SEVERE);
  creator.create(Level.SHOUT);
}

void onRecord(LogRecord record) {
  log(
    record.message,
    time: record.time,
    sequenceNumber: record.sequenceNumber,
    level: record.level.value,
    name: record.loggerName,
    zone: record.zone,
    error: record.error,
    stackTrace: record.stackTrace,
  );
}

class LogCreator with LogService {
  void create(Level level) {
    final message = 'This is a `${level.name}` message';
    switch (level) {
      case Level.FINEST:
        finest(message);
        break;
      case Level.FINER:
        finer(message);
        break;
      case Level.FINE:
        fine(message);
        break;
      case Level.CONFIG:
        config(message);
        break;
      case Level.INFO:
        info(message);
        break;
      case Level.WARNING:
        try {
          throw FormatException(message);
        } catch (error, stackTrace) {
          warning(message, error, stackTrace);
        }
        break;
      case Level.SEVERE:
        try {
          throw TimeoutException(message);
        } catch (error, stackTrace) {
          severe(message, error, stackTrace);
        }
        break;
      case Level.SHOUT:
        try {
          throw UnsupportedError(message);
        } catch (error, stackTrace) {
          shout(message, error, stackTrace);
        }
        break;
      default:
        break;
    }
  }
}
