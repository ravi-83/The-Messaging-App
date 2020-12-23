import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

abstract class AuthServices {
  Future<UserDetails> signInWithEmailAndPassword(String email, String password);
  Future<UserDetails> createUserWithEmailAndPassword(String email, String password);
  Future<void> signOut();
  Stream<User> get onAuthStateChange;
}

class UserDetails {
  final String uid;
  final String email;
  const UserDetails({@required this.email, @required this.uid});
}

class FirebaseAuthImpl implements AuthServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  UserDetails _userFromFirebase(User user) {
    return user == null ? null : UserDetails(email: user.email, uid: user.uid);
  }

  @override
  Stream<User> get onAuthStateChange => _firebaseAuth.authStateChanges();

  @override
  Future<UserDetails> createUserWithEmailAndPassword(
      String email, String password) async {
    final myUser = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(myUser.user);
  }

  @override
  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }

  @override
  Future<UserDetails> signInWithEmailAndPassword(String email, String password) async{
    final myUser = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(myUser.user);
  }
}
