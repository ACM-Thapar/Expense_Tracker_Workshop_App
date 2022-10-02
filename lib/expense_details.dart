// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/signinpage.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'transactions.dart';

const Color activeColor = Color(0xffFF2E63);
const Color inactiveColor = Color(0xff6C73AE);

class ExpenseDetails extends StatefulWidget {
  const ExpenseDetails({super.key});

  @override
  _ExpenseDetailsState createState() => _ExpenseDetailsState();
}

class _ExpenseDetailsState extends State<ExpenseDetails> {
  String selection = "";
  late SharedPreferences prefs;

  String transDesc = "";
  String transAmt = "";
  User? user;
  int balance = 0;

  @override
  void initState() {
    if (auth.currentUser != null) {
      user = auth.currentUser!;
    }
    initsharedPrefence();
    setState(() {});
    super.initState();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  void initsharedPrefence() async {
    prefs = await SharedPreferences.getInstance();
    loadData();

    if (auth.currentUser == null) {
    } else {
      user = auth.currentUser!;
    }
  }

  void saveData() {
    List<String> stringList =
        transactions.map((item) => json.encode(item.toMap())).toList();
    prefs.setStringList('list', stringList);
  }

  void saveAmt(int amt) {
    prefs.setInt('balance', amt);
  }

  void loadData() {
    List<String>? listString = prefs.getStringList('list');
    if (prefs.getInt('balance') == null) {
      balance = 0;
    } else {
      balance = prefs.getInt('balance') as int;
    }
    // balance =  prefs.getInt('balance')!;
    if (listString != null) {
      transactions = listString
          .map((item) => Transaction.fromMap(json.decode(item)))
          .toList();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff010A43),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width * 0.4,
              decoration: const BoxDecoration(
                color: Color(0xff0E164C),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(100),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
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
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: ((context) => SignInScreen())));
                            },
                            child: user?.displayName != null
                                ? Text(
                                    '${user?.displayName}',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  )
                                : const Text(
                                    'Hello ',
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
                    showDialog(
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
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: false, signed: false),
                                onChanged: (text) {
                                  if (text == '') {
                                    balance = 0;
                                  } else {
                                    balance = int.parse(text);
                                  }
                                },
                                cursorColor: Colors.white,
                                decoration: InputDecoration(
                                    filled: true, //<-- SEE HERE
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
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
                                      saveAmt(balance);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Update'))
                              ],
                            ));
                  },
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
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
                                  Text(
                                    "\$$balance",
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
                                        backgroundImage: NetworkImage(
                                            user?.photoURL as String),
                                      )),
                          ],
                        ),
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
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
                                    prefs.clear();
                                    transactions.clear();
                                    balance = 0;
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
                        Expanded(
                          child: ListView.builder(
                            itemBuilder: (ctx, i) => TransactionTile(
                              amount: transactions[i].amount.toDouble(),
                              imageUrl: "assets/images/friend1.jpg",
                              name: transactions[i].desc,
                              paid: true,
                            ),
                            itemCount: transactions.length,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => Dialog(
                  backgroundColor: Colors.transparent,
                  insetPadding: const EdgeInsets.all(10),
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: const Color(0xff010A43)),
                          padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                const Text("Add Transaction",
                                    style: TextStyle(
                                        fontSize: 24,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center),
                                const SizedBox(
                                  height: 50,
                                ),
                                TextField(
                                  onChanged: (text) {
                                    transDesc = text;
                                  },
                                  cursorColor: Colors.white,
                                  decoration: InputDecoration(
                                      filled: true, //<-- SEE HERE
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      hintText: 'Transaction Details',
                                      hintStyle: const TextStyle(
                                          color: Color(0xff010A43),
                                          fontWeight: FontWeight.bold)),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextField(
                                  onChanged: (text) {
                                    transAmt = text;
                                  },
                                  cursorColor: Colors.white,
                                  decoration: InputDecoration(
                                      filled: true, //<-- SEE HERE
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      hintText: 'Transaction Amount',
                                      hintStyle: const TextStyle(
                                          color: Color(0xff010A43),
                                          fontWeight: FontWeight.bold)),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    transactions.insert(
                                        0,
                                        Transaction(
                                            amount: int.parse(transAmt),
                                            desc: transDesc));

                                    balance = balance - int.parse(transAmt);

                                    setState(() {});
                                    saveData();
                                    saveAmt(balance);
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          12), // <-- Radius
                                    ),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('ADD'),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )));
        },
        backgroundColor: const Color(0xff010c86),
        child: const Icon(Icons.add),
      ),
    );
  }
}

List<Transaction> transactions = [];

class TransactionTile extends StatelessWidget {
  final String imageUrl, name;
  final double amount;
  final bool paid;

  const TransactionTile(
      {super.key,
      required this.amount,
      required this.imageUrl,
      required this.name,
      required this.paid});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(10),
      leading: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Image.asset(imageUrl),
        ),
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
          color: Colors.red,
        ),
        child: Row(
          children: const [
            SizedBox(width: 3),
            Icon(
              Icons.check_circle,
              color: Colors.white,
            ),
            SizedBox(width: 5),
            Text(
              "Paid",
              style: TextStyle(
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
      trailing: Text(
        "\$$amount",
        style: const TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    );
  }
}
