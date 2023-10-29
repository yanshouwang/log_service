import 'dart:async';

import 'package:log_service/log_service.dart';

void main() {
  ansiColorDisabled = false;
  // hierarchicalLoggingEnabled = true;
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen(onRecord);
  final messenger = Messenger();
  // messenger.logLevel = Level.WARNING;
  messenger.logMessage(Level.FINEST);
  messenger.logMessage(Level.FINER);
  messenger.logMessage(Level.FINE);
  messenger.logMessage(Level.CONFIG);
  messenger.logMessage(Level.INFO);
  messenger.logMessage(Level.WARNING);
  messenger.logMessage(Level.SEVERE);
  messenger.logMessage(Level.SHOUT);
}

void onRecord(LogRecord record) {
  logToTerminal(
    record.message,
    time: record.time,
    sequenceNumber: record.sequenceNumber,
    level: record.level,
    name: record.loggerName,
    zone: record.zone,
    error: record.error,
    stackTrace: record.stackTrace,
  );
}

class Messenger with LogService {
  void logMessage(Level level) {
    switch (level) {
      case Level.FINEST:
        finest('This is a `FINEST` message.');
        break;
      case Level.FINER:
        finer('This is a `FINER` message.');
        break;
      case Level.FINE:
        fine('This is a `FINE` message.');
        break;
      case Level.CONFIG:
        config('This is a `CONFIG` message.');
        break;
      case Level.INFO:
        info('This is a `INFO` message.');
        break;
      case Level.WARNING:
        try {
          throw FormatException('This is a `WARNING` message.');
        } catch (error, stackTrace) {
          warning('$error', error, stackTrace);
        }
        break;
      case Level.SEVERE:
        try {
          throw TimeoutException('This is a `SERVER` message.');
        } catch (error, stackTrace) {
          severe('$error', error, stackTrace);
        }
        break;
      case Level.SHOUT:
        try {
          throw UnsupportedError('This is a `SHOUT` message.');
        } catch (error, stackTrace) {
          shout('$error', error, stackTrace);
        }
        break;
      default:
        break;
    }
  }
}
