import 'package:flutter/material.dart';

import '../models/transaction.dart';
import 'package:intl/intl.dart';
import '../models/chart_model.dart';
import 'chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  const Chart(this.recentTransactions, {super.key});

  List<ChartModel> get groupTransactionValues {
    return List.generate(7, (index) {
      final weekday = DateTime.now().subtract(Duration(days: index));
      var totalSum = 0.0;
      for (var el in recentTransactions) {
        if (el.date.day == weekday.day &&
            el.date.month == weekday.month &&
            el.date.year == weekday.year) {
          totalSum += el.amount;
        }
      }
      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekday.day) {}
      }
      return ChartModel(
          day: DateFormat.E().format(weekday).substring(0, 1),
          amount: totalSum);
    }).reversed.toList();
  }

  double get totalSpending =>
      groupTransactionValues.fold(0.0, (a, b) => a + b.amount);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: groupTransactionValues
              .map((e) => Flexible(
                    fit: FlexFit.tight,
                    child: ChartBar(
                      label: e.day,
                      spendingAmount: e.amount,
                      spendingPercentage:
                          totalSpending == 0 ? 0 : e.amount / totalSpending,
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
