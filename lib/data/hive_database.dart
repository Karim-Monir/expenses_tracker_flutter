import 'package:hive/hive.dart';

import '../models/expenses_item.dart';

class HiveDataBase{
  // reference the box we declared in the main
  final _myBox = Hive.box("expenses_database");
  // write data
void saveData(List<ExpenseItem> allExpenses){
  /*
  * Hive can only save types of Strings and DateTime
  * so we're converting each expense object to a storable type
  */
  List<dynamic> allExpensesFormatted = [];
  for(var expense in allExpenses){
    //Convert each item to a type we can store
     List<dynamic> expensesFormatted = [
       expense.name,
       expense.amount,
       expense.dateTime
     ];
     allExpensesFormatted.add(expensesFormatted);
  }
  // now we store in the database
  _myBox.put('all expenses', allExpensesFormatted);
}

  // read data
List<ExpenseItem> readData(){
  List<dynamic> savedExpenses = _myBox.get('all expenses') ?? [];
  List<ExpenseItem> allExpenses = [];
  for(int i =0; i < savedExpenses.length; i++){
    String name = savedExpenses[i][0];
    String amount = savedExpenses[i][1];
    DateTime dateTime = savedExpenses[i][2];

    ExpenseItem expense = ExpenseItem(
        name: name,
        amount: amount,
        dateTime: dateTime
    );

    allExpenses.add(expense);
  }
  return allExpenses;
}
}