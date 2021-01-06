import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messaging/data/data_model.dart';

class FirebaseUserImpl {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  UserData getUserDataFromFireBase(String userId) {
    firestore.collection('message').doc(userId).get().then((value) {
      if (value.exists) {
        return UserData.fromJson(value.data());
      } else {
        print('Error!');
      }
    });
    return null;
    // Map<String, dynamic> user = fireBaseData(userId);

    // //print(user.userEmail);
    // return UserData.fromJson(user);
  }

  Map<String, dynamic> fireBaseData(String userId) {
    Map<String, dynamic> data;
    firestore.collection('message').doc(userId).get().then((value) {
      if (value.exists) {
        value.data().cast();
      } else {
        print('Error!');
      }
    });
    print(data.toString());
    return data;
  }
}
