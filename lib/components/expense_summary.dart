import 'package:expenses_tracker/bar_graph/bar_graph.dart';
import 'package:expenses_tracker/data/expenses_data.dart';
import 'package:expenses_tracker/date_time/date_time_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseSummary extends StatelessWidget {
  final DateTime startOfWeek;
  const ExpenseSummary({Key? key, required this.startOfWeek}) : super(key: key);

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
      builder: (context, value, child) => SizedBox(
        height: 200,
        child: MyBarGraph(
            maxY: 1000,
            satAmount: value.calculateDailySummary()[saturday] ?? 0,
            sunAmount: value.calculateDailySummary()[sunday] ?? 0,
            monAmount: value.calculateDailySummary()[monday] ?? 0,
            tueAmount: value.calculateDailySummary()[tuesday] ?? 0,
            wedAmount: value.calculateDailySummary()[wednesday] ?? 0,
            thuAmount: value.calculateDailySummary()[thursday] ?? 0,
            friAmount: value.calculateDailySummary()[friday] ?? 0
        ),
      ),
    );
  }
}
