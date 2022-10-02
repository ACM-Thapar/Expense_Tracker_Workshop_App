import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/expense_details.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

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

    User user = result.user!;
    user = auth.currentUser!;
    print(user.displayName);

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ExpenseDetails()),
        (route) => false);
  }
}

Future<void> SignOut(BuildContext context) async {
  auth.signOut();
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => ExpenseDetails()),
      (route) => false);
}
