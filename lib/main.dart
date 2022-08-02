import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:flutter_complete_guide/widgets/new_transaction.dart';
import 'package:flutter_complete_guide/widgets/transaction_list.dart';
import 'widgets/chart.dart';
import 'models/Transaction.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<Transaction> transactions = [
    Transaction(
        id: 't1',
        title: 'New Shoes',
        amount: 62.8,
        date: DateTime.now().subtract(Duration(days: 5))),
    Transaction(
        id: 't2',
        title: 'Imac 24',
        amount: 98.67,
        date: DateTime.now().subtract(Duration(days: 2))),
    Transaction(
        id: 't3',
        title: 'Macbook',
        amount: 18.9349,
        date: DateTime.now().subtract(Duration(days: 2))),
    Transaction(
        id: 't4', title: 'Macbook Pro', amount: 120.4599, date: DateTime.now()),
    Transaction(
        id: 't5', title: 'Airpods max', amount: 20.99, date: DateTime.now()),
  ];

  bool _showChart = true;

  List<Transaction> get _recentTransactions {
    return transactions.where((transaction) {
      return transaction.date
          .isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  _addNewTransaction(String title, double amount) {
    Transaction transaction = Transaction(
        id: DateTime.now().toString(),
        title: title,
        amount: amount,
        date: DateTime.now());
    setState(() {
      transactions.add(transaction);
    });
  }

  _deleteTx(String id) {
    print('removing $id');
  }

  void startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return NewTransaction(addTransaction: _addNewTransaction);
        });
  }

  @override
  Widget build(BuildContext context) {
    //final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    final dynamic appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Personal Expenses'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Builder(
                  builder: (ctx) {
                    return GestureDetector(
                      child: Icon(CupertinoIcons.add),
                      onTap: () { startAddNewTransaction(ctx); }
                    );
                  }
                )
              ]
            )
          )
        : AppBar(centerTitle: false, title: Text('Flutter App'), actions: [
            Builder(builder: (ctx) {
              return IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  startAddNewTransaction(ctx);
                },
              );
            })
          ]);

    final pageBody = SingleChildScrollView(
      child: Builder(builder: (cont) {
        return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Show Chart'),
              Switch.adaptive(
                value: _showChart,
                onChanged: (val) {
                  setState(() {
                    _showChart = val;
                  });
                },
              )
            ],
          ),
          if (_showChart)
            Container(
                height: (MediaQuery.of(cont).size.height -
                        appBar.preferredSize.height -
                        MediaQuery.of(cont).padding.top) *
                    0.3,
                child: Chart(recentTransactions: _recentTransactions)),
          Container(
              height: (MediaQuery.of(cont).size.height -
                      appBar.preferredSize.height -
                      MediaQuery.of(cont).padding.top) *
                  0.6,
              child: TransactionList(
                  transactions: transactions, deleteTx: _deleteTx))
        ]);
      }),
    );

    return MaterialApp(
        title: 'Personal Expenses (Android)',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
          fontFamily: 'Quicksand',
        ),
        home: Platform.isIOS
            ? CupertinoPageScaffold(
                child: pageBody,
                navigationBar: appBar,
              )
            : Scaffold(
                appBar: appBar,
                body: pageBody,
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
                floatingActionButton: Builder(builder: (ctx) {
                  return FloatingActionButton(
                      child: Icon(Icons.add),
                      onPressed: () {
                        startAddNewTransaction(ctx);
                      });
                }),
              )
    );
  }
}
