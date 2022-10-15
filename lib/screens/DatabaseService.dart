import 'package:cloud_firestore/cloud_firestore.dart';

class Login{
  AuthUser(){
    return FirebaseFirestore.instance.collection('users').where('email', isEqualTo: 'shivamkshirsagar2002@gmail.com').get();
  }
}