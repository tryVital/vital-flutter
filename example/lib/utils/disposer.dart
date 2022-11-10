import 'package:disposebag/disposebag.dart';
import 'package:flutter/material.dart';

mixin Disposer implements ChangeNotifier {
  @protected
  final DisposeBag disposeBag = DisposeBag();

  @override
  void dispose() {
    disposeBag.dispose();
  }
}
