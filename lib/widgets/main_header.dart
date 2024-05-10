import 'package:flutter/material.dart';
import 'package:maintenance_log/resources/colors.dart';
import 'package:maintenance_log/widgets/wave_clipper.dart';

class MainHeader extends StatelessWidget {
  const MainHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: WaveClipper(),
      child: Container(
        height: 160,
        color: colorBlue,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
              child: Image.asset(
                'assets/logo_foreground.png',
                height: 100,
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
                      style: TextStyle(color: colorGold, fontSize: 26),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Column(
                      children: [
                        Text(
                          'Keep track of your expenses, maintenances',
                          style: TextStyle(color: colorGold, fontSize: 10),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          'and upcoming tasks',
                          maxLines: 2,
                          style: TextStyle(color: colorGold, fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Builder(builder: (context) {
              return InkWell(
                onTap: () {
                  Scaffold.of(context).openEndDrawer();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 25),
                  child: Icon(
                    Icons.menu,
                    color: colorGold,
                    size: 35,
                  ),
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}
