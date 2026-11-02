// // import 'package:flutter/material.dart';

// // void main() {
// //   runApp(const MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   const MyApp({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       title: 'Expense Manager',
// //       home: const ExpensePage(),
// //     );
// //   }
// // }

// // class Expense {
// //   String amount;
// //   String category;
// //   String description;
// //   String date;

// //   Expense({
// //     required this.amount,
// //     required this.category,
// //     required this.description,
// //     required this.date,
// //   });
// // }

// // class ExpensePage extends StatefulWidget {
// //   const ExpensePage({super.key});

// //   @override
// //   State<ExpensePage> createState() => _ExpensePageState();
// // }

// // class _ExpensePageState extends State<ExpensePage> {
// //   List<Expense> expenses = [];

// //   final amountController = TextEditingController();
// //   final descriptionController = TextEditingController();

// //   String category = 'Food';
// //   DateTime selectedDate = DateTime.now();

// //   // Add expense
// //   void addExpense() {
// //     if (amountController.text.isEmpty) {
// //       return;
// //     }

// //     Expense expense = Expense(
// //       amount: amountController.text,
// //       category: category,
// //       description: descriptionController.text,
// //       date:
// //           '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
// //     );

// //     setState(() {
// //       expenses.add(expense);
// //     });

// //     clearForm();
// //   }

// //   // Edit expense
// //   void editExpense(int index) {
// //     amountController.text = expenses[index].amount;
// //     descriptionController.text = expenses[index].description;

// //     String oldCategory = expenses[index].category;

// //     showDialog(
// //       context: context,
// //       builder: (context) {
// //         String editCategory = oldCategory;

// //         return AlertDialog(
// //           title: const Text('Edit Expense'),
// //           content: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               TextField(
// //                 controller: amountController,
// //                 keyboardType: TextInputType.number,
// //                 decoration: const InputDecoration(
// //                   labelText: 'Amount',
// //                 ),
// //               ),

// //               TextField(
// //                 controller: descriptionController,
// //                 decoration: const InputDecoration(
// //                   labelText: 'Description',
// //                 ),
// //               ),

// //               DropdownButton<String>(
// //                 value: editCategory,
// //                 items: const [
// //                   DropdownMenuItem(
// //                     value: 'Food',
// //                     child: Text('Food'),
// //                   ),
// //                   DropdownMenuItem(
// //                     value: 'Travel',
// //                     child: Text('Travel'),
// //                   ),
// //                   DropdownMenuItem(
// //                     value: 'Shopping',
// //                     child: Text('Shopping'),
// //                   ),
// //                   DropdownMenuItem(
// //                     value: 'Other',
// //                     child: Text('Other'),
// //                   ),
// //                 ],
// //                 onChanged: (value) {
// //                   editCategory = value!;
// //                 },
// //               ),
// //             ],
// //           ),
// //           actions: [
// //             TextButton(
// //               onPressed: () {
// //                 setState(() {
// //                   expenses[index].amount = amountController.text;
// //                   expenses[index].description =
// //                       descriptionController.text;
// //                   expenses[index].category = editCategory;
// //                 });

// //                 clearForm();

// //                 Navigator.pop(context);
// //               },
// //               child: const Text('Update'),
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }

// //   // Delete expense
// //   void deleteExpense(int index) {
// //     setState(() {
// //       expenses.removeAt(index);
// //     });
// //   }

// //   // Clear form
// //   void clearForm() {
// //     amountController.clear();
// //     descriptionController.clear();

// //     setState(() {
// //       category = 'Food';
// //       selectedDate = DateTime.now();
// //     });
// //   }

// //   // Select date
// //   Future<void> selectDate() async {
// //     DateTime? date = await showDatePicker(
// //       context: context,
// //       initialDate: selectedDate,
// //       firstDate: DateTime(2020),
// //       lastDate: DateTime(2030),
// //     );

// //     if (date != null) {
// //       setState(() {
// //         selectedDate = date;
// //       });
// //     }
// //   }

// //   // Calculate total
// //   double getTotal() {
// //     double total = 0;

// //     for (var expense in expenses) {
// //       total += double.tryParse(expense.amount) ?? 0;
// //     }

// //     return total;
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Personal Expense Manager'),
// //       ),

// //       body: Padding(
// //         padding: const EdgeInsets.all(15),

