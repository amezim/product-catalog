import 'dart:async';

import 'package:flutter/material.dart';

class Debouncer {
  final Duration delay;
  Timer? timer;

  Debouncer(
    {required this.delay}
  );

  void run(VoidCallback action) {
    timer?.cancel();
    timer = Timer(delay, action);
  }

  void cancel() {
    timer?.cancel();
  }
}