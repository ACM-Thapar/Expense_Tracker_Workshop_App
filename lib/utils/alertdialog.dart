import 'package:flutter/material.dart';
import 'package:flutter_app/controllers/signin.dart';

void dialogbox(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            backgroundColor: const Color(0xff010A43),
            title: const Text("Please Login First !!!",
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // <-- Radius
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    movetosignInPage(context);
                  },
                  child: const Text('Okey....'))
            ],
          ));
}
