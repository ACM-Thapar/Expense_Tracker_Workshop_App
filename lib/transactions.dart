class Transactions {
  String desc;

  double amount;
  String time;
  String type;

  Transactions(
      {required this.amount,
      required this.desc,
      required this.time,
      required this.type});

  Transactions.fromMap(Map map)
      : desc = map['description'],
        amount = double.parse('${map['Amount']}'),
        time = map['time'],
        type = map['type'];

  Map toMap() {
    return {'description': desc, 'Amount': amount, 'time': time, 'type': type};
  }
}
