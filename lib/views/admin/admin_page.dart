import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maintenance_log/blocs/maintenance_object_bloc/maintenance_object_bloc.dart';
import 'package:maintenance_log/blocs/maintenance_object_bloc/maintenance_object_event.dart';
import 'package:maintenance_log/blocs/maintenance_objects_bloc/maintenance_objects_bloc.dart';
import 'package:maintenance_log/blocs/maintenance_objects_bloc/maintenance_objects_event.dart';
import 'package:maintenance_log/blocs/maintenance_objects_bloc/maintenance_objects_state.dart';
import 'package:maintenance_log/models/maintenance_object.dart';
import 'package:maintenance_log/resources/colors.dart';
import 'package:maintenance_log/setup/ioc.dart';
import 'package:maintenance_log/views/admin/information_tab/add_edit_maintenance_object_dialog.dart';
import 'package:maintenance_log/views/admin/admin_maintenance_object_page.dart';
import 'package:maintenance_log/widgets/maintenace_object_card.dart';
import 'package:maintenance_log/widgets/sub_header_app_bar.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int _lowestSortOrder = 1000;
  late ValueNotifier<int> _selectedTabIndexNotifier;

  @override
  void initState() {
    _selectedTabIndexNotifier = ValueNotifier(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MaintenanceObjectsBloc>(
      create: (BuildContext context) =>
          MaintenanceObjectsBloc(maintenanceObjectRepository: ioc.get())
            ..add(MaintenanceObjectsSubscriptionEvent()),
      child: BlocProvider<MaintenanceObjectBloc>(
        create: (context) =>
            MaintenanceObjectBloc(maintenanceObjectRepository: ioc.get()),
        child: ValueListenableBuilder(
          valueListenable: _selectedTabIndexNotifier,
          builder: (context, selectedTabIndex, child) {
            return Scaffold(
              backgroundColor: colorLightGrey,
              appBar:
                  // Only show add-button when showing active objects
                  selectedTabIndex == 0
                      ? SubHeaderAppBar(
                          title: 'Dina underhållsobjekt',
                          onTrailingAddTap: () async {
                            final maintenanceObjectBloc =
                                context.read<MaintenanceObjectBloc>();

                            final addedMaintenanceObject =
                                await showDialog<MaintenanceObject?>(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return AddEditMaintenanceObjectDialog();
                              },
                            );

                            if (addedMaintenanceObject != null) {
                              maintenanceObjectBloc.add(
                                MaintenanceObjectSaveEvent(
                                    maintenanceObject:
                                        addedMaintenanceObject.copyWith(
                                            sortOrder: --_lowestSortOrder)),
                              );
                            }
                          },
                        )
                      : SubHeaderAppBar(title: 'Dina underhållsobjekt'),
              body: Material(
                child: SafeArea(
                  child: Container(
                    color: colorLightGrey,
                    child: BlocBuilder<MaintenanceObjectsBloc,
                        MaintenanceObjectsState>(
                      builder: (context, state) {
                        if (state is MaintenanceObjectsChangedState) {
                          if (selectedTabIndex == 0) {
                            final activeObjects = state.maintenanceObjects
                                .where((element) => element.isActive)
                                .toList();
                            return ReorderableListView.builder(
                              itemCount: activeObjects.length,
                              proxyDecorator: (child, index, animation) =>
                                  Material(
                                color: Colors.transparent,
                                // borderRadius: BorderRadius.circular(12),
                                child: Stack(
                                  children: [
                                    child,
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 4),
                                      decoration: BoxDecoration(
                                          color: colorGold.withOpacity(0.7),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  ],
                                ),
                              ),
                              itemBuilder: (context, index) {
                                final maintenanceObject =
                                    activeObjects.elementAt(index);
                                return Padding(
                                  key: ValueKey(maintenanceObject.id),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 5),
                                  child: Dismissible(
                                    key: ValueKey(maintenanceObject.id),
                                    background: Container(
                                      color: Colors.transparent,
                                    ),
                                    secondaryBackground: Container(
                                      color: Colors.red,
                                      child: const Padding(
                                        padding: EdgeInsets.all(15),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Icon(Icons.delete,
                                                color: Colors.white),
                                            SizedBox(
                                              width: 8.0,
                                            ),
                                            Text('Radera',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    confirmDismiss: (direction) async {
                                      if (direction ==
                                          DismissDirection.endToStart) {
                                        var shouldDelete = await showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  'Radera underhållsobjekt'),
                                              content: const Text(
                                                  'Underhållsobjektet kommer nu tas bort och kan inte återskapas. Du vet väl att du kan inaktivera ditt underhållsobjekt istället? Då kan du fortfarande återaktivera objektet samt att du kan fortfarande se utförda underhåll. \n\n Vill du fortsätta med att radera?'),
                                              actions: <Widget>[
                                                SizedBox(
                                                  width: 130,
                                                  child: ElevatedButton(
                                                    style: TextButton.styleFrom(
                                                        backgroundColor:
                                                            colorGold
                                                                .withOpacity(
                                                                    0.5),
                                                        foregroundColor:
                                                            colorBlue),
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(false),
                                                    child: Text('Nej'),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 130,
                                                  child: ElevatedButton(
                                                    style: TextButton.styleFrom(
                                                        backgroundColor:
                                                            colorBlue,
                                                        foregroundColor:
                                                            colorGold),
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(true),
                                                    child: Text('Ja'),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );

                                        if (shouldDelete) {
                                          return Future.value(true);
                                        }
                                      }

                                      return Future.value(false);
                                    },
                                    onDismissed: (direction) {
                                      context
                                          .read<MaintenanceObjectsBloc>()
                                          .add(MaintenanceObjectsDeleteEvent(
                                              maintenanceObjectId:
                                                  maintenanceObject.id));
                                    },
                                    child: MaintenanceObjectCard(
                                      maintenanceObject: maintenanceObject,
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AdminMaintenanceObjectPage(
                                                maintenanceObjectId:
                                                    maintenanceObject.id,
                                              ),
                                            ));
                                      },
                                      trailing:
                                          Icon(Icons.reorder, color: colorBlue),
                                    ),
                                  ),
                                );
                              },
                              onReorder: (int oldIndex, int newIndex) {
                                print(newIndex.toString());
                                if (oldIndex < newIndex) {
                                  newIndex -= 1;
                                }
                                final item = activeObjects.removeAt(oldIndex);
                                activeObjects.insert(newIndex, item);
                                context.read<MaintenanceObjectsBloc>().add(
                                    MaintenanceObjectsReorderEvent(
                                        maintenanceObjects: activeObjects));
                              },
                            );
                          } else {}
                          final inactiveObjects = state.maintenanceObjects
                              .where((element) => !element.isActive)
                              .toList();
                          return ListView.builder(
                            itemCount: inactiveObjects.length,
                            itemBuilder: (context, index) {
                              final maintenanceObject =
                                  inactiveObjects.elementAt(index);
                              return Padding(
                                key: ValueKey(maintenanceObject.id),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 5),
                                child: Dismissible(
                                  key: ValueKey(maintenanceObject.id),
                                  background: Container(
                                    color: Colors.transparent,
                                  ),
                                  secondaryBackground: Container(
                                    color: Colors.red,
                                    child: const Padding(
                                      padding: EdgeInsets.all(15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Icon(Icons.delete,
                                              color: Colors.white),
                                          SizedBox(
                                            width: 8.0,
                                          ),
                                          Text('Radera',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  confirmDismiss: (direction) async {
                                    if (direction ==
                                        DismissDirection.endToStart) {
                                      var shouldDelete = await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                                'Radera underhållsobjekt'),
                                            content: const Text(
                                                'Underhållsobjektet kommer nu tas bort och kan inte återskapas.\n\n Vill du fortsätta med att radera?'),
                                            actions: <Widget>[
                                              SizedBox(
                                                width: 130,
                                                child: ElevatedButton(
                                                  style: TextButton.styleFrom(
                                                      backgroundColor: colorGold
                                                          .withOpacity(0.5),
                                                      foregroundColor:
                                                          colorBlue),
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(false),
                                                  child: Text('Nej'),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 130,
                                                child: ElevatedButton(
                                                  style: TextButton.styleFrom(
                                                      backgroundColor:
                                                          colorBlue,
                                                      foregroundColor:
                                                          colorGold),
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(true),
                                                  child: Text('Ja'),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );

                                      if (shouldDelete) {
                                        return Future.value(true);
                                      }
                                    }

                                    return Future.value(false);
                                  },
                                  onDismissed: (direction) {
                                    context.read<MaintenanceObjectsBloc>().add(
                                        MaintenanceObjectsDeleteEvent(
                                            maintenanceObjectId:
                                                maintenanceObject.id));
                                  },
                                  child: MaintenanceObjectCard(
                                    maintenanceObject: maintenanceObject,
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AdminMaintenanceObjectPage(
                                              maintenanceObjectId:
                                                  maintenanceObject.id,
                                            ),
                                          ));
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                        }
                        return Center(
                          child: SizedBox(
                              height: 80,
                              width: 80,
                              child: CircularProgressIndicator()),
                        );
                      },
                    ),
                  ),
                ),
              ),
              bottomNavigationBar: BottomNavigationBar(
                  iconSize: 18,
                  selectedFontSize: 16,
                  currentIndex: _selectedTabIndexNotifier.value,
                  backgroundColor: colorBlue,
                  selectedItemColor: colorGold,
                  unselectedItemColor: colorGold.withOpacity(0.5),
                  onTap: (value) {
                    _selectedTabIndexNotifier.value = value;
                  },
                  items: [
                    BottomNavigationBarItem(
                        icon: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: FaIcon(
                            FontAwesomeIcons.eye,
                          ),
                        ),
                        label: 'Aktiva'),
                    BottomNavigationBarItem(
                        icon: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: FaIcon(
                            FontAwesomeIcons.eyeSlash,
                          ),
                        ),
                        label: 'Inaktiva'),
                  ]),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _selectedTabIndexNotifier.dispose();
    super.dispose();
  }
}
