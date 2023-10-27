import 'dart:async';

import 'package:ansicolor/ansicolor.dart';
import 'package:logging/logging.dart';

/// Emit a log event to terminal.
///
/// This function was designed to map closely to the logging information
/// collected by `package:logging`.
///
/// - [message] is the log message
/// - [time] (optional) is the timestamp
/// - [sequenceNumber] (optional) is a monotonically increasing sequence number
/// - [level] (optional) is the severity level (a value between 0 and 2000); see
///   the `package:logging` `Level` class for an overview of the possible values
/// - [name] (optional) is the name of the source of the log message
/// - [zone] (optional) the zone where the log was emitted
/// - [error] (optional) an error object associated with this log event
/// - [stackTrace] (optional) a stack trace associated with this log event
void logWithTerminal(
  String message, {
  DateTime? time,
  int? sequenceNumber,
  Level level = Level.ALL,
  String name = '',
  Zone? zone,
  Object? error,
  StackTrace? stackTrace,
}) {
  final sb = StringBuffer();
  final leveledMessage = _levelMessage(message, level);
  sb.write(leveledMessage);
  if (error != null) {
    final leveledError = _levelMessage('$error', level);
    sb.write('\n$leveledError');
  }
  if (error != null) {
    final leveledStackTrace = _levelMessage('$stackTrace', level);
    sb.write('\n$leveledStackTrace');
  }
  print(
    '$sb',
    // time: time,
    // sequenceNumber: sequenceNumber,
    // level: level.value,
    // name: name,
    // zone: zone,
    // error: error,
    // stackTrace: stackTrace,
  );
}

List<int> get _finestColors {
  final colors = <int>[];
  for (var g = 0; g < 6; g++) {
    final color = _xtermColor(5, g, 0);
    colors.add(color);
  }
  for (var r = 4; r >= 0; r--) {
    final color = _xtermColor(r, 5, 0);
    colors.add(color);
  }
  for (var b = 1; b < 6; b++) {
    final color = _xtermColor(0, 5, b);
    colors.add(color);
  }
  for (var g = 4; g >= 0; g--) {
    final color = _xtermColor(0, g, 5);
    colors.add(color);
  }
  for (var r = 1; r < 6; r++) {
    final color = _xtermColor(r, 0, 5);
    colors.add(color);
  }
  for (var b = 4; b >= 0; b--) {
    final color = _xtermColor(5, 0, b);
    colors.add(color);
  }
  return colors;
}

List<int> get _finerColors => [196, 202, 208, 214, 220, 226];
List<int> get _fineColors => [21, 27, 33, 39, 45, 51];
List<int> get _configColors => [14];
List<int> get _infoColors => [10];
List<int> get _warningColors => [11];
List<int> get _severeColors => [9];
List<int> get _shoutColors => [13];

int _xtermColor(int r, int g, int b) => r * 36 + g * 6 + b + 16;

String _levelMessage(String message, Level level) {
  final String leveledMessage;
  final pen = AnsiPen();
  switch (level) {
    case Level.FINEST:
      leveledMessage = pen.writeWithColors(
        message,
        colors: _finestColors,
      );
      break;
    case Level.FINER:
      leveledMessage = pen.writeWithColors(
        message,
        colors: _finerColors,
      );
      break;
    case Level.FINE:
      leveledMessage = pen.writeWithColors(
        message,
        colors: _fineColors,
      );
      break;
    case Level.CONFIG:
      leveledMessage = pen.writeWithColors(
        message,
        colors: _configColors,
      );
      break;
    case Level.INFO:
      leveledMessage = pen.writeWithColors(
        message,
        colors: _infoColors,
      );
      break;
    case Level.WARNING:
      leveledMessage = pen.writeWithColors(
        message,
        colors: _warningColors,
      );
      break;
    case Level.SEVERE:
      leveledMessage = pen.writeWithColors(
        message,
        colors: _severeColors,
      );
      break;
    case Level.SHOUT:
      leveledMessage = pen.writeWithColors(
        message,
        colors: _shoutColors,
      );
      break;
    default:
      leveledMessage = message;
      break;
  }
  return leveledMessage;
}

extension on AnsiPen {
  String writeWithColors(
    String message, {
    required List<int> colors,
  }) {
    if (colors.isEmpty) {
      return write(message);
    }
    final color = colors.singleOrNull;
    if (color != null) {
      xterm(color);
      return write(message);
    }
    return message.splitMapJoin(
      RegExp(r'[\r\n]'),
      onMatch: (m) => '${m[0]}',
      onNonMatch: (n) {
        final sb = StringBuffer();
        for (var i = 0; i < n.length; i++) {
          final j = i % colors.length;
          final char = n[i];
          final color = colors[j];
          xterm(color);
          final ansiChar = write(char);
          sb.write(ansiChar);
        }
        return sb.toString();
      },
    );
  }
}
