import 'package:flutter/material.dart';
import 'package:messaging/screens/home_screen.dart';
import 'screens/AuthenticationScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'AuthServices/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseAuthImpl _auth =FirebaseAuthImpl();
  @override
  Widget build(BuildContext context) {
    return Provider<FirebaseAuthImpl>(
      create: (_) => FirebaseAuthImpl(),
      child: MaterialApp(
        home: FutureBuilder(
          future: _auth.getCurrentUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              String id = snapshot.data.uid;
              return ChatScreen(
                ref: id,
              );
            } else {
              return AuthenticationScreen();
            }
          },
        ),
      ),
    );
  }
}
