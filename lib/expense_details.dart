// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, depend_on_referenced_packages, prefer_const_constructors

import 'package:flutter/gestures.dart';
import 'package:flutter_app/controllers/fetch_data.dart';
import 'package:flutter_app/controllers/signin.dart';
import 'package:flutter_app/pages/expense_add.dart';
import 'package:flutter_app/utils/alertdialog.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'transactions.dart';

const Color activeColor = Color(0xffFF2E63);
const Color inactiveColor = Color(0xff6C73AE);
User? user;

class ExpenseDetails extends StatefulWidget {
  const ExpenseDetails({super.key});

  @override
  _ExpenseDetailsState createState() => _ExpenseDetailsState();
}

class _ExpenseDetailsState extends State<ExpenseDetails>
    with TickerProviderStateMixin {
  late TabController _tabController;
  Future<void> saveData() async {
    int data1;
    if (transactionData == null) {
      data1 = 1000000000;
    } else {
      data1 = transactionData?.total as int;
    }
    if (user == null) {
      return;
    }
    final fi = FirebaseFirestore.instance.collection('users').doc(user?.email);
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(now);
    fi.collection('transactions').doc('${data1 + 1}').set({
      "description": transDesc,
      "Amount": double.parse(transAmt),
      "time": formatted
    }, SetOptions(merge: false));
    setAmountData(balance, data1 + 1);
    getAllData();
  }

  String selection = "";

  String transDesc = "";
  String transAmt = "";

  double balance = 0;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _tabController.animateTo(2);
    setState(() {});
    if (auth.currentUser != null) {
      user = auth.currentUser!;
    }

    initsharedPrefence();

    setState(() {});
    super.initState();
    setState(() {});
    // saveData();
  }

  // void saveData() async {
  //   prefs = await SharedPreferences.getInstance();
  //   if (user == null) {
  //     return;
  //   }
  //   List<String> stringList =
  //       transactions.map((item) => json.encode(item.toMap())).toList();
  //   prefs.setStringList('list', stringList);
  //   print(prefs.getStringList('list'));
  // }

  final FirebaseAuth auth = FirebaseAuth.instance;

  void initsharedPrefence() async {
    transactions = await getAllData2();
    income = await getAllIncome();
    expense = await getAllExpense();

    setState(() {});

    balance = await getAllData();
    setState(() {});
    if (auth.currentUser == null) {
    } else {
      user = auth.currentUser!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff010A43),
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 20,
                      right: 20,
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "A.C.M",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          InkWell(
                            onTap: () {
                              movetosignInPage(context);
                            },
                            child: user != null
                                ? Text(
                                    '${user?.displayName}',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  )
                                : const Text(
                                    'Login Here',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ])),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    user == null
                        ? dialogbox(context)
                        : showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  backgroundColor: const Color(0xff010A43),
                                  title: const Text("Update Balance",
                                      style: TextStyle(
                                          fontSize: 24,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                  content: TextField(
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: false, signed: false),
                                    onChanged: (text) {
                                      if (text == '') {
                                        balance = 0;
                                      } else {
                                        balance = double.parse(text);
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
                                        hintText: 'New Balance',
                                        hintStyle: const TextStyle(
                                            color: Color(0xff010A43),
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  actions: [
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                12), // <-- Radius
                                          ),
                                        ),
                                        onPressed: () {
                                          // saveAmt(balance);
                                          setState(() {});
                                          setAmountData(
                                              balance,
                                              transactionData == null
                                                  ? 0
                                                  : transactionData?.total
                                                      as int);

                                          Navigator.pop(context);
                                          setState(() {});
                                        },
                                        child: const Text('Update'))
                                  ],
                                ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      // vertical: 10,
                      horizontal: 20,
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.asset(
                            "assets/images/card1.png",
                            fit: BoxFit.fill,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(30),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Main Balance",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              // balance.toStringAsFixed(2)
                              Text(
                                "₹${balance.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 30,
                                ),
                              )
                            ],
                          ),
                        ),
                        Positioned(
                            top: 20,
                            left: MediaQuery.of(context).size.width / 1.4,
                            child: auth.currentUser == null
                                ? const CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.grey,
                                  )
                                : CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    radius: 30,
                                    backgroundImage:
                                        NetworkImage(user?.photoURL as String),
                                  )),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Color(0xff0E164C),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 5,
                        width: 100,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Transactions",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  transactions.clear();
                                  balance = 0;
                                  removeAllData();
                                  // loadData();
                                  getAllData();
                                  setState(() {});
                                },
                                child: const Text(
                                  "Clear All",
                                  style: TextStyle(
                                    color: inactiveColor,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: TabBar(
                          controller: _tabController,
                          isScrollable: true,
                          dragStartBehavior: DragStartBehavior.down,
                          tabs: const [
                            Text(
                              'All',
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              'Expense',
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              'Income',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 2.15,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            Expanded(
                              child: ListView.builder(
                                // reverse: true,
                                itemBuilder: (ctx, i) => TransactionTile(
                                  amount:
                                      transactions[transactions.length - i - 1]
                                          .amount
                                          .toDouble(),
                                  date:
                                      transactions[transactions.length - i - 1]
                                          .time,
                                  name:
                                      transactions[transactions.length - i - 1]
                                          .desc,
                                  paid:
                                      transactions[transactions.length - i - 1]
                                                  .type ==
                                              'expense'
                                          ? true
                                          : false,
                                ),
                                itemCount: transactions.length,
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                // reverse: true,
                                itemBuilder: (ctx, i) => TransactionTile(
                                    amount: expense[expense.length - i - 1]
                                        .amount
                                        .toDouble(),
                                    date: expense[expense.length - i - 1].time,
                                    name: expense[expense.length - i - 1].desc,
                                    paid: true),
                                itemCount: expense.length,
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                // reverse: true,
                                itemBuilder: (ctx, i) => TransactionTile(
                                  amount: income[income.length - i - 1]
                                      .amount
                                      .toDouble(),
                                  date: income[income.length - i - 1].time,
                                  name: income[income.length - i - 1].desc,
                                  paid: income[income.length - i - 1].type ==
                                          'expense'
                                      ? true
                                      : false,
                                ),
                                itemCount: income.length,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            user == null
                ? dialogbox(context)
                : Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ExpensseAdd()));
            // : showDialog(
            //     context: context,
            //     builder: (context) => Dialog(
            //         backgroundColor: Colors.transparent,
            //         insetPadding: const EdgeInsets.all(10),
            //         child: Stack(
            //           clipBehavior: Clip.none,
            //           alignment: Alignment.center,
            //           children: <Widget>[
            //             Padding(
            //               padding: const EdgeInsets.all(8.0),
            //               child: Container(
            //                 width: double.infinity,
            //                 decoration: BoxDecoration(
            //                     borderRadius: BorderRadius.circular(15),
            //                     color: const Color(0xff010A43)),
            //                 padding:
            //                     const EdgeInsets.fromLTRB(20, 50, 20, 20),
            //                 child: SingleChildScrollView(
            //                   child: Column(
            //                     children: [
            //                       const Text("Add Transaction",
            //                           style: TextStyle(
            //                               fontSize: 24,
            //                               color: Colors.white,
            //                               fontWeight: FontWeight.bold),
            //                           textAlign: TextAlign.center),
            //                       const SizedBox(
            //                         height: 50,
            //                       ),
            //                       TextField(
            //                         onChanged: (text) {
            //                           transDesc = text;
            //                         },
            //                         cursorColor: Colors.white,
            //                         decoration: InputDecoration(
            //                             filled: true, //<-- SEE HERE
            //                             fillColor: Colors.white,
            //                             border: OutlineInputBorder(
            //                               borderRadius:
            //                                   BorderRadius.circular(10.0),
            //                             ),
            //                             hintText: 'Transaction Details',
            //                             hintStyle: const TextStyle(
            //                                 color: Color(0xff010A43),
            //                                 fontWeight: FontWeight.bold)),
            //                       ),
            //                       const SizedBox(
            //                         height: 20,
            //                       ),
            //                       TextField(
            //                         onChanged: (text) {
            //                           transAmt = text;
            //                         },
            //                         cursorColor: Colors.white,
            //                         decoration: InputDecoration(
            //                             filled: true, //<-- SEE HERE
            //                             fillColor: Colors.white,
            //                             border: OutlineInputBorder(
            //                               borderRadius:
            //                                   BorderRadius.circular(10.0),
            //                             ),
            //                             hintText: 'Transaction Amount',
            //                             hintStyle: const TextStyle(
            //                                 color: Color(0xff010A43),
            //                                 fontWeight: FontWeight.bold)),
            //                       ),
            //                       const SizedBox(
            //                         height: 20,
            //                       ),
            //                       ElevatedButton(
            //                         onPressed: () async {
            //                           transactions.insert(
            //                               transactions.length,
            //                               Transactions(
            //                                   amount: int.parse(transAmt),
            //                                   desc: transDesc,
            //                                   time: '${DateTime.now().day}'));

            //                           balance = balance - int.parse(transAmt);

            //                           setState(() {});
            //                           saveData();
            //                           setState(() {});
            //                           Navigator.pop(context);
            //                         },
            //                         style: ElevatedButton.styleFrom(
            //                           shape: RoundedRectangleBorder(
            //                             borderRadius: BorderRadius.circular(
            //                                 12), // <-- Radius
            //                           ),
            //                         ),
            //                         child: const Padding(
            //                           padding: EdgeInsets.all(8.0),
            //                           child: Text('ADD'),
            //                         ),
            //                       )
            //                     ],
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           ],
            //         )));
          },
          backgroundColor: const Color(0xff010c86),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

List<Transactions> transactions = [];
List<Transactions> income = [];
List<Transactions> expense = [];

class TransactionTile extends StatelessWidget {
  final String date, name;
  final double amount;
  final bool paid;

  const TransactionTile({
    super.key,
    required this.amount,
    required this.date,
    required this.name,
    required this.paid,
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(10),
      leading: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: paid ? Colors.red : Colors.green,
          borderRadius: BorderRadius.circular(30),
        ),
        // child:  ColoredBox(color: paid ? Colors.red : Colors.green),
      ),
      title: Text(
        name,
        style: const TextStyle(
          color: inactiveColor,
          fontSize: 18,
        ),
      ),
      subtitle: Container(
        margin: const EdgeInsets.only(
          top: 5,
          right: 45,
        ),
        height: 28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: paid ? Colors.red : Colors.green,
        ),
        child: Row(
          children: [
            SizedBox(width: 3),
            Icon(
              Icons.check_circle,
              color: Colors.white,
            ),
            SizedBox(width: 5),
            Text(
              date,
              style: TextStyle(
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
      trailing: Text(
        "₹$amount",
        style: const TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    );
  }
}
