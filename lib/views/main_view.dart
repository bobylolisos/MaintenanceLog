import 'package:flutter/material.dart';
import 'package:maintenance_log/resources/colors.dart';
import 'package:maintenance_log/views/home_view.dart';
import 'package:maintenance_log/widgets/drawer_menu.dart';
import 'package:maintenance_log/widgets/main_header.dart';

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
              MainHeader(),
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
