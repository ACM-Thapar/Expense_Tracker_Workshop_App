import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'transactions.dart';


final Color activeColor = Color(0xffFF2E63);
final Color inactiveColor = Color(0xff6C73AE);

class ExpenseDetails extends StatefulWidget {
  @override
  _ExpenseDetailsState createState() => _ExpenseDetailsState();
}

class _ExpenseDetailsState extends State<ExpenseDetails> {
  String selection = "";
  late SharedPreferences prefs;

  String transDesc = "";
  String transAmt = "";

  int balance = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initsharedPrefence();
  }

  void initsharedPrefence() async{
     prefs = await SharedPreferences.getInstance();
     loadData();
  }

  void saveData(){
    List<String> stringList = transactions.map(
            (item) => json.encode(item.toMap()
        )).toList();
    prefs.setStringList('list', stringList);
  }

  void saveAmt(int amt){
    prefs.setInt('balance', amt);
  }



  void loadData() {
    List<String>? listString = prefs.getStringList('list');
    balance =  prefs.getInt('balance')!;
    if(listString != null){
      transactions = listString.map(
              (item) => Transaction.fromMap(json.decode(item))
      ).toList();
      setState((){});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff010A43),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width * 0.4,
              decoration: BoxDecoration(
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
                  padding: EdgeInsets.only(
                    top: 10,
                    left: 20,
                    right: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "< Back",
                        style: TextStyle(
                          color: activeColor,
                          fontSize: 20,
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: Color(0xff0E164C),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.asset("assets/images/user.jpg"),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: (){
                    showDialog(context: context, builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)
                      ),
                      backgroundColor: Color(0xff010A43),
                      title: Text("Update Balance", style: TextStyle(fontSize: 24,color: Colors.white, fontWeight: FontWeight.bold)),
                      content: TextField(
                        onChanged: (text) {
                          balance = int.parse(text);
                        },
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                            filled: true, //<-- SEE HERE
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            hintText: 'New Balance', hintStyle: TextStyle(color: Color(0xff010A43), fontWeight:FontWeight.bold )),
                      ),
                      actions: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12), // <-- Radius
                              ),
                            ),
                            onPressed: (){
                          saveAmt(balance);
                          Navigator.pop(context);

                        }, child: Text('Update'))
                      ],
                    ));
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.asset(
                              cardList[0].image,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(30),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Main Balance",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),

                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "\$${balance}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 30,
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
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
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Transactions",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  "Sort By",
                                  style: TextStyle(
                                    color: inactiveColor,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(width: 10),

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

          showDialog(context: context, builder: (context) => Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.all(10),
              child: Stack(
                clipBehavior: Clip.none, alignment: Alignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,

                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Color(0xff010A43)
                      ),
                      padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Text("Add Transaction",
                                style: TextStyle(fontSize: 24,color: Colors.white, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center
                            ),
                            SizedBox(height: 50,),
                            TextField(
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
                                        hintText: 'Transaction Details', hintStyle: TextStyle(color: Color(0xff010A43), fontWeight:FontWeight.bold )),
                                  ),
                            SizedBox(height: 20,),
                            TextField(
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
                                  hintText: 'Transaction Amount', hintStyle: TextStyle(color: Color(0xff010A43), fontWeight:FontWeight.bold )),
                            ),
                            SizedBox(height: 20,),
                            ElevatedButton(

                              onPressed: () async{

                                transactions.insert(0, Transaction(amount: int.parse(transAmt), desc: transDesc));

                                balance = balance - int.parse(transAmt);

                                setState(() {

                                });
                                saveData();
                                saveAmt(balance);
                                Navigator.pop(context);


                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('ADD'),
                              ),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12), // <-- Radius
                                ),
                              ),
                            )


                          ],
                        ),
                      ),
                    ),
                  ),

                ],
              )
          ));
        },
        backgroundColor: Color(0xff010c86),
        child: const Icon(Icons.add),
      ),
    );
  }


}

class Cards {
  String image;
  String name;
  double amount;
  int cardNumber;

  Cards({required this.amount, required this.cardNumber, required this.image, required this.name});
}

List<Cards> cardList = [
  Cards(
    image: "assets/images/card1.png",
    amount: 4500.87,
    cardNumber: 4536,
    name: "Master Card",
  ),
  Cards(
    image: "assets/images/card2.png",
    amount: 532.71,
    cardNumber: 8137,
    name: "Visa Card",
  ),
];

class Card extends StatelessWidget {
  int index;

  Card({required this.index});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.asset(
              cardList[index].image,
              fit: BoxFit.fill,
            ),
          ),
          Container(
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cardList[index].name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.more_horiz,
                      size: 60,
                    ),
                    Text(
                      cardList[index].cardNumber.toString(),
                      style: TextStyle(
                        fontSize: 23,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "\$${cardList[index].amount}",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 30,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

List<String> listItems = ["Recent", "Amount", "Ascending", "Descending"];



List<Transaction> transactions = [
  Transaction(
    desc: "hrllo",
    amount: 100
  ),

];

class TransactionTile extends StatelessWidget {
  final String imageUrl, name;
  final double amount;
  final bool paid;

  TransactionTile({required this.amount, required this.imageUrl, required this.name, required this.paid});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(10),
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
        style: TextStyle(
          color: inactiveColor,
          fontSize: 18,
        ),
      ),
      subtitle: Status(
        status: paid,
      ),
      trailing: Text(
        "\$$amount",
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    );
  }
}

class Status extends StatelessWidget {
  bool status;
  Status({required this.status});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 5,
        right: 45,
      ),
      height: 28,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: status ? Colors.red : Colors.teal,
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
            status ? "Paid" : "Recieved",
            style: TextStyle(
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}