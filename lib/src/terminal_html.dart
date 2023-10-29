import 'dart:html';

import 'terminal.dart';

Terminal createTerminal() => _Terminal();

class _Terminal implements Terminal {
  @override
  void write(Object object) {
    window.console.log(object);
  }
}
