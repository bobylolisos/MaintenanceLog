import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maintenance_log/blocs/maintenance_object_bloc/maintenance_object_bloc.dart';
import 'package:maintenance_log/blocs/maintenance_object_bloc/maintenance_object_event.dart';
import 'package:maintenance_log/extensions/date_time_extensions.dart';
import 'package:maintenance_log/models/consumption.dart';
import 'package:maintenance_log/models/consumption_item.dart';
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

class ConsumptionItemEditPage extends StatefulWidget {
  final MaintenanceObject maintenanceObject;
  final Consumption consumption;
  final ConsumptionItem consumptionItem;

  const ConsumptionItemEditPage({
    required this.maintenanceObject,
    required this.consumption,
    required this.consumptionItem,
    super.key,
  });

  @override
  State<ConsumptionItemEditPage> createState() =>
      _ConsumptionItemEditPageState();
}

class _ConsumptionItemEditPageState extends State<ConsumptionItemEditPage> {
  final formKey = GlobalKey<FormState>();
  final dateController = TextEditingController();
  final meterController = TextEditingController();
  final pricePerLitreController = TextEditingController();
  final litreController = TextEditingController();
  final noteController = TextEditingController();

  @override
  void initState() {
    dateController.text = widget.consumptionItem.date.toDateAndTime();
    meterController.text = widget.consumptionItem.meterValue?.toString() ?? '';
    pricePerLitreController.text =
        widget.consumptionItem.pricePerLitre.toString();
    litreController.text = widget.consumptionItem.litre.toString();
    noteController.text = widget.consumptionItem.note;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (formKey.currentState?.validate() == false) {
          // Not valid
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text('Kunde inte spara ändringarna!'),
            ),
          );
          return;
        }

        final consumptionItem = widget.consumptionItem;
        final newConsumptionItem = consumptionItem.copyWith(
          date: DateTime.parse(dateController.text.trim()),
          meterValue: meterController.text.trim().isNotEmpty
              ? int.parse(meterController.text.trim())
              : null,
          pricePerLitre: pricePerLitreController.text.trim().isNotEmpty
              ? num.parse(
                  pricePerLitreController.text.replaceAll(',', '.').trim())
              : 0,
          litre: litreController.text.trim().isNotEmpty
              ? num.parse(litreController.text.replaceAll(',', '.').trim())
              : 0,
          note: noteController.text.trim(),
        );

        if (newConsumptionItem == consumptionItem) {
          // Nothing changed
          return;
        }

        final bloc =
            MaintenanceObjectBloc(maintenanceObjectRepository: ioc.get());
        bloc.add(
          ConsumptionItemChangedEvent(
            maintenanceObject: widget.maintenanceObject,
            consumptionItem: newConsumptionItem,
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
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          CustomDateTimePicker('Datum', dateController),
                          widget.consumption.meterType == MeterType.odometer
                              ? CustomNumericFormField(
                                  label: 'Mätarvärde (km)',
                                  allowDecimal: false,
                                  controller: meterController,
                                )
                              : Container(),
                          widget.consumption.meterType == MeterType.hourmeter
                              ? CustomNumericFormField(
                                  label: 'Mätarvärde (timmar)',
                                  allowDecimal: false,
                                  controller: meterController,
                                )
                              : Container(),
                          CustomNumericFormField(
                            // formKey: formKey,
                            label: 'Literpris',
                            allowDecimal: true,
                            controller: pricePerLitreController,
                            validator: (value) =>
                                pricePerLitreController.text.isEmpty
                                    ? 'Ett literpris måste anges'
                                    : null,
                            onChanged: (value) =>
                                formKey.currentState?.validate(),
                          ),
                          CustomNumericFormField(
                            label: 'Antal liter',
                            allowDecimal: true,
                            controller: litreController,
                            validator: (value) => litreController.text.isEmpty
                                ? 'Antal liter måste anges'
                                : null,
                            onChanged: (value) =>
                                formKey.currentState?.validate(),
                          ),
                          CustomTextFormField(
                            label: 'Notering',
                            textController: noteController,
                            minLines: 3,
                          ),
                        ],
                      ),
                    ),
                  ),
                  MaintenanceObjectItemCard(
                    title: 'Bilder',
                    postCount: widget.consumptionItem.images.length,
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
    meterController.dispose();
    pricePerLitreController.dispose();
    litreController.dispose();
    noteController.dispose();

    super.dispose();
  }
}
