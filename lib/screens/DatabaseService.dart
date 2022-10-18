import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_todo_app/model/todo.dart';
import '../firebase_options.dart';
class AuthServices{
  FirebaseAuth auth = FirebaseAuth.instance;
  static final CollectionReference user = FirebaseFirestore.instance.collection("users");
  static final CollectionReference todos = FirebaseFirestore.instance.collection("todos");
  static var UID;
  static var NAME ="";
  static bool error = false;
  static List<ToDo>list_todos = [];
  Future CurrUser()async {
    return await auth.currentUser?.uid;
  }
  Future SignOut()async {
    await auth.signOut();
    UID = null;
  }
  Future AuthUser(email,password)async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      final user = userCredential.user;
      if (user != null){
        UID = user.uid;
        error = true;
        // await getUsernameFromUID();
        // await getTodos().then((value) => print(list_todos));
      }
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }
  Future saveUser(email,password,name)async {
  try{
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
      );
      final user = userCredential.user;
      if (user != null){
        UID = user.uid;
        error = true;
        await SaveName(name, UID);
        NAME = name;
      }
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

  static Future SaveName(name,uid) async {
  return await user.doc(uid).set({
    "userName": name,
  });
  }

  static Future getUsernameFromUID() async{
    var x = await user.doc(UID).get();
    NAME = "shivam";
    print(x);
  }
}