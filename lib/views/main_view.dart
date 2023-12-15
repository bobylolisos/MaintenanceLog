import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maintenance_log/resources/colors.dart';
import 'package:maintenance_log/views/about_view.dart';
import 'package:maintenance_log/views/home_view.dart';
import 'package:maintenance_log/views/manage_view.dart';
import 'package:maintenance_log/widgets/wave_clipper.dart';

class MainView extends StatelessWidget {
  MainView({super.key});

  final ValueNotifier<int> _selectedMenuItemNotifier = ValueNotifier<int>(0);

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
                                style:
                                    TextStyle(color: colorGold, fontSize: 28),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Keep track of your expenses, maintenance',
                                    style: TextStyle(
                                        color: colorGold, fontSize: 10),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    'and upcoming tasks',
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: colorGold, fontSize: 10),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: _selectedMenuItemNotifier,
                  builder: (BuildContext context, int value, Widget? child) {
                    if (value == 2) {
                      return AboutView();
                    }
                    if (value == 1) {
                      return ManageView();
                    }
                    return HomeView();
                  },
                ),
              ),
              RotatedBox(
                quarterTurns: 2,
                child: ClipPath(
                  clipper: WaveClipper(),
                  child: Container(
                    height: 30,
                    color: colorBlue,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: _selectedMenuItemNotifier,
        builder: (BuildContext context, int value, Widget? child) {
          return BottomNavigationBar(
              iconSize: 18,
              selectedFontSize: 16,
              currentIndex: _selectedMenuItemNotifier.value,
              backgroundColor: colorBlue,
              selectedItemColor: colorGold,
              unselectedItemColor: colorGold.withOpacity(0.5),
              onTap: (value) {
                _selectedMenuItemNotifier.value = value;
              },
              items: [
                BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: FaIcon(
                        FontAwesomeIcons.house,
                      ),
                    ),
                    label: 'Home'),
                BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: FaIcon(
                        FontAwesomeIcons.gear,
                      ),
                    ),
                    label: 'Manage'),
                BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: FaIcon(
                        FontAwesomeIcons.receipt,
                      ),
                    ),
                    label: 'About'),
              ]);
        },
      ),
    );
  }
}
