import 'package:flutter/material.dart';
import 'package:freshpickkat_admin/widgets/shared_dialogs.dart';

class AdminSnackbarService {
  static void show(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  static void showUndo(BuildContext context, String message,
      {required VoidCallback onUndo}) {
    showUndoSnackBar(context, message: message, onUndo: onUndo);
  }
}
