import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/controllers/signin.dart';
import 'package:flutter_app/expense_details.dart';
import 'package:flutter_app/utils/alertdialog.dart';
import 'package:intl/intl.dart';

import '../controllers/fetch_data.dart';
import '../transactions.dart';

List<SplitTransaction> splitTransactions = [];

class SplitExpenseDetails extends StatefulWidget {
  int id;
  SplitExpenseDetails({super.key, required this.id});

  @override
  State<SplitExpenseDetails> createState() => _SplitExpenseDetailsState();
}

class _SplitExpenseDetailsState extends State<SplitExpenseDetails> {
  //  final Connectivity _connectivity = Connectivity();
  final FirebaseAuth auth = FirebaseAuth.instance;

  User? user;

  void initGetData() async {
    splitTransactions = await getAllSplitWise();
    // print(splitTransactions);

    SplitTransaction data;
    for (int i = 0; i < splitTransactions.length; i++) {
      // print(splitTransactions[i].id);
      if (splitTransactions[i].id == widget.id) {
        data = splitTransactions[i];

        splitTransactions.clear();

        splitTransactions.add(data);
        setState(() {});
        break;
      }
    }
  }

  void initState() {
    if (auth.currentUser != null) {
      user = auth.currentUser!;
    }
    getAllData();
    initGetData();

    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: ((context) => ExpenseDetails())));
        return Future.delayed(Duration.zero);
      },
      child: Material(
        color: const Color(0xff010A43),
        child: Center(
          child: ListView.builder(
            // reverse: true,
            itemBuilder: (ctx, i) => SplitTile(
                amount: splitTransactions[0].amount,
                desc: splitTransactions[0].desc,
                people: splitTransactions[0].people,
                noOfPeople: splitTransactions[0].noOfPeople,
                totalAmount: splitTransactions[0].totalAmount,
                given: splitTransactions[0].given),
            itemCount: splitTransactions.length,
          ),
        ),
      ),
    );
  }
}

class SplitTile extends StatefulWidget {
  String desc;

  double amount;
  // String time;
  // String type;
  var people;
  int noOfPeople;
  var totalAmount;
  var given;
  // int id;

  SplitTile(
      {required this.amount,
      required this.desc,
      // required this.time,
      // required this.type,
      required this.people,
      required this.noOfPeople,
      required this.totalAmount,
      // required this.id,
      required this.given});

  @override
  State<SplitTile> createState() => _SplitTileState();
}

class _SplitTileState extends State<SplitTile> {
  Future<void> saveData(int index) async {
    User? user;
    user = auth.currentUser!;
    String type = 'splitwise';

    int data1 = 0;
    data1 = transactionData?.total as int;
    final fi = FirebaseFirestore.instance.collection('users').doc(user.email);
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String formatted = formatter.format(now);
    fi.collection('transactions').doc('${data1 + 1}').set({
      "description": "Paid by ${splitTransactions[0].people[index]}",
      "Amount": splitTransactions[0].totalAmount[index],
      "time": formatted,
      "type": 'income',
      "id": data1 + 1,
    }, SetOptions(merge: false));

    fi
        .collection('splitwise')
        .doc('${splitTransactions[0].id}')
        .update({'given': splitTransactions[0].given});
    int currId = splitTransactions[0].id;
    setState(() {});
    double? balance = transactionData?.totalAmount;

    balance = (balance! + splitTransactions[0].totalAmount[index]);

    setAmountData(balance, data1 + 1);

    getAllData();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
      color: const Color(0xff010A43),
      child: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              height: 40,
              child: Text(
                ' Description : ${widget.desc.toUpperCase()}',
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              height: 40,
              child: Text(
                ' Total Amount : ${widget.amount}',
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Container(
            height: 600,
            child: Expanded(
              child: ListView.builder(
                // padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                itemBuilder: ((context, i) => Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color:
                                  widget.given[i] ? Colors.green : Colors.red,
                              borderRadius: BorderRadius.circular(15)),
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(15, 4, 0, 4),
                                child: Column(
                                  children: [
                                    Text(
                                      'Person ${i + 1}: ${widget.people[i]}',
                                      // textAlign: TextAlign.justify,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Amount : ${double.parse('${widget.totalAmount[i]}').toStringAsFixed(2)}',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  widget.given[i]
                                      ? null
                                      : showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                backgroundColor:
                                                    const Color(0xff010A43),
                                                title: const Text(
                                                    "Update Details",
                                                    style: TextStyle(
                                                        fontSize: 24,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                actions: [
                                                  ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Colors.white,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  3), // <-- Radius
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          splitTransactions[0]
                                                              .given[i] = true;
                                                        });
                                                        setState(() {});
                                                        Navigator.pop(context);
                                                        saveData(i);

                                                        setState(() {});
                                                        // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SplitExpenseDetails(id: splitTransactions[0].id)), (route) => false));
                                                        Navigator.pushAndRemoveUntil(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    SplitExpenseDetails(
                                                                        id: splitTransactions[0]
                                                                            .id)),
                                                            (route) => false);
                                                      },
                                                      child: const Text(
                                                        'Paid',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      )),
                                                  ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Colors.white,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  3), // <-- Radius
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text(
                                                        'Send Message',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ))
                                                ],
                                              ));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    widget.given[i]
                                        ? Icons.check_circle
                                        : Icons.pending,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    )),
                itemCount: widget.noOfPeople,
              ),
            ),
          )
        ],
      ),
    );
  }
}
