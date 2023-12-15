import 'package:flutter/material.dart';
import 'package:maintenance_log/resources/colors.dart';
import 'package:maintenance_log/widgets/wave_clipper.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBlue,
      body: SafeArea(
          child: Container(
        color: Colors.grey[100],
        child: Column(
          children: [
            ClipPath(
              clipper: WaveClipper(),
              child: Container(
                height: 160,
                color: colorBlue,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/logo_foreground.png',
                        height: 120,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Maintenance log',
                              style: TextStyle(color: colorGold, fontSize: 28),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Column(
                              children: [
                                Text(
                                  'Keep track of your expenses, maintenance',
                                  style:
                                      TextStyle(color: colorGold, fontSize: 10),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  'and upcoming tasks',
                                  maxLines: 2,
                                  style:
                                      TextStyle(color: colorGold, fontSize: 10),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
