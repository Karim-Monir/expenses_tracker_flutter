import 'package:expenses_tracker/bar_graph/bar_graph.dart';
import 'package:expenses_tracker/data/expenses_data.dart';
import 'package:expenses_tracker/date_time/date_time_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseSummary extends StatelessWidget {
  final DateTime startOfWeek;
  const ExpenseSummary({Key? key, required this.startOfWeek}) : super(key: key);

  // a method to readjust the bar max
  double calculateMax(
      ExpensesData value,
      String saturday,
      String sunday,
      String monday,
      String tuesday,
      String wednesday,
      String thursday,
      String friday,
      ){
    double? max = 100;
    List<double> values = [
      value.calculateDailySummary()[saturday] ?? 0,
      value.calculateDailySummary()[sunday] ?? 0,
      value.calculateDailySummary()[monday] ?? 0,
      value.calculateDailySummary()[tuesday] ?? 0,
      value.calculateDailySummary()[wednesday] ?? 0,
      value.calculateDailySummary()[thursday] ?? 0,
      value.calculateDailySummary()[friday] ?? 0,
    ];
    //sort amounts from smallest to largest
    values.sort();

    //get the largest amount
    // increase the cap slightly so the graph looks almost full
    max = values.last * 1.1;
    return max == 0 ? 100 : max;
  }

  // Calculate the weekly total
  String calculateWeeklyTotal(
      ExpensesData value,
      String saturday,
      String sunday,
      String monday,
      String tuesday,
      String wednesday,
      String thursday,
      String friday,
      ){
    List<double> values = [
      value.calculateDailySummary()[saturday] ?? 0,
      value.calculateDailySummary()[sunday] ?? 0,
      value.calculateDailySummary()[monday] ?? 0,
      value.calculateDailySummary()[tuesday] ?? 0,
      value.calculateDailySummary()[wednesday] ?? 0,
      value.calculateDailySummary()[thursday] ?? 0,
      value.calculateDailySummary()[friday] ?? 0,
    ];
    double total = 0;
    for(int i= 0; i < values.length; i++){
      total += values[i];
    }
    return total.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    String saturday = convertDateTimeToString(startOfWeek.add(const Duration(days: 0)));
    String sunday = convertDateTimeToString(startOfWeek.add(const Duration(days: 1)));
    String monday = convertDateTimeToString(startOfWeek.add(const Duration(days: 2)));
    String tuesday = convertDateTimeToString(startOfWeek.add(const Duration(days: 3)));
    String wednesday = convertDateTimeToString(startOfWeek.add(const Duration(days: 4)));
    String thursday = convertDateTimeToString(startOfWeek.add(const Duration(days: 5)));
    String friday = convertDateTimeToString(startOfWeek.add(const Duration(days: 6)));
    return Consumer<ExpensesData>(
      builder: (context, value, child) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                const Text('Week Total: ', style: TextStyle(fontWeight: FontWeight.bold),),
                Text('${calculateWeeklyTotal(value, saturday, sunday, monday, tuesday, wednesday, thursday, friday)} EGP'),

              ],
            ),
          ),
          SizedBox(
            height: 200,
            child: MyBarGraph(
                maxY: calculateMax(
                    value,
                    saturday,
                    sunday,
                    monday,
                    tuesday,
                    wednesday,
                    thursday,
                    friday
                ),
                satAmount: value.calculateDailySummary()[saturday] ?? 0,
                sunAmount: value.calculateDailySummary()[sunday] ?? 0,
                monAmount: value.calculateDailySummary()[monday] ?? 0,
                tueAmount: value.calculateDailySummary()[tuesday] ?? 0,
                wedAmount: value.calculateDailySummary()[wednesday] ?? 0,
                thuAmount: value.calculateDailySummary()[thursday] ?? 0,
                friAmount: value.calculateDailySummary()[friday] ?? 0
            ),
          ),
        ],
      ),
    );
  }
}
