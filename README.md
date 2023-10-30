<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

# log_service

A Dart package for simplify the usage of the official `logging` package.

## Features

- LogController: An interface for controlling the logger instance.
- LogService: A mixin provides `logging#Logger`'s methods and implements the `LogController` interface, which can be mixed into any class.

## Getting started

Add `log_service` as a [dependency in your pubspec.yaml file](https://dart.dev/guides/packages).

```
dependencies:
  log_service: ^<latest-version>
```

## Usage

### 1. Log Levels

The log level is folling the `logging`'s strategy, the `logLevel` is inheirted from the `Logger.root` instance and can only be changed through the `Logger.root` instance by default.

Sets `hierarchicalLoggingEnabled = true` to enable hierarchical logging, then use the `logLevel` of the `LogController` interface to set log level for each `LogSerivice`.

### 2. Log Events

Listen the `Logger.root.onRecord` stream to get log events.

### 3. Log Methods

- shout();
- severe();
- warning();
- info();
- config();
- fine();
- finer();
- finest();

## Additional information

Get more tips form the [`logging`][1] framework.

[1]: https://pub.dev/packages/logging