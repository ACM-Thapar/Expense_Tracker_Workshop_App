import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/controllers/signin.dart';
import 'package:flutter_app/transactions.dart';

import '../expense_details.dart';

TransactionData? transactionData;

class TransactionData {
  int total;
  int totalAmount;
  TransactionData({required this.total, required this.totalAmount});
  TransactionData.fromMap(Map map)
      : total = map['totalTransactions'],
        totalAmount = map['totalAmount'];
}

Future<int> getAllData() async {
  await Future.delayed(const Duration(milliseconds: 1));
  var val = await FirebaseFirestore.instance
      .collection('users')
      .doc(user?.email)
      .get();
  if (val.data() == null) {
    return 0;
  }
  transactionData = TransactionData.fromMap(
      Map<String, dynamic>.from(val.data() as Map<String, dynamic>));
  // await Future.delayed(const Duration(milliseconds: 1));
  // print(transactionData?.total);
  return transactionData?.totalAmount as int;
}

Future<List<Transactions>> getAllData2() async {
  if (user == null) {
    return [];
  }
  await Future.delayed(const Duration(milliseconds: 1));
  user = auth.currentUser!;
  var val = await FirebaseFirestore.instance
      .collection('users')
      .doc(user?.email)
      .collection('transactions')
      .get();
  var documents = val.docs;
  if (documents.isNotEmpty) {
    return documents.map((document) {
      Transactions bookingList =
          Transactions.fromMap(Map<String, dynamic>.from(document.data()));

      return bookingList;
    }).toList();
  }
  return [];
}

Future<void> removeAllData() async {
  await Future.delayed(const Duration(milliseconds: 1));
  await FirebaseFirestore.instance
      .collection('users')
      .doc(user?.email)
      .delete();
  var collections = FirebaseFirestore.instance
      .collection('users')
      .doc(user?.email)
      .collection('transactions');
  // var collection = FirebaseFirestore.instance.collection('collection');
  var snapshots = await collections.get();
  for (var doc in snapshots.docs) {
    await doc.reference.delete();
  }
  getAllData();
}

void setAmountData(int balance, int data1) async {
  final fi = FirebaseFirestore.instance.collection('users').doc(user?.email);

  fi.set({"totalAmount": balance, "totalTransactions": data1});
  getAllData();
}
