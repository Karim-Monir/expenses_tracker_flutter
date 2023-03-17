import 'package:expenses_tracker/data/hive_database.dart';
import 'package:flutter/cupertino.dart';
import '../date_time/date_time_helper.dart';
import '../models/expenses_item.dart';

class ExpensesData extends ChangeNotifier{
  //list of all expenses
  List<ExpenseItem> allExpenses = [];

  //get expenses list
  List<ExpenseItem> getExpensesList (){
    return allExpenses;

  }

  //add new expense
void addNewExpense(ExpenseItem newExpense){
  allExpenses.add(newExpense);
  notifyListeners();
  db.saveData(allExpenses);

}
  //delete expense
void deleteExpense(ExpenseItem expense){
  allExpenses.remove(expense);
  notifyListeners();
  db.saveData(allExpenses);
}

//prepare data to display
  final db = HiveDataBase();
  void prepareData(){
    //check if there is data
    if(db.readData().isNotEmpty){
      allExpenses = db.readData();
    }

  }

  //get weekday from a datetime object
String getDayName(DateTime dateTime){
    switch(dateTime.weekday){
      case 1:
        return 'Sat';
      case 2:
        return 'Sun';
      case 3:
        return 'Mon';
      case 4:
        return 'Tue';
      case 5:
        return 'Wed';
      case 6:
        return 'Thu';
      case 7:
        return 'Fri';
      default: return '';
    }
}


  //get the date for the start of the week
DateTime startOfWeekDate(){
  DateTime? startOfWeek;
  //get today's date
  DateTime today = DateTime.now();

  //go backwards from today to find Saturday
  for(int i = 0; i < 7; i++){
    if(getDayName(today.subtract(Duration(days: i)))== 'Thu'){
      startOfWeek = today.subtract(Duration(days: i));
    }
  }
return startOfWeek!;
}


Map<String, double> calculateDailySummary(){
  Map<String, double> dailySummary = {
    // date (yyyymmdd) : TotalAmountOfDay
  };
  for(var expense in allExpenses){
    String date = convertDateTimeToString(expense.dateTime);
    double amount = double.parse(expense.amount);

    if(dailySummary.containsKey(date)){
      double currentAmount = dailySummary[date]!;
      currentAmount += amount;
      dailySummary[date] = currentAmount;
    } else {
      dailySummary.addAll({date : amount});
    }
  }
  return dailySummary;
}


}