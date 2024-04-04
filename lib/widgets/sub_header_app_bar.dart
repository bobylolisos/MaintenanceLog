import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maintenance_log/resources/colors.dart';
import 'package:maintenance_log/widgets/wave_clipper.dart';

// ignore: non_constant_identifier_names
PreferredSizeWidget SubHeaderAppBar(
    {required String title, GestureTapCallback? onTrailingAddTap}) {
  return AppBar(
    backgroundColor: colorBlue,
    foregroundColor: colorGold,
    shadowColor: Colors.transparent,
    toolbarHeight: 120,
    flexibleSpace: SafeArea(
      child: Container(
        color: colorLightGrey,
        child: ClipPath(
          clipper: WaveClipper(),
          child: Container(
            color: colorBlue,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 80),
                      child: Text(
                        title,
                        style: TextStyle(color: colorGold, fontSize: 25),
                      ),
                    ),
                  ),
                ),
                onTrailingAddTap != null
                    ? InkWell(
                        onTap: onTrailingAddTap,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 30, top: 10, bottom: 10),
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: FaIcon(
                                FontAwesomeIcons.plus,
                                size: 25,
                                color: colorGold,
                              )),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
