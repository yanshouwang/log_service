import 'package:logging/logging.dart';

import 'log_controller.dart';

/// Implements the [LogController] interface with a logger instance.
mixin LoggerController implements LogController {
  /// The logger instance to be controlled.
  Logger get logger;

  @override
  Level get logLevel => logger.level;
  @override
  set logLevel(Level? value) => logger.level = value;
}
