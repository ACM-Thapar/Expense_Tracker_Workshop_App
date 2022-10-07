// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, depend_on_referenced_packages, prefer_const_constructors

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/controllers/fetch_data.dart';
import 'package:flutter_app/controllers/signin.dart';
import 'package:flutter_app/pages/expense_add.dart';
import 'package:flutter_app/pages/splitexpense_detail.dart';
import 'package:flutter_app/utils/alertdialog.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'transactions.dart';

bool isNoInternet = true;
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
  final Connectivity _connectivity = Connectivity();
  final FirebaseAuth auth = FirebaseAuth.instance;
  late TabController _tabController;

  // String selection = "";

  // String transDesc = "";
  // String transAmt = "";

  double balance = 0;

  void initsharedPrefence() async {
    transactions = await getAllData2();

    print(transactions);

    setState(() {});

    balance = await getAllData();
    setState(() {});
    if (auth.currentUser == null) {
    } else {
      user = auth.currentUser!;
    }
  }

  @override
  void initState() {
    _connectivity.onConnectivityChanged.listen(
      (event) {
        if (event == ConnectivityResult.none) {
          isNoInternet = true;
          setState(() {});
        } else {
          isNoInternet = false;
          setState(() {});
        }
      },
    );
    _tabController = TabController(length: 4, vsync: this);
    _tabController.animateTo(2);
    setState(() {});
    if (auth.currentUser != null) {
      user = auth.currentUser!;
    }

    initsharedPrefence();

    setState(() {});
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return isNoInternet
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
        : Scaffold(
            backgroundColor: const Color(0xff010A43),
            body: SafeArea(
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
                                        borderRadius:
                                            BorderRadius.circular(15)),
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
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      12), // <-- Radius
                                            ),
                                          ),
                                          onPressed: () {
                                            // saveAmt(balance);
                                            setState(() {});
                                            setAmountData(
                                                balance,
                                                transactionData == null
                                                    ? 1000000000
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
                                      backgroundImage: NetworkImage(
                                          user?.photoURL as String),
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
                              Text(
                                'Split',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 320,
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              ListView.builder(
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
                                                  'expense' ||
                                              transactions[transactions.length -
                                                          i -
                                                          1]
                                                      .type ==
                                                  'splitwise'
                                          ? true
                                          : false,
                                ),
                                itemCount: transactions.length,
                              ),
                              ListView.builder(
                                // reverse: true,
                                itemBuilder: (ctx, i) =>
                                    transactions[transactions.length - i - 1]
                                                .type ==
                                            'expense'
                                        ? TransactionTile(
                                            amount: transactions[
                                                    transactions.length - i - 1]
                                                .amount
                                                .toDouble(),
                                            date: transactions[
                                                    transactions.length - i - 1]
                                                .time,
                                            name: transactions[
                                                    transactions.length - i - 1]
                                                .desc,
                                            paid: transactions[transactions
                                                                .length -
                                                            i -
                                                            1]
                                                        .type ==
                                                    'expense'
                                                ? true
                                                : false,
                                          )
                                        : SizedBox(),
                                itemCount: transactions.length,
                              ),
                              ListView.builder(
                                // reverse: true,
                                itemBuilder: (ctx, i) =>
                                    transactions[transactions.length - i - 1]
                                                .type ==
                                            'income'
                                        ? TransactionTile(
                                            amount: transactions[
                                                    transactions.length - i - 1]
                                                .amount
                                                .toDouble(),
                                            date: transactions[
                                                    transactions.length - i - 1]
                                                .time,
                                            name: transactions[
                                                    transactions.length - i - 1]
                                                .desc,
                                            paid: false,
                                          )
                                        : SizedBox(),
                                itemCount: transactions.length,
                              ),
                              ListView.builder(
                                // reverse: true,
                                itemBuilder: (ctx, i) => transactions[
                                                transactions.length - i - 1]
                                            .type ==
                                        'splitwise'
                                    ? InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SplitExpenseDetails(
                                                          id: transactions[
                                                                  transactions
                                                                          .length -
                                                                      i -
                                                                      1]
                                                              .id)));
                                        },
                                        child: TransactionTile(
                                          amount: transactions[
                                                  transactions.length - i - 1]
                                              .amount
                                              .toDouble(),
                                          date: transactions[
                                                  transactions.length - i - 1]
                                              .time,
                                          name: transactions[
                                                  transactions.length - i - 1]
                                              .desc,
                                          paid: true,
                                        ),
                                      )
                                    : SizedBox(),
                                itemCount: transactions.length,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                user == null
                    ? dialogbox(context)
                    : Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => ExpensseAdd()));
              },
              backgroundColor: const Color(0xff010c86),
              child: const Icon(Icons.add),
            ),
          );
  }
}

List<Transactions> transactions = [];

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
        "₹${amount.toStringAsFixed(2)}",
        style: const TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    );
  }
}
