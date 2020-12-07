import 'package:flutter/material.dart';
import 'package:messaging/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';




class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController =TextEditingController();
  TextEditingController _passwordController=TextEditingController();
  final _auth=FirebaseAuth.instance;
  final _key =GlobalKey<FormState>();
  String email;
  String password;

  onPressed()async{
    try{
      final user=await _auth.signInWithEmailAndPassword(email: email, password: password);
      if(user!=null){
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return ChatScreen();
        }));
      }
    } on FirebaseAuthException catch(e){
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('${e.code}')));

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
                style: TextStyle(
                    color: Colors.black54
                ),
              ),
              SizedBox(height: 20,),
              containerForm(),
              SizedBox(height: 20,),
              Center(child: RoundedButton(onPressed: onPressed, buttonName: 'Sign In',colour: Colors.lightGreen,))
            ],
          ),
        ),
      ),
    );
  }
  Widget containerForm(){
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
                validator: (value){
                  if(!value.contains('@')){
                    return 'Email not found';
                  }
                  return  null;
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
                controller: _passwordController,
                validator: (value){
                  if(value.length<5){
                    return 'wrong password';
                  }
                  return  null;
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
                  password=value;
                },
              ),
            ],
          ),
        ),

      ),
    );
  }
}
