// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_app/expense_details.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/signinpage.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
late SharedPreferences prefs;
Future<void> signup(BuildContext context) async {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
  if (googleSignInAccount != null) {
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    final AuthCredential authCredential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    // Getting users credential
    UserCredential result = await auth.signInWithCredential(authCredential);
    prefs = await SharedPreferences.getInstance();
    User user = result.user!;
    user = auth.currentUser!;
    moveToHomePage(context);
  }
}

Future<void> SignOut(BuildContext context) async {
  await auth.signOut();
  Future.delayed(const Duration(milliseconds: 1));
  user = null;

  moveToHomePage(context);
}

void moveToHomePage(BuildContext context) {
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const ExpenseDetails()),
      (route) => false);
}

void movetosignInPage(BuildContext context) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: ((context) => const SignInScreen())));
}
