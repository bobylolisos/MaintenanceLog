import 'package:cached_network_image/cached_network_image.dart';
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
          splashColor: colorGold.withOpacity(0.4),
          highlightColor: Colors.transparent,
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
                              child: CachedNetworkImage(
                                imageUrl: maintenanceObject.images.first,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Center(
                                  child: SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: const CircularProgressIndicator()),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
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
                            maintenanceObject.header,
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
                            maintenanceObject.subHeader,
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
                        : const SizedBox(),
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