// //         child: Column(
// //           children: [

// //             // Amount
// //             TextField(
// //               controller: amountController,
// //               keyboardType: TextInputType.number,
// //               decoration: const InputDecoration(
// //                 labelText: 'Amount',
// //                 border: OutlineInputBorder(),
// //               ),
// //             ),

// //             const SizedBox(height: 10),

// //             // Category
// //             DropdownButtonFormField<String>(
// //               value: category,
// //               decoration: const InputDecoration(
// //                 labelText: 'Category',
// //                 border: OutlineInputBorder(),
// //               ),
// //               items: const [
// //                 DropdownMenuItem(
// //                   value: 'Food',
// //                   child: Text('Food'),
// //                 ),
// //                 DropdownMenuItem(
// //                   value: 'Travel',
// //                   child: Text('Travel'),
// //                 ),
// //                 DropdownMenuItem(
// //                   value: 'Shopping',
// //                   child: Text('Shopping'),
// //                 ),
// //                 DropdownMenuItem(
// //                   value: 'Other',
// //                   child: Text('Other'),
// //                 ),
// //               ],
// //               onChanged: (value) {
// //                 setState(() {
// //                   category = value!;
// //                 });
// //               },
// //             ),

// //             const SizedBox(height: 10),

// //             // Description
// //             TextField(
// //               controller: descriptionController,
// //               decoration: const InputDecoration(
// //                 labelText: 'Description',
// //                 border: OutlineInputBorder(),
// //               ),
// //             ),

// //             const SizedBox(height: 10),

// //             // Date
// //             Row(
// //               children: [
// //                 Text(
// //                   'Date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
// //                 ),

// //                 const SizedBox(width: 10),

// //                 ElevatedButton(
// //                   onPressed: selectDate,
// //                   child: const Text('Select Date'),
// //                 ),
// //               ],
// //             ),

// //             const SizedBox(height: 10),

// //             // Add button
// //             ElevatedButton(
// //               onPressed: addExpense,
// //               child: const Text('Add Expense'),
// //             ),

// //             const SizedBox(height: 10),

// //             // Total
// //             Text(
// //               'Total Expense: ₹${getTotal().toStringAsFixed(2)}',
// //               style: const TextStyle(
// //                 fontSize: 20,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),

// //             const SizedBox(height: 10),

// //             // List
// //             Expanded(
// //               child: ListView.builder(
// //                 itemCount: expenses.length,

// //                 itemBuilder: (context, index) {
// //                   return Card(
// //                     child: ListTile(
// //                       title: Text(
// //                         '₹${expenses[index].amount} - '
// //                         '${expenses[index].category}',
// //                       ),

// //                       subtitle: Text(
// //                         '${expenses[index].description}\n'
// //                         'Date: ${expenses[index].date}',
// //                       ),

// //                       isThreeLine: true,

// //                       trailing: Row(
// //                         mainAxisSize: MainAxisSize.min,
// //                         children: [

// //                           // Edit
// //                           IconButton(
// //                             icon: const Icon(Icons.edit),
// //                             onPressed: () {
// //                               editExpense(index);
// //                             },
// //                           ),

// //                           // Delete
// //                           IconButton(
// //                             icon: const Icon(Icons.delete),
// //                             onPressed: () {
// //                               deleteExpense(index);
// //                             },
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   );
// //                 },
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }


// // any 2 form 1st  : Income Tracking

// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Income Expense Manager',
//       home: const HomePage(),
//     );
//   }
// }

// class Transaction {
//   String amount;
//   String type;
//   String description;
//   String date;

//   Transaction({
//     required this.amount,
//     required this.type,
//     required this.description,
//     required this.date,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'amount': amount,
//       'type': type,
//       'description': description,
//       'date': date,
//     };
//   }

//   factory Transaction.fromMap(Map<String, dynamic> map) {
//     return Transaction(
//       amount: map['amount'],
//       type: map['type'],
//       description: map['description'],
//       date: map['date'],
//     );
//   }
// }

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   List<Transaction> transactions = [];

//   final amountController = TextEditingController();
//   final descriptionController = TextEditingController();

//   String type = 'Expense';

//   @override
//   void initState() {
//     super.initState();
//     loadData();
//   }

