import 'package:flutter/material.dart';
import 'package:maintenance_log/resources/colors.dart';
import 'package:maintenance_log/widgets/sub_header_app_bar.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorLightGrey,
      appBar: SubHeaderAppBar(title: 'About'),
      body: Center(
        child: Text('About'),
      ),
    );
  }
}
