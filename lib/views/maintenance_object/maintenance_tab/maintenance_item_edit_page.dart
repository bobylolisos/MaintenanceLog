import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maintenance_log/blocs/maintenance_object_bloc/maintenance_object_bloc.dart';
import 'package:maintenance_log/blocs/maintenance_object_bloc/maintenance_object_event.dart';
import 'package:maintenance_log/extensions/date_time_extensions.dart';
import 'package:maintenance_log/models/maintenance.dart';
import 'package:maintenance_log/models/maintenance_item.dart';
import 'package:maintenance_log/models/maintenance_object.dart';
import 'package:maintenance_log/models/meter_type.dart';
import 'package:maintenance_log/resources/colors.dart';
import 'package:maintenance_log/setup/ioc.dart';
import 'package:maintenance_log/widgets/custom_date_time_picker.dart';
import 'package:maintenance_log/widgets/custom_numeric_form_field.dart';
import 'package:maintenance_log/widgets/custom_text_form_field.dart';
import 'package:maintenance_log/widgets/maintenance_object_item_card.dart';
import 'package:maintenance_log/widgets/sub_header_app_bar.dart';

class MaintenanceItemEditPage extends StatefulWidget {
  final MaintenanceObject maintenanceObject;
  final Maintenance maintenance;
  final MaintenanceItem maintenanceItem;

  const MaintenanceItemEditPage({
    required this.maintenanceObject,
    required this.maintenance,
    required this.maintenanceItem,
    super.key,
  });

  @override
  State<MaintenanceItemEditPage> createState() =>
      _MaintenanceItemEditPageState();
}

class _MaintenanceItemEditPageState extends State<MaintenanceItemEditPage> {
  final formKey = GlobalKey<FormState>();
  final dateController = TextEditingController();
  final headerController = TextEditingController();
  final meterController = TextEditingController();
  final costController = TextEditingController();
  final noteController = TextEditingController();

  @override
  void initState() {
    dateController.text = widget.maintenanceItem.date.toDateAndTime();
    headerController.text = widget.maintenanceItem.header;
    meterController.text = widget.maintenanceItem.meterValue?.toString() ?? '';
    costController.text = widget.maintenanceItem.costs.toString();
    noteController.text = widget.maintenanceItem.note;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (headerController.text.trim().isEmpty) {
          // Not valid
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text('Kunde inte spara ändringarna!'),
            ),
          );
          return;
        }

        final maintenanceItem = widget.maintenanceItem;
        final newMaintenanceItem = maintenanceItem.copyWith(
          header: headerController.text.trim(),
          date: DateTime.parse(dateController.text.trim()),
          meterValue: meterController.text.trim().isNotEmpty
              ? int.parse(meterController.text.trim())
              : null,
          costs: costController.text.trim().isNotEmpty
              ? num.parse(costController.text.replaceAll(',', '.').trim())
              : 0,
          note: noteController.text.trim(),
        );

        if (newMaintenanceItem == maintenanceItem) {
          // Nothing changed
          return;
        }

        final bloc =
            MaintenanceObjectBloc(maintenanceObjectRepository: ioc.get());
        bloc.add(
          MaintenanceItemChangedEvent(
            maintenanceObject: widget.maintenanceObject,
            maintenanceItem: newMaintenanceItem,
          ),
        );
      },
      child: Scaffold(
          backgroundColor: colorLightGrey,
          appBar: SubHeaderAppBar(
            title: widget.maintenanceObject.header,
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: 6.0, right: 6, top: 6),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  MaintenanceObjectItemCard(
                    title: 'Redigera post',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        CustomDateTimePicker('Datum', dateController),
                        CustomTextFormField(
                          label: 'Rubrik',
                          textController: headerController,
                          maxLength: 30,
                          validator: (value) => headerController.text.isEmpty
                              ? 'En rubrik måste anges'
                              : null,
                        ),
                        widget.maintenance.meterType == MeterType.odometer
                            ? CustomNumericFormField(
                                label: 'Mätarvärde (km)',
                                allowDecimal: false,
                                controller: meterController,
                              )
                            : Container(),
                        widget.maintenance.meterType == MeterType.hourmeter
                            ? CustomNumericFormField(
                                label: 'Mätarvärde (timmar)',
                                allowDecimal: false,
                                controller: meterController,
                              )
                            : Container(),
                        CustomNumericFormField(
                          label: 'Utgift (kr)',
                          allowDecimal: true,
                          controller: costController,
                        ),
                        CustomTextFormField(
                          label: 'Notering',
                          textController: noteController,
                          minLines: 3,
                        ),
                      ],
                    ),
                  ),
                  MaintenanceObjectItemCard(
                    title: 'Bilder',
                    postCount: widget.maintenanceItem.images.length,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DottedBorder(
                          color: colorGold,
                          strokeWidth: 1,
                          child: SizedBox(
                            width: 140,
                            height: 70,
                            child: Center(
                              child: FaIcon(
                                FontAwesomeIcons.plus,
                                color: colorGold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  @override
  void dispose() {
    dateController.dispose();
    headerController.dispose();
    meterController.dispose();
    costController.dispose();
    noteController.dispose();

    super.dispose();
  }
}
