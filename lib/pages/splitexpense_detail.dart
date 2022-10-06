import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../controllers/fetch_data.dart';
import '../transactions.dart';

class SplitExpenseDetails extends StatefulWidget {
  int id;
  SplitExpenseDetails({super.key, required this.id});

  @override
  State<SplitExpenseDetails> createState() => _SplitExpenseDetailsState();
}

class _SplitExpenseDetailsState extends State<SplitExpenseDetails> {
  //  final Connectivity _connectivity = Connectivity();
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<SplitTransaction> splitTransactions = [];

  User? user;
  void initGetData() async {
    splitTransactions = await getAllSplitWise();
    print(splitTransactions);

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

    initGetData();

    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
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
    );
  }
}

class SplitTile extends StatelessWidget {
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
                ' Description : ${desc.toUpperCase()}',
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
                ' Total Amount : ${amount}',
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
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
                              color: given[i] ? Colors.green : Colors.red,
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
                                      'Person ${i + 1}: ${people[i]}',
                                      // textAlign: TextAlign.justify,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Amount : ${double.parse('${totalAmount[i]}').toStringAsFixed(2)}',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  given[i] ? Icons.check_circle : Icons.pending,
                                  size: 40,
                                  color: Colors.white,
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
                itemCount: noOfPeople,
              ),
            ),
          )
        ],
      ),
    );
  }

  // @override
}
