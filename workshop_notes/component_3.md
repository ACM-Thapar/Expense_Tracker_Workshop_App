```

List<Transaction> transactions = [];

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
      subtitle: Container(
        margin: EdgeInsets.only(
          top: 5,
          right: 45,
        ),
        height: 28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.red,
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
              "Paid",
              style: TextStyle(
                color: Colors.white,
              ),
            )
          ],
        ),
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



```