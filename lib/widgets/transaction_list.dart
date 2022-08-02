import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/Transaction.dart';

class TransactionList extends StatelessWidget {

  List<Transaction> transactions;
  Function deleteTx;

  TransactionList({Key? key, required this.transactions, required this.deleteTx}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty ? Column(
      children: [
        Text('No transactions added yet!', style: TextStyle(
          fontSize: 25
        )),
        SizedBox(
          height: 50
        ),
        Container(
            height: 200,
            child: Image.asset('assets/images/waiting.png', fit: BoxFit.cover)
        )
      ]
    ) : ListView.builder(
        itemBuilder: (ctx, index) {
          return Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 10
            ),
            child: ListTile(
              leading: CircleAvatar(
                radius: 30,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: FittedBox(
                      child: Text('\$${transactions[index].amount}')
                  ),
                )
              ),
              title: Text(transactions[index].title, style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
              )),
              subtitle: Text(DateFormat.yMMMd().format(transactions[index].date)),
              trailing: MediaQuery.of(ctx).size.width > 560
                ? FlatButton.icon(
                  icon: Icon(Icons.delete),
                  label: Text('delete'),
                  color: Colors.red,
                  onPressed: () => deleteTx(transactions[index].id)
              ) : IconButton(
                icon: Icon(Icons.delete),
                color: Colors.red,
                onPressed: () => deleteTx(transactions[index].id),
              ),
          )
          );
        },
        itemCount: transactions.length,
      );
  }
}


