import 'package:flutter/foundation.dart';

class UserData {
  final String userImage;
  final String userName;
  final String userEmail;

  UserData({this.userImage,this.userName, this.userEmail});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      userName: json['name'],
      userEmail: json['email'],
      userImage: json['image'],
    );
  }
}
