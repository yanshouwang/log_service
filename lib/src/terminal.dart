import 'dart:async';

import 'package:ansicolor/ansicolor.dart';
import 'package:logging/logging.dart';

import 'terminal_stub.dart'
    if (dart.library.html) 'terminal_html.dart'
    if (dart.library.io) 'terminal_io.dart';

/// The terminal instance.
final terminal = Terminal._();

/// Terminal class.
abstract class Terminal {
  factory Terminal._() => createTerminal();

  /// Writes object to the terminal.
  void write(Object object);
}

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
void logToTerminal(
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
  time ??= DateTime.now();
  final title = '[$time: $name -> ${level.name}]';
  final leveledTitle = _levelValue(
    title,
    level: level,
  );
  sb.write(leveledTitle);
  final leveledMessage = _levelValue(
    message,
    level: level,
  );
  sb.write('\n$leveledMessage');
  if (error != null) {
    final leveledError = _levelValue(
      '$error',
      level: level,
    );
    sb.write('\n$leveledError');
  }
  if (stackTrace != null) {
    final leveledStackTrace = _levelValue(
      '$stackTrace',
      level: level,
    );
    sb.write('\n$leveledStackTrace');
  }
  terminal.write('$sb');
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

String _levelValue(
  String value, {
  required Level level,
}) {
  final String leveledValue;
  final pen = AnsiPen();
  switch (level) {
    case Level.FINEST:
      leveledValue = pen.writeWithColors(
        value,
        colors: _finestColors,
      );
      break;
    case Level.FINER:
      leveledValue = pen.writeWithColors(
        value,
        colors: _finerColors,
      );
      break;
    case Level.FINE:
      leveledValue = pen.writeWithColors(
        value,
        colors: _fineColors,
      );
      break;
    case Level.CONFIG:
      leveledValue = pen.writeWithColors(
        value,
        colors: _configColors,
      );
      break;
    case Level.INFO:
      leveledValue = pen.writeWithColors(
        value,
        colors: _infoColors,
      );
      break;
    case Level.WARNING:
      leveledValue = pen.writeWithColors(
        value,
        colors: _warningColors,
      );
      break;
    case Level.SEVERE:
      leveledValue = pen.writeWithColors(
        value,
        colors: _severeColors,
      );
      break;
    case Level.SHOUT:
      leveledValue = pen.writeWithColors(
        value,
        colors: _shoutColors,
      );
      break;
    default:
      leveledValue = pen.writeWithColors(
        value,
        colors: [],
      );
      break;
  }
  return leveledValue;
}

extension on AnsiPen {
  String writeWithColors(
    String value, {
    required List<int> colors,
  }) {
    if (colors.isEmpty) {
      return write(value);
    }
    final color = colors.singleOrNull;
    if (color != null) {
      xterm(color);
      return write(value);
    }
    return value.splitMapJoin(
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
