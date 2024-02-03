import 'package:flutter/material.dart';
import 'package:maintenance_log/resources/colors.dart';

class MaintenanceObjectItemCard extends StatelessWidget {
  final String title;
  final Widget child;
  final GestureTapCallback? onTap;
  final Widget? trailing;
  final CrossAxisAlignment trailingVerticalAlignment;
  final int? postCount;
  final EdgeInsetsGeometry? margins;

  const MaintenanceObjectItemCard(
      {required this.title,
      required this.child,
      this.postCount,
      this.onTap,
      this.trailing,
      this.trailingVerticalAlignment = CrossAxisAlignment.center,
      this.margins,
      super.key});

  @override
  Widget build(BuildContext context) {
    final card = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title container
        Row(
          children: [
            Container(
              height: 27,
              width: 180,
              decoration: BoxDecoration(
                color: colorBlue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 3),
                child: Text(
                  title,
                  style: TextStyle(color: colorGold, fontSize: 18),
                ),
              ),
            ),
            postCount != null
                ? Container(
                    margin: EdgeInsets.only(left: 2),
                    height: 27,
                    width: 50,
                    decoration: BoxDecoration(
                      color: colorBlue,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Center(
                        child: Text(
                          postCount.toString(),
                          style: TextStyle(color: colorGold, fontSize: 18),
                        ),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),

        // Content container
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(2, 4), // changes position of shadow
              ),
            ],
          ),
          child: Material(
            color: Colors.white,
            child: InkWell(
              splashColor: colorGold.withOpacity(0.4),
              highlightColor: Colors.transparent,
              onTap: onTap,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    )),
                constraints: BoxConstraints(
                  // minHeight: 100,
                  minWidth: double.infinity,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, top: 8, right: 8, bottom: 8),
                  child: Row(
                    crossAxisAlignment: trailingVerticalAlignment,
                    children: [
                      Expanded(
                          child: Container(
                              alignment: Alignment.topLeft,
                              constraints: BoxConstraints(
                                minHeight: 40,
                                minWidth: double.infinity,
                              ),
                              child: child)),
                      trailing != null
                          ? SizedBox(
                              width: 10,
                            )
                          : Container(),
                      trailing != null ? trailing! : Container()
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );

    if (margins != null) {
      return Padding(
        padding: margins!,
        child: card,
      );
    }

    return card;
  }
}
