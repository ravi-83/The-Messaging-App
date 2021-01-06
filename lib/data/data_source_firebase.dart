import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:messaging/data/data_model.dart';
import 'package:messaging/screens/home_screen.dart';

class FirebaseDB {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserData getUserDataFromFireBase(String userId) {
    _firestore.collection('message').doc(userId).get().then((value) {
      if (value.exists) {
        return UserData.fromJson(value.data());
      } else {
        print('Error!');
      }
    });
    return null;
    // Map<String, dynamic> user = fireBaseData(userId);

    // //print(user.userEmail);
    // return UserData.fromJson(user
  }

  Future<List<UserData>> getListOfAllFirebaseUser() {
    print('Hello From  getListOfAllFirebaseUser');
    List<UserData> list = [];
    _firestore.collection('message').snapshots().listen((event) async{
      event.docs.forEach((element) async{
        print('Hello');
        print('${element.data()['name']}');
        list.add(UserData.fromJson(element.data()));
      });
    });
    return Future.value(list);
  }

  fireBaseData(String userId) {
    //var list = <UserData>[];
    Map<String, dynamic> data;
    _firestore.collection('message').doc(userId).get().then((value) {
      if (value.exists) {
        data = value.data();
      } else {
        print('Error!');
      }
    });
    print(data.toString());
    var userData = UserData.fromJson(data);
    return userData;
  }

  uploadUserDataToDB(UserData _user) {
    var map = UserData().toMap(_user);
    _firestore.collection('message').doc(_user.userDocId).set(map);
  }
}
