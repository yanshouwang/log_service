import 'dart:io';

import 'terminal.dart';

Terminal createTerminal() => _Terminal();

class _Terminal implements Terminal {
  @override
  void write(Object object) {
    stdout.write(object);
  }
}
