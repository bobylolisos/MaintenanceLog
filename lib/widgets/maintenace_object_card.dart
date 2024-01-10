import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maintenance_log/models/maintenance_object.dart';
import 'package:maintenance_log/resources/colors.dart';

class MaintenanceObjectCard extends StatelessWidget {
  final MaintenanceObject maintenanceObject;
  final GestureTapCallback? onTap;
  final Widget? trailing;

  const MaintenanceObjectCard(
      {required this.maintenanceObject,
      required this.onTap,
      this.trailing,
      super.key});

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
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                  width: 1.0,
                                ),
                              ),
                              child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                foregroundColor: colorBlue,
                                child: FaIcon(
                                  FontAwesomeIcons.image,
                                  size: 25,
                                ),
                              ),
                            ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            maintenanceObject.name,
                            overflow: TextOverflow.ellipsis,
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
                      ),
                    ),
                    trailing != null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              trailing!,
                            ],
                          )
                        : Container(),
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
