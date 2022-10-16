import 'package:flutter/material.dart';
import 'reg.dart';
import './screens/home.dart';
import '../screens/DatabaseService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  final email = TextEditingController();
  final password = TextEditingController();
  setLogin(value) async {
    await SessionManager().set("isLoggedIn", value);
  }
  authLogin() async {
    bool check = await SessionManager().get("isLoggedIn");
    if(check){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Home()));
    }
  }
  @override
  void initState(){
  authLogin();
    super.initState();
  }
  String  error_login = " ";
  setError(){
    setState(() {
      error_login = "No user Found!";
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/login.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(),
            Container(
              padding: EdgeInsets.only(left: 35, top: 130),
              child: Text(
                'Welcome\nBack',
                style: TextStyle(color: Colors.white, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          TextField(
                            controller:email,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "Email",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextField(
                            controller:password,
                            style: TextStyle(),
                            obscureText: true,
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "Password",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Text("$error_login",style: TextStyle(fontSize: 20,color: Colors.red,fontWeight: FontWeight.bold),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Sign in',
                                style: TextStyle(
                                    fontSize: 27, fontWeight: FontWeight.w700),
                              ),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Color(0xff4c505b),
                                child: IconButton(
                                    color: Colors.white,
                                    onPressed: () {
                                      var user;
                                      // print(email.text+" "+password.text);
                                      Login().AuthUser(email.text,password.text).then((QuerySnapshot qs){
                                        if(qs.size > 0){
                                          email.text = "";
                                          password.text = "";
                                          setLogin(true);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Home()));
                                        }
                                        else{
                                          setError();
                                          setLogin(false);
                                          email.text = "";
                                          password.text = "";
                                        }

                                      });

                                    },
                                    icon: Icon(
                                      Icons.arrow_forward,
                                    )),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyRegister()));
                                },
                                child: Text(
                                  'Sign Up',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Color(0xff4c505b),
                                      fontSize: 18),
                                ),
                                style: ButtonStyle(),
                              ),

                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}