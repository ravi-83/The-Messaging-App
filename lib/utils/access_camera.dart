
import 'dart:io';

import 'package:image_picker/image_picker.dart';
class AccessCamera {

  final picker = ImagePicker();

  Future<File> getImage() async {
    try {
      final pickedFile = await picker.getImage(source: ImageSource.camera);
      //print(pickedFile.path);
      //return pickedFile.path;
      return File(pickedFile.path);
    } on Exception catch(e){
      print('I don\'n know what happen $e');
    }
    return null;
      // if (pickedFile != null) {
      //
      // } else {
      //   print('No image selected.');

      // }
  }

  Future<File> getVideo() async {
    try {
      final pickedFile = await picker.getVideo(
        source: ImageSource.camera,
        maxDuration: Duration(seconds: 30),
      );
      //print(pickedFile.path);
      //return pickedFile.path;
      return File(pickedFile.path);
    } on Exception catch(e){
      print('I don\'n know what happen $e');
    }
    return null;
    // if (pickedFile != null) {
    //
    // } else {
    //   print('No image selected.');

    // }
  }

  Future<File> getImageGallery() async {

    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    return File(pickedFile.path);
  }


}