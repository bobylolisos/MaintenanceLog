import 'package:flutter/material.dart';
import 'package:maintenance_log/resources/colors.dart';
import 'package:maintenance_log/views/home_view.dart';
import 'package:maintenance_log/widgets/drawer_menu.dart';
import 'package:maintenance_log/widgets/wave_clipper.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

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
              ClipPath(
                clipper: WaveClipper(),
                child: Container(
                  height: 160,
                  color: colorBlue,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 20),
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
                                style:
                                    TextStyle(color: colorGold, fontSize: 28),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Keep track of your expenses, maintenances',
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
                      SizedBox(
                        width: 10,
                      ),
                      Builder(builder: (context) {
                        return InkWell(
                          onTap: () {
                            Scaffold.of(context).openEndDrawer();
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 15),
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
              ),
              Expanded(
                child: HomeView(),
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
