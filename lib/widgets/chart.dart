import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/Transaction.dart';
import './chart_bar.dart';


class Chart extends StatelessWidget {

  final List<Transaction> recentTransactions;

  const Chart({Key? key, required this.recentTransactions}) : super(key: key);

  List<Map<String, Object>> get groupedTransactionValues {

    final result = {};
    for (var value in recentTransactions) {
      String dayString = value.date.year.toString() + '-' + value.date.month.toString() + '-' + value.date.day.toString();
      result[dayString] != null ? result[dayString] += value.amount : result[dayString] = value.amount;
    }

    return List.generate(7, (index)  {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      final weekDayString = weekDay.year.toString() + '-' + weekDay.month.toString() + '-' + weekDay.day.toString();

      return {'day': DateFormat.E().format(weekDay).substring(0, 1), 'amount': result[weekDayString] == null ? 0.0 : result[weekDayString] } ;
      

    });
  }

  double get totalSpending {
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + (item['amount'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: groupedTransactionValues.map((data) {
          return Flexible(
            fit: FlexFit.tight,
            child: ChartBar(
              label: data['day'] as String,
              spendingAmount: data['amount'] as double,
              spendingPctOfTotal: totalSpending == 0.0 ? 0.0 : (data['amount'] as double) / totalSpending
            ),
          );
        }).toList()
      )
    );
  }
}
































