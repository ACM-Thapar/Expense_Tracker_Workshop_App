```

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
                                InkWell(
                                  onTap:(){
                                    prefs.clear();
                                    transactions.clear();
                                    balance = 0;
                                    setState(() {

                                    });
                                  },
                                  child: Text(
                                    "Clear All",
                                    style: TextStyle(
                                      color: inactiveColor,
                                      fontSize: 18,
                                    ),
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

```