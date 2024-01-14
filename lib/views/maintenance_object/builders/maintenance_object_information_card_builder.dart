import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maintenance_log/models/maintenance_object.dart';
import 'package:maintenance_log/resources/colors.dart';
import 'package:maintenance_log/widgets/maintenance_object_item_card.dart';
import 'package:image_picker/image_picker.dart';

class MaintenanceObjectInformationCardBuilder {
  static Widget create(MaintenanceObject maintenanceObject) {
    return MaintenanceObjectItemCard(
      title: 'Information',
      onTap: () {},
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      maintenanceObject.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: colorBlue, fontSize: 20),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      maintenanceObject.shortDescription,
                      style: TextStyle(color: colorBlue, fontSize: 16),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 150,
                height: 80,
                child: maintenanceObject.images.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.network(
                            fit: BoxFit.cover, maintenanceObject.images.first),
                      )
                    : InkWell(
                        splashColor: colorGold,
                        onTap: () async {
                          var imagePicker = ImagePicker();
                          var xfile = await imagePicker.pickImage(
                              source: ImageSource.gallery);

                          if (xfile == null) {
                            return;
                          }
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
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: colorBlue),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                              child: FaIcon(
                            FontAwesomeIcons.image,
                            color: colorBlue,
                            size: 40,
                          )),
                        ),
                      ),
              ),
            ],
          ),
          maintenanceObject.description.isNotEmpty
              ? Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            maintenanceObject.description,
                            style: TextStyle(color: colorBlue, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}
