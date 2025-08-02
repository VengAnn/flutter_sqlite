import 'package:flutter/material.dart';

class DialogCmp {
  /// Reusable dropdown dialog
  static Future<String?> showDropdownDialog({
    required BuildContext context,
    required String title,
    required List<String> items,
    String? selectedItem,
  }) async {
    String? currentValue = selectedItem;

    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: StatefulBuilder(
            builder: (context, setState) {
              return DropdownButtonFormField<String>(
                value: currentValue,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
                hint: const Text('Choose an option'),
                items: items.map((item) {
                  return DropdownMenuItem(value: item, child: Text(item));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    currentValue = value;
                  });
                },
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, currentValue),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  /// Reusable confirm dialog
  static Future<void> showConfirmDialog({
    required BuildContext context,
    Widget? title,
    required Widget content,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    String confirmText = 'Yes',
    String cancelText = 'No',
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: title,
        content: content,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
              onCancel?.call();
            },
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, true);
              onConfirm?.call();
            },
            child: Text(confirmText),
          ),
        ],
      ),
    );

    // Optional: handle result if no onConfirm/onCancel provided
    if (result == true && onConfirm == null) {
      // Default behavior if no onConfirm given
    } else if (result == false && onCancel == null) {
      // Default behavior if no onCancel given
    }
  }

  /// Fully customizable dialog
  static Future<T?> showCustomDialog<T>({
    required BuildContext context,
    Widget? title,
    required Widget content,
    List<Widget>? actions,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) =>
          AlertDialog(title: title, content: content, actions: actions),
    );
  }
}
