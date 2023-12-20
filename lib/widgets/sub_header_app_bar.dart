import 'package:flutter/material.dart';
import 'package:maintenance_log/resources/colors.dart';
import 'package:maintenance_log/widgets/wave_clipper.dart';

// ignore: non_constant_identifier_names
PreferredSizeWidget SubHeaderAppBar({required String title}) {
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
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 80),
                child: Text(
                  title,
                  style: TextStyle(color: colorGold, fontSize: 30),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
