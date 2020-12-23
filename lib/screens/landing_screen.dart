import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messaging/AuthServices/services.dart';
import 'package:messaging/screens/home_screen.dart';
import 'package:messaging/screens/loginScreen.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<FirebaseAuthImpl>(context);
    return StreamBuilder<User>(
        stream: auth.onAuthStateChange,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User user = snapshot.data;
            if (user == null) {
              return LoginScreen();
            }
            return ChatScreen(
              ref: user.uid,
            );
          }else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        });
  }
}
