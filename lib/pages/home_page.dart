import 'package:expenses_tracker/components/expense_summary.dart';
import 'package:expenses_tracker/components/expense_tile.dart';
import 'package:expenses_tracker/data/expenses_data.dart';
import 'package:expenses_tracker/models/expenses_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final newExpenseNameController = TextEditingController();
  final newExpenseAmountController = TextEditingController();
  void addNewExpense (){
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Add A New Expense'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children:  [
              //expense name
              TextField(
                controller: newExpenseNameController,
              ),
              //Expense amount
              TextField(
                controller: newExpenseAmountController,
              ),
            ],
          ),
          actions: [
            MaterialButton(
              onPressed: save,
            child: const Text('Save'),
            ),
            MaterialButton(
              onPressed: cancel,
              child: const Text('Cancel'),
            ),
          ],
        )
    );
  }

  //save method
  void save(){
    //create expense item
   ExpenseItem newExpense = ExpenseItem(
       name: newExpenseNameController.text,
       amount: newExpenseAmountController.text,
       dateTime: DateTime.now()
   );
    Provider.of<ExpensesData>(context, listen: false).addNewExpense(newExpense);
   Navigator.pop(context);
   clearControllers();
  }
  // cancel method
void cancel(){
  Navigator.pop(context);
  clearControllers();
}

void clearControllers(){
    newExpenseAmountController.clear();
    newExpenseNameController.clear();
}
  @override
  Widget build(BuildContext context) {
    return Consumer<ExpensesData>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: Colors.grey[300],
        floatingActionButton: FloatingActionButton(
          onPressed: addNewExpense,
          child: const Icon(Icons.add),
        ),
        body: ListView(
          children: [
            ExpenseSummary(startOfWeek: value.startOfWeekDate()),
            ListView.builder(
              shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: value.getExpensesList().length,
                itemBuilder: (context, index) => ExpenseTile(
                    name: value.getExpensesList()[index].name,
                    amount: value.getExpensesList()[index].amount,
                    dateTime: value.getExpensesList()[index].dateTime
                )
            ),
          ],
        )
      )
    );
  }
}
