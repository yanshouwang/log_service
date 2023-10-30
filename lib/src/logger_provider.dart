import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

/// Provides a logger instance.
mixin LoggerProvider {
  /// The logger instance.
  @protected
  Logger get logger => Logger('$runtimeType');
}
