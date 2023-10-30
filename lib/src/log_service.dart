import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

import 'log_controller.dart';

/// Provides a logger instance and implements the [LogController] interface.
mixin LogService implements LogController {
  @protected
  Logger get logger => Logger('$runtimeType');

  @override
  Level get logLevel => logger.level;
  @override
  set logLevel(Level? value) => logger.level = value;
}
