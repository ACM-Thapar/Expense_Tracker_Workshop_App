class Transaction {

  String desc;

  int amount;

  Transaction({required this.amount, required this.desc});

  Transaction.fromMap(Map map):
      this.desc = map['desc'],
      this.amount = map['amount'];

  Map toMap(){
    return{
      'desc':this.desc,
      'amount':this.amount
    };
  }
}