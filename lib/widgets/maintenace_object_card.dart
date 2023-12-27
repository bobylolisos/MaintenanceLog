import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maintenance_log/models/maintenance_object.dart';
import 'package:maintenance_log/resources/colors.dart';

class MaintenanceObjectCard extends StatelessWidget {
  final MaintenanceObject maintenanceObject;
  final GestureTapCallback? onTap;

  const MaintenanceObjectCard(
      {required this.maintenanceObject, required this.onTap, super.key});

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
          child: Hero(
            tag: maintenanceObject.id,
            child: Material(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 70,
                      height: 70,
                      child: maintenanceObject.images.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(35),
                              child: Image.network(
                                  fit: BoxFit.cover,
                                  maintenanceObject.images.first),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: colorBlue,
                                  width: 2.0,
                                ),
                              ),
                              child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                foregroundColor: colorBlue,
                                child: FaIcon(
                                  FontAwesomeIcons.car,
                                  size: 30,
                                ),
                              ),
                            ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          maintenanceObject.name,
                          style: TextStyle(
                              color: colorBlue,
                              fontSize: 24,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          maintenanceObject.shortDescription,
                          style: TextStyle(color: colorBlue, fontSize: 15),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
