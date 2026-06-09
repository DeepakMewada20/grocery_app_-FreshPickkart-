import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/admin_app_theme.dart';

Future<bool?> showConfirmActionDialog({
  required BuildContext context,
  required String title,
  required String content,
  String confirmLabel = 'Delete',
  String cancelLabel = 'Cancel',
  Color? confirmColor,
  bool useElevatedButton = false,
  required Future<bool?> Function() onConfirm,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      var isLoading = false;
      return StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: isLoading ? null : () => Navigator.pop(context, false),
              child: Text(cancelLabel),
            ),
            useElevatedButton
                ? ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            setDialogState(() => isLoading = true);
                            try {
                              final result = await onConfirm();
                              if (context.mounted) {
                                Navigator.pop(context, result);
                              }
                            } catch (_) {
                              if (context.mounted) {
                                Navigator.pop(context, false);
                              }
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          confirmColor ?? AdminAppTheme.getErrorColor(context),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(confirmLabel),
                  )
                : TextButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            setDialogState(() => isLoading = true);
                            try {
                              final result = await onConfirm();
                              if (context.mounted) {
                                Navigator.pop(context, result);
                              }
                            } catch (_) {
                              if (context.mounted) {
                                Navigator.pop(context, false);
                              }
                            }
                          },
                    child: isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            confirmLabel,
                            style: TextStyle(
                              color:
                                  confirmColor ?? AdminAppTheme.getErrorColor(context),
                            ),
                          ),
                  ),
          ],
        ),
      );
    },
  );
}

Future<bool> showDeactivationDialog({
  required String title,
  required String message,
}) async {
  return await Get.defaultDialog<bool>(
    title: title,
    middleText: '$message\n\nDo you want to deactivate this?',
    textCancel: 'Cancel',
    textConfirm: 'Deactivate',
    onConfirm: () => Get.back(result: true),
  ) ?? false;
}

void showUndoSnackBar(
  BuildContext context, {
  required String message,
  required VoidCallback onUndo,
}) {
  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: onUndo,
        ),
      ),
    );
}


