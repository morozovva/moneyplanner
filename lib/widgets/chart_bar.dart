import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double spendingPercentage;

  const ChartBar(
      {super.key,
      required this.label,
      required this.spendingAmount,
      required this.spendingPercentage});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: [
          SizedBox(
            height: constraints.maxHeight * 0.12,
            child: FittedBox(
              child: Text("${spendingAmount.toStringAsFixed(0)}₽"),
            ),
          ),
          SizedBox(
            height: constraints.maxHeight * 0.05,
          ),
          SizedBox(
            height: constraints.maxHeight * 0.66,
            width: 10,
            child: Stack(children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1.0),
                  color: const Color.fromRGBO(220, 220, 220, 1),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              FractionallySizedBox(
                heightFactor: spendingPercentage,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              )
            ]),
          ),
          SizedBox(
            height: constraints.maxHeight * 0.05,
          ),
          SizedBox(
            height: constraints.maxHeight * 0.12,
            child: FittedBox(
              child: Text(label),
            ),
          ),
        ],
      );
    });
  }
}
