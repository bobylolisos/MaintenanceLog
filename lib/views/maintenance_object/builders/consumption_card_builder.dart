import 'package:flutter/material.dart';
import 'package:maintenance_log/models/maintenance_object.dart';
import 'package:maintenance_log/resources/colors.dart';
import 'package:maintenance_log/widgets/maintenance_object_item_card.dart';

class ConsumptionCardBuilder {
  static Widget create(MaintenanceObject maintenanceObject) {
    return Builder(
      builder: (context) {
        final postCount = maintenanceObject.consumptions.length;
        // final avarageConsumption = _getConsumptions(maintenanceObject);
        return Text('Todo: ConsumptionCardBuilder');
        // return MaintenanceObjectItemCard(
        //   title: 'Förbrukning',
        //   postCount: postCount,
        //   onTap: () {},
        //   onAddTap: () {},
        //   child: Row(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       postCount > 0
        //           ? Column(
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               children: [
        //                 Text(
        //                   'Snittförbrukning',
        //                   style: TextStyle(
        //                       color: colorBlue, fontWeight: FontWeight.w600),
        //                 ),
        //                 Row(
        //                   children: [
        //                     SizedBox(
        //                       width: 70,
        //                       child: Text(
        //                         ' Lägsta:',
        //                         style:
        //                             TextStyle(color: colorBlue, fontSize: 14),
        //                       ),
        //                     ),
        //                     Text(
        //                       '${avarageConsumption.$1} l/m',
        //                       style: TextStyle(color: colorBlue, fontSize: 14),
        //                     ),
        //                   ],
        //                 ),
        //                 Row(
        //                   children: [
        //                     SizedBox(
        //                       width: 70,
        //                       child: Text(
        //                         ' Medel:',
        //                         style:
        //                             TextStyle(color: colorBlue, fontSize: 14),
        //                       ),
        //                     ),
        //                     Text(
        //                       '${avarageConsumption.$2} l/m',
        //                       style: TextStyle(color: colorBlue, fontSize: 14),
        //                     ),
        //                   ],
        //                 ),
        //                 Row(
        //                   children: [
        //                     SizedBox(
        //                       width: 70,
        //                       child: Text(
        //                         ' Högsta:',
        //                         style:
        //                             TextStyle(color: colorBlue, fontSize: 14),
        //                       ),
        //                     ),
        //                     Text(
        //                       '${avarageConsumption.$3} l/m',
        //                       style: TextStyle(color: colorBlue, fontSize: 14),
        //                     ),
        //                   ],
        //                 ),
        //               ],
        //             )
        //           : Container(),
        //       SizedBox(
        //         width: 30,
        //       ),
        //       postCount > 0
        //           ? Column(
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               children: [
        //                 Text(
        //                   'Föregående post',
        //                   style: TextStyle(
        //                       color: colorBlue, fontWeight: FontWeight.w600),
        //                 ),
        //                 Text(
        //                   ' ${maintenanceObject.consumptions.last.date.toString().substring(0, 10)}',
        //                   style: TextStyle(color: colorBlue, fontSize: 14),
        //                 ),
        //                 Text(
        //                   ' ${maintenanceObject.consumptions.last.trip} km',
        //                   style: TextStyle(color: colorBlue, fontSize: 14),
        //                 ),
        //                 Text(
        //                   ' ${maintenanceObject.consumptions.last.pricePerLitre} kr',
        //                   style: TextStyle(color: colorBlue, fontSize: 14),
        //                 ),
        //                 Text(
        //                   ' ${maintenanceObject.consumptions.last.litre} liter',
        //                   style: TextStyle(color: colorBlue, fontSize: 14),
        //                 ),
        //                 Text(
        //                   ' ${(maintenanceObject.consumptions.last.litre / (maintenanceObject.consumptions.last.trip / 10)).toStringAsFixed(2)} l/m',
        //                   style: TextStyle(color: colorBlue, fontSize: 14),
        //                 ),
        //               ],
        //             )
        //           : Container(),
        //     ],
        //   ),
        // );
      },
    );
  }

  // static (String lowest, String avarage, String highest) _getConsumptions(
  //     MaintenanceObject maintenanceObject) {
  //   num totalTrip = 0;
  //   num totalLitre = 0;

  //   num lowestAvarage = 0;
  //   num highestAvarage = 0;

  //   for (var i = 0; i < maintenanceObject.consumptions.length; i++) {
  //     final item = maintenanceObject.consumptions.elementAt(i);
  //     totalTrip += item.trip;
  //     totalLitre += item.litre;

  //     final currentAvarage = item.litre / (item.trip / 10);
  //     if (currentAvarage < lowestAvarage || lowestAvarage == 0) {
  //       lowestAvarage = currentAvarage;
  //     }
  //     if (currentAvarage > highestAvarage) {
  //       highestAvarage = currentAvarage;
  //     }
  //   }

  //   final avarage = totalLitre / (totalTrip / 10);
  //   return (
  //     lowestAvarage.toStringAsFixed(2),
  //     avarage.toStringAsFixed(2),
  //     highestAvarage.toStringAsFixed(2),
  //   );
  // }
}
