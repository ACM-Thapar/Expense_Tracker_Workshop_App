import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/transactions.dart';
import 'package:intl/intl.dart';

import '../controllers/fetch_data.dart';
import '../expense_details.dart';

class ExpensseAdd extends StatefulWidget {
  const ExpensseAdd({super.key});

  @override
  State<ExpensseAdd> createState() => _ExpensseAddState();
}

class _ExpensseAddState extends State<ExpensseAdd> {
  final Connectivity _connectivity = Connectivity();
  void changeColor() {
    if (isIncome) {
      setState(() {
        col = Colors.blue;
        col2 = Colors.white;
      });
    } else {
      setState(() {
        col = Colors.white;
        col2 = Colors.blue;
      });
    }
  }

  bool isIncome = false;
  bool InternetCheck = false;
  Color col = Colors.white;
  Color col2 = Colors.blue;
  @override
  void initState() {
    _connectivity.onConnectivityChanged.listen(
      (event) {
        if (event == ConnectivityResult.none) {
          setState(() {
            InternetCheck = true;
          });
        } else {
          setState(() {
            InternetCheck = false;
          });
        }
      },
    );
    setState(() {});
    super.initState();
    setState(() {});
  }

  Future<void> saveData() async {
    // balance = await getAllData();
    int data1;
    if (transactionData == null) {
      data1 = 1000000000;
    } else {
      data1 = transactionData?.total as int;
    }
    if (user == null) {
      return;
    }
    String type = 'expense';
    if (isIncome) {
      setState(() {
        type = 'income';
      });
    }
    final fi = FirebaseFirestore.instance.collection('users').doc(user?.email);
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String formatted = formatter.format(now);
    fi.collection('transactions').doc('${data1 + 1}').set({
      "description": transDesc,
      "Amount": double.parse(transAmt),
      "time": formatted,
      "type": type
    }, SetOptions(merge: false));

    setAmountData(balance, data1 + 1);
    getAllData();
  }

  String transDesc = "";
  String transAmt = "";

  double balance = 0;
  @override
  Widget build(BuildContext context) {
    return InternetCheck
        ? Material(
            color: const Color(0xff010A43),
            child: Center(
              child: Text(
                "No Internet Connection. Please Connect To Internet To Continue.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
            ),
          )
        : Material(
            color: Color(0xff0E164C),
            child: SafeArea(
                child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                const Text("Add Transaction",
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          isIncome = false;
                          changeColor();
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 2, color: col2)),
                        height: 60,
                        width: MediaQuery.of(context).size.width / 2.2,
                        child: Center(
                            child: Text(
                          "Expense",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: col2),
                        )),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isIncome = true;
                          changeColor();
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 2, color: col)),
                        height: 60,
                        width: MediaQuery.of(context).size.width / 2.2,
                        child: Center(
                            child: Text(
                          "Income",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: col),
                        )),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.1,
                  child: TextField(
                    onChanged: (text) {
                      transDesc = text;
                    },
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                        filled: true, //<-- SEE HERE
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintText: 'Transaction Details',
                        hintStyle: const TextStyle(
                            color: Color(0xff010A43),
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.1,
                  child: TextField(
                    onChanged: (text) {
                      transAmt = text;
                    },
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                        filled: true, //<-- SEE HERE
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintText: 'Transaction Amount',
                        hintStyle: const TextStyle(
                            color: Color(0xff010A43),
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    transactions.insert(
                        transactions.length,
                        Transactions(
                            amount: double.parse(transAmt),
                            desc: transDesc,
                            time: '${DateTime.now().day}',
                            type: isIncome ? 'income' : 'expense'));
                    balance = await getAllData();
                    isIncome
                        ? balance = balance + double.parse(transAmt)
                        : balance = balance - double.parse(transAmt);

                    setState(() {});
                    saveData();
                    setState(() {});
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ExpenseDetails()),
                        (route) => false);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // <-- Radius
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('ADD'),
                  ),
                )
              ],
            )));
  }
}
