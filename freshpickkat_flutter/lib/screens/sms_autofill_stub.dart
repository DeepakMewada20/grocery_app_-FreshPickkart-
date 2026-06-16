import 'package:flutter/widgets.dart';

mixin CodeAutoFill<T extends StatefulWidget> on State<T> {
  String? get code => null;

  void listenForCode() {}

  void codeUpdated() {}

  void cancel() {}
}
