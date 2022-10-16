import 'package:cloud_firestore/cloud_firestore.dart';

class Login{
  AuthUser(email,password){
    return FirebaseFirestore.instance.collection('users')
        .where('email', isEqualTo: email)
        .where('password', isEqualTo: password)
        .get();
  }
}