import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

EventTransformer<T> debounce<T>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
}

/// An extension on [Ref] with helpful methods to add a debounce.
extension RefDebounceExtension on Ref {
  /// Delays an execution by a bit such that if a dependency changes multiple
  /// time rapidly, the rest of the code is only run once.
  Future<void> debounce(Duration duration) {
    final completer = Completer<void>();
    final timer = Timer(duration, () {
      if (!completer.isCompleted) completer.complete();
    });
    onDispose(() {
      timer.cancel();
      if (!completer.isCompleted) {
        completer.completeError(StateError('Cancelled'));
      }
    });
    return completer.future;
  }
}

class Debouncer {
  final Duration duration;
  Timer? _timer;

  Debouncer({required this.duration});

  void run(VoidCallback action) {
    if (_timer != null) {
      print("Cancelled.");
      _timer!.cancel();
    }
    _timer = Timer(duration, action);
  }
}
