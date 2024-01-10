import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maintenance_log/resources/colors.dart';

class AddCard extends StatelessWidget {
  final String text;
  final String? subText;
  final GestureTapCallback? onTap;

  const AddCard(
      {required this.text, this.subText, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(2, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        // Material is used for click-splash-effect to work on inkwell
        child: InkWell(
          splashColor: colorGold,
          onTap: onTap,
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 70,
                    height: 70,
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      foregroundColor: colorGold,
                      child: FaIcon(
                        FontAwesomeIcons.plus,
                        size: 35,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          text,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: colorGold,
                              fontSize: 24,
                              fontWeight: FontWeight.w700),
                        ),
                        subText != null
                            ? Column(
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    subText!,
                                    style: TextStyle(
                                        color: colorGold, fontSize: 15),
                                  ),
                                ],
                              )
                            : Container()
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
