import 'terminal.dart';

Terminal createTerminal() {
  throw UnsupportedError(
      "Can't create a terminal without dart:html or dart:io.");
}
