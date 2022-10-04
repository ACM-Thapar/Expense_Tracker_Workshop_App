class Transactions {
  String desc;

  int amount;
  String time;

  Transactions({required this.amount, required this.desc, required this.time});

  Transactions.fromMap(Map map)
      : desc = map['description'],
        amount = map['Amount'],
        time = map['time'];

  Map toMap() {
    return {
      'description': desc,
      'Amount': amount,
      'time': time,
    };
  }
}
