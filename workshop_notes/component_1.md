```

Scaffold(
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
                        "F.R.O.S.H",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        "A.C.M",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                ),
               
              ],
            ),
          )

        ],
      ),
      
    );
    
```