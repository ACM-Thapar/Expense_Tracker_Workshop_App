//SignInScreen

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/controllers/signin.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInScreen extends StatefulWidget {
// SignInScreen({Key key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.deepPurpleAccent,
                  Colors.blue[600] as Color,
                  Colors.deepPurple,
                  Colors.black,
                ],
              ),
            ),
            child: Card(
                margin:
                    EdgeInsets.only(top: 200, bottom: 200, left: 30, right: 30),
                elevation: 20,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "ACM THAPER LOGIN",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: MaterialButton(
                            color: Colors.white,
                            height: 60,
                            elevation: 10,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // ),
                                auth.currentUser != null
                                    ? Text(
                                        "Sign Out",
                                        style: TextStyle(fontSize: 18),
                                      )
                                    : Text(
                                        "Sign In with Google",
                                        style: TextStyle(fontSize: 18),
                                      )
                              ],
                            ),
                            onPressed: () {
                              auth.currentUser == null
                                  ? signup(context)
                                  : SignOut(context);
                            },
                          ))
                    ]))));
  }
}
