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
  final newExpenseEGPAmountController = TextEditingController();
  final newExpensePiastersAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //prepare data
    Provider.of<ExpensesData>(context, listen: false).prepareData();
  }

  void addNewExpense() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Add A New Expense'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //expense name
                  TextField(
                    controller: newExpenseNameController,
                    decoration: const InputDecoration(
                      hintText: 'Expense Name',
                    ),
                  ),
                  //Expense amount
                  Row(
                    children: [
                      // EGP amount
                      Expanded(
                        child: TextField(
                          controller: newExpenseEGPAmountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'EGP',
                          ),
                        ),
                      ),
                      //Piasters
                      Expanded(
                        child: TextField(
                          controller: newExpensePiastersAmountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Piasters',
                          ),
                        ),
                      ),
                    ],
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
            ));
  }

  //save method
  void save() {
    // only save expense if all fields are filled
    if (newExpenseNameController.text.isNotEmpty &&
        newExpenseEGPAmountController.text.isNotEmpty &&
        newExpensePiastersAmountController.text.isNotEmpty) {
      // put EGP and Piasters together
      String amount =
          '${newExpenseEGPAmountController.text}.${newExpensePiastersAmountController.text}';
      //create expense item
      ExpenseItem newExpense = ExpenseItem(
          name: newExpenseNameController.text,
          amount: amount,
          dateTime: DateTime.now());
      Provider.of<ExpensesData>(context, listen: false)
          .addNewExpense(newExpense);
    }
    Navigator.pop(context);
    clearControllers();
  }

  // cancel method
  void cancel() {
    Navigator.pop(context);
    clearControllers();
  }

// delete an expense
  void deleteExpense(ExpenseItem expense) {
    Provider.of<ExpensesData>(context, listen: false).deleteExpense(expense);
  }

  void clearControllers() {
    newExpenseEGPAmountController.clear();
    newExpensePiastersAmountController.clear();
    newExpenseNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpensesData>(
        builder: (context, value, child) => Scaffold(
            backgroundColor: Colors.grey[300],
            floatingActionButton: FloatingActionButton(
              onPressed: addNewExpense,
              backgroundColor: Colors.black,
              child: const Icon(Icons.add),
            ),
            body: ListView(
              children: [
                ExpenseSummary(startOfWeek: value.startOfWeekDate()),
                const SizedBox(
                  height: 20.0,
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: value.getExpensesList().length,
                    itemBuilder: (context, index) => ExpenseTile(
                          name: value.getExpensesList()[index].name,
                          amount: value.getExpensesList()[index].amount,
                          dateTime: value.getExpensesList()[index].dateTime,
                          deleteTapped: (p0) =>
                              deleteExpense(value.getExpensesList()[index]),
                        )),
              ],
            )));
  }
}
