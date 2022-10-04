//SignInScreen

// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_app/controllers/signin.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

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
                margin: const EdgeInsets.only(
                    top: 200, bottom: 200, left: 30, right: 30),
                elevation: 20,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
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
                                    ? const Text(
                                        "Sign Out",
                                        style: TextStyle(fontSize: 18),
                                      )
                                    : const Text(
                                        "Sign In with Google",
                                        style: TextStyle(fontSize: 18),
                                      )
                              ],
                            ),
                            onPressed: () {
                              setState(() {
                                auth.currentUser == null
                                    ? signup(context)
                                    : SignOut(context);
                              });
                            },
                          ))
                    ]))));
  }
}
