import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);

  Future<String> signUp(String email, String password);

  Future<FirebaseUser> getCurrentUser();

  Future<void> signOut();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async {
    AuthResult user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return user.toString();
  }

  Future<String> signUp(String email, String password) async {
    AuthResult user = await _firebaseAuth.createUserWithEmailAndPassword(
       email: email, password: password);
    // crear tambipen sus datos personales

    return user.toString();
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}