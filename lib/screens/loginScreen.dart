import 'package:flutter/material.dart';
import 'package:messaging/AuthServices/services.dart';
import 'package:messaging/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';
import 'AuthenticationScreen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _key = GlobalKey<FormState>();
  String email;
  String password;
  String name;
  String url;
  String currentUser;

  onPressed() async {
    try {
      final auth = Provider.of<FirebaseAuthImpl>(context,listen: false);
      UserDetails usr = await auth.signInWithEmailAndPassword(email, password);
      // final userId = await _auth.signInWithEmailAndPassword(
      //     email: email, password: password);

      // await firestore
      //     .collection('message')
      //     .where('id', isEqualTo:userId.user.uid)
      //     .get()
      //     .then((value) => value.docs.forEach((element) {
      //           if (element.data().containsValue(email)) {
      //             currentUser = element.data()['id'];
      //             print('emememjbbsjbskfdkfbjbvsjfsdfjgdjkfgdugsgkdkghjgskfhksgndjgygf$currentUser')
      //           }
      //         }));
      // FutureBuilder(
      //   future: fireStore.collection('message').doc(ref).get(),
      //   builder: (context, snapshot) {
      //     if (snapshot.hasError) {
      //       print('Somthing went wrong');
      //       return null;
      //     }
      //     if (snapshot.connectionState == ConnectionState.done) {
      //       Map<String, dynamic> data = snapshot.data.data();
      //       name = data['name'];
      //       url = data['url'];
      //     }
      //   },
      // );
      // if (userId != null) {
      //   //currently = ref;
      //   Navigator.push(context, MaterialPageRoute(builder: (context) {
      //     return ChatScreen(
      //       ref: userId.user.uid,
      //     );
      //   }));
      // }

      if (usr != null) {
        //currently = ref;
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ChatScreen(
            ref: usr.uid,
          );
        }));
      }
    } on FirebaseAuthException catch (e) {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('${e.code}')));
    }
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello!',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 40,
                ),
              ),
              Text(
                'Please sign in to continue',
                style: TextStyle(color: Colors.black54),
              ),
              SizedBox(
                height: 20,
              ),
              containerForm(),
              SizedBox(
                height: 20,
              ),
              Center(
                  child: RoundedButton(
                onPressed: onPressed,
                buttonName: 'Sign In',
                colour: Colors.lightGreen,
              ))
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(createRoute());
        },
      ),
    );
  }

  Widget containerForm() {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.all(Radius.circular(20)),
      child: Container(
        margin: EdgeInsets.all(20),
        width: double.infinity,
        child: Form(
          key: _key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '  Email',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: _emailController,
                validator: (value) {
                  if (!value.contains('@')) {
                    return 'Email not found';
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
                controller: _passwordController,
                validator: (value) {
                  if (value.length < 5) {
                    return 'wrong password';
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
                  password = value;
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
      return AuthenticationScreen();
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
