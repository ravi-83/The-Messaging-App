//import 'package:flutter/foundation.dart';

class UserData {
  final String userImage;
  final String userName;
  final String userEmail;
  final String userDocId;

  UserData({this.userImage, this.userName, this.userEmail, this.userDocId});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      userName: json['name'],
      userEmail: json['email'],
      userImage: json['image'],
      userDocId: json['id'],
    );
  }

  Map toMap(UserData user) {
    var data = Map<String, dynamic>();
    data['name'] = user.userName;
    data['email'] = user.userEmail;
    data['image'] = user.userImage;
    data['id'] = user.userDocId;
    return data;
  }
}