//   // Save data
//   Future<void> saveData() async {
//     SharedPreferences prefs =
//         await SharedPreferences.getInstance();

//     List<String> data = transactions
//         .map((item) => jsonEncode(item.toMap()))
//         .toList();

//     await prefs.setStringList('transactions', data);
//   }

//   // Load data
//   Future<void> loadData() async {
//     SharedPreferences prefs =
//         await SharedPreferences.getInstance();

//     List<String>? data =
//         prefs.getStringList('transactions');

//     if (data != null) {
//       setState(() {
//         transactions = data
//             .map((item) =>
//                 Transaction.fromMap(jsonDecode(item)))
//             .toList();
//       });
//     }
//   }

//   // Add transaction
//   void addTransaction() {
//     if (amountController.text.isEmpty) {
//       return;
//     }

//     Transaction transaction = Transaction(
//       amount: amountController.text,
//       type: type,
//       description: descriptionController.text,
//       date:
//           '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
//     );

//     setState(() {
//       transactions.add(transaction);
//     });

//     saveData();

//     amountController.clear();
//     descriptionController.clear();
//   }

//   // Delete
//   void deleteTransaction(int index) {
//     setState(() {
//       transactions.removeAt(index);
//     });

//     saveData();
//   }

//   // Total income
//   double getIncome() {
//     double total = 0;

//     for (var item in transactions) {
//       if (item.type == 'Income') {
//         total += double.tryParse(item.amount) ?? 0;
//       }
//     }

//     return total;
//   }

//   // Total expense
//   double getExpense() {
//     double total = 0;

//     for (var item in transactions) {
//       if (item.type == 'Expense') {
//         total += double.tryParse(item.amount) ?? 0;
//       }
//     }

//     return total;
//   }

//   // Balance
//   double getBalance() {
//     return getIncome() - getExpense();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Income Expense Manager'),
//       ),

//       body: Padding(
//         padding: const EdgeInsets.all(15),

//         child: Column(
//           children: [

//             // Amount
//             TextField(
//               controller: amountController,
//               keyboardType: TextInputType.number,
//               decoration: const InputDecoration(
//                 labelText: 'Amount',
//                 border: OutlineInputBorder(),
//               ),
//             ),

//             const SizedBox(height: 10),

//             // Description
//             TextField(
//               controller: descriptionController,
//               decoration: const InputDecoration(
//                 labelText: 'Description',
//                 border: OutlineInputBorder(),
//               ),
//             ),

//             const SizedBox(height: 10),

//             // Income / Expense
//             DropdownButtonFormField<String>(
//               value: type,
//               decoration: const InputDecoration(
//                 labelText: 'Type',
//                 border: OutlineInputBorder(),
//               ),
//               items: const [
//                 DropdownMenuItem(
//                   value: 'Income',
//                   child: Text('Income'),
//                 ),
//                 DropdownMenuItem(
//                   value: 'Expense',
//                   child: Text('Expense'),
//                 ),
//               ],
//               onChanged: (value) {
//                 setState(() {
//                   type = value!;
//                 });
//               },
//             ),

//             const SizedBox(height: 10),

//             // Add button
//             ElevatedButton(
//               onPressed: addTransaction,
//               child: const Text('Add Transaction'),
//             ),

//             const SizedBox(height: 15),

//             // Income
//             Text(
//               'Total Income: ₹${getIncome().toStringAsFixed(2)}',
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),

//             // Expense
//             Text(
//               'Total Expense: ₹${getExpense().toStringAsFixed(2)}',
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),

//             // Balance
//             Text(
//               'Balance: ₹${getBalance().toStringAsFixed(2)}',
//               style: const TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),

//             const SizedBox(height: 10),

//             // List
//             Expanded(
//               child: ListView.builder(
//                 itemCount: transactions.length,

//                 itemBuilder: (context, index) {
//                   return Card(
//                     child: ListTile(
//                       title: Text(
//                         '₹${transactions[index].amount} - '
//                         '${transactions[index].type}',
//                       ),

//                       subtitle: Text(
//                         '${transactions[index].description}\n'
//                         'Date: ${transactions[index].date}',
//                       ),

//                       isThreeLine: true,

