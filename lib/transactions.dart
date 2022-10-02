class Transaction {
  String desc;

  int amount;

  Transaction({required this.amount, required this.desc});

  Transaction.fromMap(Map map)
      : desc = map['desc'],
        amount = map['amount'];

  Map toMap() {
    return {'desc': desc, 'amount': amount};
  }
}
