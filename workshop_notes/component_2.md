```
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
                          saveAmt(balance);  // After SharedPreference
                          Navigator.pop(context);

                        }, child: Text('Update'))
                      ],
                    ));
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
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
```