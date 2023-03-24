import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    super.key,
    required this.transaction,
    required this.deleteTx,
  });

  final Transaction transaction;
  final Function deleteTx;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(5),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          child: FittedBox(
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Text(
                "${transaction.amount.toStringAsFixed(2)}₽",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    // fontSize: 16,
                    color: Colors.green),
              ),
            ),
          ),
        ),
        title: Text(
          transaction.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          DateFormat("yMEd", "en_US")
              // .add_jms()
              .format(transaction.date),
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
        trailing: MediaQuery.of(context).size.width > 360
            ? TextButton.icon(
                onPressed: () => deleteTx(transaction.id),
                icon: const Icon(Icons.delete),
                label: const Text("Delete"),
              )
            : IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => deleteTx(transaction.id),
              ),
      ),
    );
  }
}
