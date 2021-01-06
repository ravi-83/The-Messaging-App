import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:messaging/AuthServices/services.dart';
import 'package:messaging/data/data_model.dart';
import 'package:messaging/data/data_source_firebase.dart';
import 'package:messaging/utils/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'loginScreen.dart';

//import 'package:firebase_core/firebase_core.dart';
List<Map<String, String>> list = [];

final FirebaseAuth auth = FirebaseAuth.instance;
final fireStore = FirebaseFirestore.instance;

class AuthenticationScreen extends StatefulWidget {
  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  TextEditingController _nameText = TextEditingController();
  TextEditingController _emailText = TextEditingController();
  TextEditingController _passwordText = TextEditingController();
  TextEditingController _conformationPass = TextEditingController();

  final _db = FirebaseDB();

  String name;
  String email;
  String password;
  String conformPass;
  String image =
      'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500';
  bool snack = false;
  String error;

  void onPressed() async {
    if (_key.currentState.validate()) {
      try {
        final _authh = Provider.of<FirebaseAuthImpl>(context, listen: false);
        UserDetails userDetails =
            await _authh.createUserWithEmailAndPassword(email, password);

        // UserCredential newUser = await auth.createUserWithEmailAndPassword(
        //     email: email, password: password);

        // //User firebaseUser= await auth.signInWithCredential(newUser).user;
        final userData = UserData(
            userImage: image,
            userName: name,
            userEmail: email,
            userDocId: userDetails.uid);

        _db.uploadUserDataToDB(userData);

        // var reff = fireStore.collection('message').doc(userDetails.uid);

        // await reff.set({
        //   'name': name,
        //   'email': email,
        //   'image': image,
        //   'id': userDetails.uid,
        // });

        if (userDetails != null)
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) {
              return ChatScreen(
                ref: userDetails.uid,
              );
            }),
            (Route<dynamic> route) => false,
          );
        setState(() {
          //showSpinner=false;
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Fluttertoast.showToast(
              msg: e.code,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        } else if (e.code == 'email-already-in-use') {
          Fluttertoast.showToast(
              msg: e.code,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      } catch (e) {
        Fluttertoast.showToast(
            msg: e.code,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  final _key = GlobalKey<FormState>();
  DateTime currentBackPressTime;
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
          msg: 'Double press to back', gravity: ToastGravity.CENTER);
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
              margin: EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Hello!',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 40,
                    ),
                  ),
                  Text(
                    'Please create an account to continue',
                    style: TextStyle(color: Colors.black54),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  containerForm(),
                  Center(
                      child: RoundedButton(
                          onPressed: onPressed,
                          buttonName: 'Sign Up',
                          colour: Colors.lightGreen)),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account ? ',
                        style: TextStyle(
                            color: Colors.black45,
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      ),
                      GestureDetector(
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(createRoute());
                        },
                      ),
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }

  Widget containerForm() {
    return Material(
      color: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      child: Container(
        margin: EdgeInsets.all(20),
        width: double.infinity,
        child: Form(
          key: _key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '  Full Name',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: _nameText,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.black12,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    )),
                onChanged: (value) {
                  name = value;
                },
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '  Email',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: _emailText,
                validator: (value) {
                  if (!value.contains('@')) {
                    return 'Please enter valid email';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.black12,
                    hintText: 'you@example.com',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    )),
                onChanged: (value) {
                  email = value;
                },
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '  Password',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: _passwordText,
                validator: (value) {
                  if (value.length < 5) {
                    return 'weak password';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    errorText: snack ? error : '',
                    filled: true,
                    fillColor: Colors.black12,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    )),
                onChanged: (value) {
                  password = value;
                },
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '  Conform password',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: _conformationPass,
                validator: (value) {
                  if (value != password) {
                    return 'Match the password properly';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.black12,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    )),
                onChanged: (value) {
                  conformPass = value;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Route createRoute() {
  return PageRouteBuilder(
    transitionDuration: Duration(milliseconds: 500),
    pageBuilder: (context, Animation<double> first, Animation<double> second) {
      return LoginScreen();
    },
    transitionsBuilder: (context, Animation<double> first,
        Animation<double> second, Widget child) {
      var begin = Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: first.drive(tween),
        child: child,
      );
    },
  );
}

//final String imageee =
//'https://www.google.com/imgres?imgurl=https%3A%2F%2Fimg.icons8.com%2Fclouds%2F2x%2Fguest-male.png&imgrefurl=https%3A%2F%2Ficons8.com%2Ficons%2Fset%2Faccount&tbnid=Wt2cSy_XjPRktM&vet=12ahUKEwiiyLWNp93tAhW03HMBHXx1DkkQMyhIegUIARCDAQ..i&docid=QQUU-8wkFgWO3M&w=200&h=200&q=account%20image%20png&ved=2ahUKEwiiyLWNp93tAhW03HMBHXx1DkkQMyhIegUIARCDAQ';
