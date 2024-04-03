import 'package:flutter/material.dart';
import 'package:maintenance_log/resources/colors.dart';

class BlsBottomSheet extends StatelessWidget {
  final String title;
  final String okText;
  final VoidCallback onOkPressed;
  final String? cancelText;
  final VoidCallback? onCancelPressed;
  final Widget child;

  const BlsBottomSheet(
      {required this.title,
      required this.okText,
      required this.onOkPressed,
      this.cancelText,
      this.onCancelPressed,
      required this.child,
      super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 80,
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  title,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: colorGold),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 60,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              alignment: Alignment.topCenter,
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(top: 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      child,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          onCancelPressed != null
                              ? SizedBox(
                                  width: 130,
                                  child: ElevatedButton(
                                    style: TextButton.styleFrom(
                                        backgroundColor:
                                            colorGold.withOpacity(0.5),
                                        foregroundColor: colorBlue),
                                    onPressed: onCancelPressed,
                                    child: Text(cancelText ?? 'Cancel'),
                                  ),
                                )
                              : Container(),
                          SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: 130,
                            // height: 60,
                            child: ElevatedButton(
                              style: TextButton.styleFrom(
                                  backgroundColor: colorBlue,
                                  foregroundColor: colorGold),
                              onPressed: onOkPressed,
                              child: Text(okText),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
