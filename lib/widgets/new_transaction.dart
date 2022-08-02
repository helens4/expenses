import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/Transaction.dart';

class NewTransaction extends StatefulWidget {

  Function addTransaction;

  NewTransaction({Key? key, required this.addTransaction}) : super(key: key);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();

  final amountController = TextEditingController();

  void submitData() {
    final enteredTitle = titleController.text;
    final enteredAmount = double.parse(amountController.text);

    if(enteredAmount <= 0 || enteredTitle.isEmpty){
      return;
    }

    widget.addTransaction(
        enteredTitle,
        enteredAmount
    );

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker()
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextField(
                    decoration: InputDecoration(
                        labelText: 'Title'
                    ),
                    controller: titleController,
                    onSubmitted: (_) => submitData
                ),
                TextField(
                    decoration: InputDecoration(
                        labelText: 'Amount'
                    ),
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    onSubmitted: (_) => submitData
                ),
                Container(
                  height: 50,
                  child: Row(
                    children: [
                      Text('No Date Chosen'),
                      FlatButton(
                        textColor: Colors.purple,
                        child: Text('Choose date', style: TextStyle(
                          fontWeight: FontWeight.bold
                        )),
                        onPressed: () {}
                      )
                    ]
                  ),
                ),
                RaisedButton(
                    onPressed: submitData,
                    color: Colors.purple,
                    textColor: Colors.white,
                    child: Text('Add Transaction')
                )
              ]
          ),
        )
    );
  }
}
