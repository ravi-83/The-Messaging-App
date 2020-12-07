import 'package:flutter/material.dart';
import 'package:messaging/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'loginScreen.dart';
//import 'package:firebase_core/firebase_core.dart';




final _auth=FirebaseAuth.instance;
final fireStore=FirebaseFirestore.instance;

class AuthenticationScreen extends StatefulWidget {
  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  TextEditingController nameText=TextEditingController();
  TextEditingController emailText=TextEditingController();
  TextEditingController passwordText=TextEditingController();
  TextEditingController conformationPass=TextEditingController();

  String name;
  String email;
  String  password;
  String conformPass;
  bool snack=false;
  String error;


  void onPressed()async{
    if(_key.currentState.validate()){
      try {
        UserCredential newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        Map<String,dynamic> demoData={'name' : name, 'email' : email, 'password' : password};
        fireStore.collection('message').add(demoData);
        if(newUser!=null)
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return ChatScreen();
          }));
        setState(() {
          //showSpinner=false;
        });
      }on FirebaseAuthException catch(e) {
        if (e.code == 'weak-password') {
          print('Weak password');

        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
      }catch(e){
        print(e);
      }

    }

  }
  final _key=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                style: TextStyle(
                  color: Colors.black54
                ),
              ),
              SizedBox(height: 20,),

              containerForm(),
              Center(child: RoundedButton(onPressed: onPressed, buttonName: 'Sign Up', colour: Colors.lightGreen)),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account ? ',
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 15,
                      fontWeight: FontWeight.w600
                    ),
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
                    onTap: (){
                      Navigator.of(context).push(createRoute());

                    },
                  ),
                ],
              )



            ],
          )
        ),
      ),
    );
  }
  Widget containerForm(){
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
                controller: nameText,
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
                    )

                ),
                onChanged: (value){
                  name=value;
                },
              ),
              SizedBox(height: 10,),
              Text(
                '  Email',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: emailText,
                validator: (value){
                  if(!value.contains('@')){
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
                    )

                ),
                onChanged: (value){
                  email=value;
                },
              ),
              SizedBox(height: 10,),
              Text(
                '  Password',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: passwordText,
                validator: (value){
                  if(value.length<5){
                    return 'weak password';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    errorText: snack? error :  '',
                    filled: true,
                    fillColor: Colors.black12,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    )

                ),
                onChanged: (value){
                  password=value;
                },
              ),
              SizedBox(height: 10,),
              Text(
                '  Conform password',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: conformationPass,
                validator: (value){
                  if(value!=password){
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
                    )
                ),
                onChanged: (value){
                  conformPass=value;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}



Route createRoute(){
  return PageRouteBuilder(
    transitionDuration: Duration(milliseconds: 500),
    pageBuilder: (context, Animation<double> first, Animation<double> second){
      return LoginScreen();
    },
    transitionsBuilder: (context,Animation<double>first,Animation<double>second,Widget child){
      var begin = Offset(1.0,0.0);
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