//                       trailing: IconButton(
//                         icon: const Icon(Icons.delete),
//                         onPressed: () {
//                           deleteTransaction(index);
//                         },
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// // Application 2 — Search & Category Filter post 2 

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Search',
      home: const ExpensePage(),
    );
  }
}

class Expense {
  String amount;
  String category;
  String description;

  Expense({
    required this.amount,
    required this.category,
    required this.description,
  });
}

class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key});

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {

  List<Expense> expenses = [];

  final amountController = TextEditingController();
  final descriptionController = TextEditingController();
  final searchController = TextEditingController();

  String category = 'Food';
  String selectedCategory = 'All';
  String searchText = '';

  // Add expense
  void addExpense() {

    if (amountController.text.isEmpty) {
      return;
    }

    Expense expense = Expense(
      amount: amountController.text,
      category: category,
      description: descriptionController.text,
    );

    setState(() {
      expenses.add(expense);
    });

    amountController.clear();
    descriptionController.clear();
  }

  // Delete expense
  void deleteExpense(int index) {

    setState(() {
      expenses.removeAt(index);
    });
  }

  // Total
  double getTotal() {

    double total = 0;

    for (var expense in expenses) {
      total += double.tryParse(expense.amount) ?? 0;
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {

    // Filter list
    List<Expense> filteredExpenses =
        expenses.where((expense) {

      bool searchMatch =
          expense.description
              .toLowerCase()
              .contains(searchText);

      bool categoryMatch =
          selectedCategory == 'All' ||
          expense.category == selectedCategory;

      return searchMatch && categoryMatch;

    }).toList();

    return Scaffold(

      appBar: AppBar(
        title: const Text('Expense Search'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(15),

        child: Column(
          children: [

            // Amount
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            // Category
            DropdownButtonFormField<String>(
              value: category,

              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),

              items: const [
                DropdownMenuItem(
                  value: 'Food',
                  child: Text('Food'),
                ),

                DropdownMenuItem(
                  value: 'Travel',
                  child: Text('Travel'),
                ),

                DropdownMenuItem(
                  value: 'Shopping',
                  child: Text('Shopping'),
                ),

                DropdownMenuItem(
                  value: 'Other',
                  child: Text('Other'),
                ),
              ],

              onChanged: (value) {

                setState(() {
                  category = value!;
                });

              },
            ),

            const SizedBox(height: 10),

            // Description
            TextField(
              controller: descriptionController,

              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            // Add button
            ElevatedButton(
              onPressed: addExpense,
              child: const Text('Add Expense'),
            ),

            const SizedBox(height: 15),

            // Search
            TextField(
              controller: searchController,

              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),

              onChanged: (value) {

                setState(() {
                  searchText = value.toLowerCase();
                });

              },
            ),

            const SizedBox(height: 10),

            // Category filter
            DropdownButtonFormField<String>(
              value: selectedCategory,

              decoration: const InputDecoration(
                labelText: 'Filter Category',
                border: OutlineInputBorder(),
              ),

              items: const [
                DropdownMenuItem(
                  value: 'All',
                  child: Text('All'),
                ),

                DropdownMenuItem(
                  value: 'Food',
                  child: Text('Food'),
                ),

                DropdownMenuItem(
                  value: 'Travel',
                  child: Text('Travel'),
                ),

                DropdownMenuItem(
                  value: 'Shopping',
                  child: Text('Shopping'),
                ),

                DropdownMenuItem(
                  value: 'Other',
                  child: Text('Other'),
                ),
              ],

              onChanged: (value) {

                setState(() {
                  selectedCategory = value!;
                });

              },
            ),

            const SizedBox(height: 10),

            // Total
            Text(
              'Total Expense: ₹${getTotal().toStringAsFixed(2)}',

              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            // List
            Expanded(
              child: ListView.builder(

                itemCount: filteredExpenses.length,

                itemBuilder: (context, index) {

                  return Card(

                    child: ListTile(

                      title: Text(
                        '₹${filteredExpenses[index].amount} - '
                        '${filteredExpenses[index].category}',
                      ),

                      subtitle: Text(
                        filteredExpenses[index].description,
                      ),

                      trailing: IconButton(
                        icon: const Icon(Icons.delete),

                        onPressed: () {

                          Expense selected =
                              filteredExpenses[index];

                          int realIndex =
                              expenses.indexOf(selected);

                          deleteExpense(realIndex);

                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}