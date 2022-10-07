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
  bool isSame = true;
  bool isSplitwise = false;
  Color col = Colors.white;
  Color col2 = Colors.blue;
  int noofPeople = 3;
  late int data1;
  final List<String> _mesaures = [
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
  ];
  @override
  void initState() {
    if (transactionData == null) {
      data1 = 1000000000;
    } else {
      data1 = transactionData?.total as int;
    }
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

    if (user == null) {
      return;
    }
    String type = 'expense';
    if (isIncome) {
      setState(() {
        type = 'income';
      });
    } else if (isSame) {
      type = 'splitwise';
    } else if (isSplitwise) {
      type = 'splitwise';
      transAmt = '$totalAm';
    }

    final fi = FirebaseFirestore.instance.collection('users').doc(user?.email);
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String formatted = formatter.format(now);

    fi.collection('transactions').doc('${data1 + 1}').set({
      "description": transDesc,
      "Amount": double.parse(transAmt),
      "time": formatted,
      "type": type,
      "id": data1 + 1
    }, SetOptions(merge: false));
    isSplitwise
        ? fi.collection('splitwise').doc('${data1 + 1}').set({
            "description": transDesc,
            "Amount": totalAm,
            "time": formatted,
            "type": type,
            "id": data1 + 1,
            'people': name,
            'totalPeople': noofPeople,
            'amountForEach': amount,
            'given': given
          }, SetOptions(merge: false))
        : null;

    setAmountData(balance, data1 + 1);
    getAllData();
  }

  String transDesc = "";
  String transAmt = "";
  var name = ['', '', ''];
  List<bool> given = [true, false, false];
  List<double> amount = [0, 0, 0];
  double balance = 0;
  double totalAm = 0;

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
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text("Add Transaction",
                        style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        print(name);
                        print(amount);
                        transactions.insert(
                            transactions.length,
                            Transactions(
                                amount: isSplitwise
                                    ? totalAm
                                    : double.parse(transAmt),
                                desc: transDesc,
                                time: '${DateTime.now().day}',
                                type: isIncome ? 'income' : 'expense',
                                id: data1 + 1));
                        balance = await getAllData();
                        isIncome
                            ? balance = balance + double.parse(transAmt)
                            : isSplitwise
                                ? balance = balance - totalAm
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
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          isIncome = false;
                          isSplitwise = false;
                          isSame = true;
                          changeColor();
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 2, color: col2)),
                        height: 60,
                        width: MediaQuery.of(context).size.width / 3.2,
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
                          isSplitwise = false;
                          isSame = true;
                          changeColor();
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(width: 2, color: col)),
                        height: 60,
                        width: MediaQuery.of(context).size.width / 3.2,
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
                    InkWell(
                      onTap: () {
                        setState(() {
                          col = Colors.white;
                          col2 = Colors.white;
                          isSplitwise = true;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.purpleAccent,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                width: 2,
                                color: isSplitwise
                                    ? Colors.lightBlueAccent
                                    : Colors.white)),
                        height: 60,
                        width: MediaQuery.of(context).size.width / 3.2,
                        child: Center(
                            child: Text(
                          "SplitWise",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isSplitwise
                                  ? Colors.lightBlueAccent
                                  : Colors.white),
                        )),
                      ),
                    ),
                  ],
                ),
                // SizedBox(
                //   height: 10,
                // ),

                const SizedBox(
                  height: 20,
                ),
                isSplitwise
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                isSame = true;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: isSame
                                      ? Colors.lightBlueAccent
                                      : Colors.amber,
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10)),
                                  border: Border.all(
                                    // width: 2,
                                    color: Colors.white,
                                  )),
                              height: 30,
                              width: MediaQuery.of(context).size.width / 4,
                              child: const Center(
                                  child: Text(
                                "SameAmount",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                for (int i = 0; i < noofPeople; i++) {
                                  amount[i] = 0;
                                }
                                totalAm = 0;

                                isSame = false;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: isSame
                                      ? Colors.amber
                                      : Colors.lightBlueAccent,
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      bottomRight: Radius.circular(10)),
                                  border: Border.all(
                                    // width: 2,
                                    color: Colors.white,
                                  )),
                              height: 30,
                              width: MediaQuery.of(context).size.width / 4,
                              child: const Center(
                                  child: Text(
                                "CustomAmount",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )),
                            ),
                          ),
                        ],
                      )
                    : SizedBox(),
                SizedBox(
                  height: 10,
                ),
                isSplitwise
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            "NO Of People :",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                            height: 32,
                            decoration: BoxDecoration(
                                color: Colors.amber,
                                border:
                                    Border.all(width: 1, color: Colors.white),
                                borderRadius: BorderRadius.circular(10)),
                            child: DropdownButton(
                              items: _mesaures
                                  .map((String value) =>
                                      DropdownMenuItem<String>(
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 10.00,
                                            ),
                                            Text(value,
                                                style: TextStyle(
                                                    fontSize: 20.00,
                                                    color: Colors.black)),
                                            SizedBox(
                                              width: 10.00,
                                            ),
                                          ],
                                        ),
                                        value: value,
                                      ))
                                  .toList(),
                              iconSize: 15,
                              elevation: 16,
                              icon: Icon(
                                Icons.arrow_drop_down_sharp,
                                size: 40,
                              ),
                              underline: Container(
                                decoration: BoxDecoration(),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  noofPeople = int.parse('$value');
                                  if (noofPeople > name.length) {
                                    for (int i = name.length;
                                        i < noofPeople;
                                        i++) {
                                      name.add('');
                                      amount.add(0);
                                      given.add(false);
                                    }
                                  } else if (noofPeople < name.length) {
                                    int j = name.length;
                                    for (int i = noofPeople; i < j; i++) {
                                      name.removeLast();
                                      amount.removeLast();
                                      given.removeLast();
                                    }
                                  }
                                  if (isSame && transAmt != '') {
                                    totalAm = double.parse(transAmt);
                                    for (int i = 0; i < noofPeople; i++) {
                                      amount[i] =
                                          double.parse(transAmt) / noofPeople;
                                    }
                                  }

                                  setState(() {});
                                });
                              },
                              value: '$noofPeople',
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(),
                Container(
                  width: MediaQuery.of(context).size.width / 1.1,
                  child: TextField(
                    // keyboardAppearance: ,
                    onChanged: (text) {
                      text == '' ? transDesc = '' : transDesc = text;
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
                isSame
                    ? Container(
                        width: MediaQuery.of(context).size.width / 1.1,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          onChanged: (text) {
                            setState(() {
                              transAmt = text;
                              totalAm = double.parse(transAmt);
                              for (int i = 0; i < noofPeople; i++) {
                                amount[i] = double.parse(transAmt) / noofPeople;
                              }
                            });
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
                      )
                    : Text(
                        "Total Amount Is : $totalAm",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                SizedBox(
                  height: 20,
                ),
                isSplitwise
                    ? Expanded(
                        child: ListView.builder(
                          // reverse: true,
                          itemBuilder: (ctx, i) => Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 1.1,
                                child: TextField(
                                  onChanged: (text) {
                                    setState(() {
                                      name[i] = text;
                                    });
                                  },
                                  cursorColor: Colors.white,
                                  decoration: InputDecoration(
                                      filled: true, //<-- SEE HERE
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      hintText: 'Person ${i + 1} ',
                                      hintStyle: const TextStyle(
                                          color: Color(0xff010A43),
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              isSame
                                  ? SizedBox()
                                  : Container(
                                      width: MediaQuery.of(context).size.width /
                                          1.1,
                                      child: TextField(
                                        onChanged: (text) {
                                          amount[i] = double.parse(text);
                                          totalAm = 0;
                                          for (int j = 0; j < noofPeople; j++) {
                                            totalAm = totalAm + amount[j];
                                          }
                                        },
                                        cursorColor: Colors.white,
                                        decoration: InputDecoration(
                                            filled: true, //<-- SEE HERE
                                            fillColor: Colors.white,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            hintText: 'Amount',
                                            hintStyle: const TextStyle(
                                                color: Color(0xff010A43),
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                          itemCount: noofPeople,
                        ),
                      )
                    : SizedBox(),
                // const SizedBox(
                //   height: 20,
                // ),
              ],
            )));
  }
}
