class Transactions {
  String desc;

  double amount;
  String time;
  String type;
  int id;

  Transactions(
      {required this.amount,
      required this.desc,
      required this.time,
      required this.type,
      required this.id});

  Transactions.fromMap(Map map)
      : desc = map['description'],
        amount = double.parse('${map['Amount']}'),
        time = map['time'],
        type = map['type'],
        id = map['id'];

  Map toMap() {
    return {
      'description': desc,
      'Amount': amount,
      'time': time,
      'type': type,
      'id': id
    };
  }
}

class SplitTransaction {
  String desc;

  double amount;
  String time;
  String type;
  var people;
  int noOfPeople;
  var totalAmount;
  var given;
  int id;

  SplitTransaction(
      {required this.amount,
      required this.desc,
      required this.time,
      required this.type,
      required this.people,
      required this.noOfPeople,
      required this.totalAmount,
      required this.id,
      required this.given});

  SplitTransaction.fromMap(Map map)
      : desc = map['description'],
        amount = double.parse('${map['Amount']}'),
        time = map['time'],
        type = map['type'],
        people = map['people'],
        noOfPeople = map['totalPeople'],
        totalAmount = map['amountForEach'],
        id = map['id'],
        given = map['given'];

  Map toMap() {
    return {
      'description': desc,
      'Amount': amount,
      'time': time,
      'type': type,
      'people': people,
      'totalPeople': noOfPeople,
      'amountForEach': totalAmount,
      'id': id,
      'given': given
    };
  }
}
