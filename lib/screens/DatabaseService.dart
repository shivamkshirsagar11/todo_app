import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../firebase_options.dart';
class AuthServices{
  FirebaseAuth auth = FirebaseAuth.instance;
  Future CurrUser()async {
    return await auth.currentUser?.uid;
  }
  Future SignOut()async {
    await auth.signOut();
  }
  Future AuthUser(email,password)async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }
  Future saveUser(email,password)async {
  try{
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
  }catch(e){
    print(e.toString());
  }
  }
}