import 'dart:async';
import 'dart:io';

import 'package:log_service/log_service.dart';

void main() {
  ansiColorDisabled = false;
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen(onRecord);
  final messenger = Messenger();
  final duration = Duration(seconds: 1);
  messenger.sayHello(Level.FINEST);
  sleep(duration);
  messenger.sayHello(Level.FINER);
  sleep(duration);
  messenger.sayHello(Level.FINE);
  sleep(duration);
  messenger.sayHello(Level.CONFIG);
  sleep(duration);
  messenger.sayHello(Level.INFO);
  sleep(duration);
  messenger.sayHello(Level.WARNING);
  sleep(duration);
  messenger.sayHello(Level.SEVERE);
  sleep(duration);
  messenger.sayHello(Level.SHOUT);
  sleep(duration);
}

void onRecord(LogRecord record) {
  logWithTerminal(
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
  void sayHello(Level level) {
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
