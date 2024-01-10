import 'package:flutter/material.dart';
import 'package:maintenance_log/resources/colors.dart';

class BlsDialog extends StatelessWidget {
  final String title;
  final String okText;
  final VoidCallback onOkPressed;
  final String? cancelText;
  final VoidCallback? onCancelPressed;
  final Widget child;

  const BlsDialog(
      {required this.title,
      required this.okText,
      required this.onOkPressed,
      this.cancelText,
      this.onCancelPressed,
      required this.child,
      super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      insetPadding: EdgeInsets.all(24.0),
      title: Center(
        child: Text(
          title,
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w700, color: colorBlue),
        ),
      ),
      actions: [
        onCancelPressed != null
            ? SizedBox(
                width: 130,
                child: ElevatedButton(
                  style: TextButton.styleFrom(
                      backgroundColor: colorGold.withOpacity(0.5),
                      foregroundColor: colorBlue),
                  onPressed: onCancelPressed,
                  child: Text(cancelText ?? 'Cancel'),
                ),
              )
            : Container(),
        SizedBox(
          width: 130,
          child: ElevatedButton(
            style: TextButton.styleFrom(
                backgroundColor: colorBlue, foregroundColor: colorGold),
            onPressed: onOkPressed,
            child: Text(okText),
          ),
        ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: Builder(builder: (context) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Builder(builder: (context) {
            return SingleChildScrollView(
              child: child,
            );
          }),
        );
      }),
    );
  }
}
