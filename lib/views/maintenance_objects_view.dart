import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maintenance_log/blocs/maintenance_objects_bloc/maintenance_objects_bloc.dart';
import 'package:maintenance_log/blocs/maintenance_objects_bloc/maintenance_objects_event.dart';
import 'package:maintenance_log/blocs/maintenance_objects_bloc/maintenance_objects_state.dart';
import 'package:maintenance_log/repositories/firestore_maintenance_repository.dart';
import 'package:maintenance_log/resources/colors.dart';
import 'package:maintenance_log/setup/ioc.dart';
import 'package:maintenance_log/views/maintenance_object/maintenance_object_view.dart';
import 'package:maintenance_log/widgets/drawer_menu.dart';
import 'package:maintenance_log/widgets/main_header.dart';

class MaintenanceObjectsView extends StatelessWidget {
  const MaintenanceObjectsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBlue,
      endDrawer: DrawerMenu(),
      body: SafeArea(
        child: Container(
          color: colorLightGrey,
          child: Column(
            children: [
              MainHeader(),
              BlocProvider<MaintenanceObjectsBloc>(
                create: (BuildContext context) => MaintenanceObjectsBloc(
                    maintenanceObjectRepository: ioc.get())
                  ..add(MaintenanceObjectsSubscriptionEvent()),
                child: Expanded(
                  child: BlocBuilder<MaintenanceObjectsBloc,
                      MaintenanceObjectsState>(
                    builder: (context, state) {
                      if (state is MaintenanceObjectsChangedState) {
                        return ListView.builder(
                          itemCount: state.maintenanceObjects.length,
                          itemBuilder: (context, index) {
                            final maintenanceObject =
                                state.maintenanceObjects.elementAt(index);
                            return Material(
                              // Material is used for click-splash-effect to work on inkwell
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => MaintenanceObjectView(
                                      maintenanceObjectId: maintenanceObject.id,
                                    ),
                                  ));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 70,
                                        height: 70,
                                        child: maintenanceObject
                                                .images.isNotEmpty
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(35),
                                                child: Image.network(
                                                    fit: BoxFit.cover,
                                                    maintenanceObject
                                                        .images.first),
                                              )
                                            : CircleAvatar(
                                                backgroundColor: colorGold,
                                                foregroundColor: colorBlue,
                                                child: Icon(
                                                  Icons.car_crash,
                                                  size: 40,
                                                ),
                                              ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
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
                                            style: TextStyle(
                                                color: colorBlue, fontSize: 15),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                      return SizedBox(
                          height: 100,
                          width: 100,
                          child: CircularProgressIndicator());
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


          // var imagePicker = ImagePicker();
          // var xfile = await imagePicker.pickImage(source: ImageSource.camera);

          // if (xfile == null) {
          //   return;
          // }
          // var referenceRoot = FirebaseStorage.instance.ref();
          // var referenceDirImages = referenceRoot.child('images');
          // var referenceImageToUpload = referenceDirImages.child(xfile.name);
          // await referenceImageToUpload.putFile(File(xfile.path));
          // var url = await referenceImageToUpload.getDownloadURL();

          // // var aaa = url;

          // Map<String, dynamic> myMap = {'ggg': 'hhh'};
          // var collection = FirebaseFirestore.instance.collection('test');
          // var ref = collection.doc('000');
          // await ref.set(myMap);
