import 'package:flutter/material.dart';

extension GetArguement on BuildContext {
  T? getArguement<T>() {
    final modalroute = ModalRoute.of(this);
    if (modalroute != null) {
      final args = modalroute.settings.arguments;
      if (args != null) {
        return args as T;
      }
    }
    return null;
  }
}
