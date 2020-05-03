import 'package:flutter/material.dart';
import 'package:personal_expense_app/models/transaction.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense_app/widgets/chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;
  Chart(this.recentTransactions);

  //create a getter of type list to return a fixed sized for our chart
  List<Map<String, Object>> get groupedTransactionsValues {
    return List.generate(7, (index) {
      //grouping out tr

      final weekDay = DateTime.now().subtract(Duration(days: index));
      double totalSum = 0.0;

      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }
      // DateFormat.E formats the weekday objaect
      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum
      };
    }).reversed.toList();
  }

  double get maxSpending {
    //fold helps to change a list intoanother type
    return groupedTransactionsValues.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionsValues.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                data['day'],
                data['amount'],
                maxSpending == 0.0
                    ? 0.0
                    : (data['amount'] as double) / maxSpending,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
