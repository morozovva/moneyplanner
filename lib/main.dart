import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './widgets/chart.dart';
import './widgets/new_transaction.dart';
import './models/transaction.dart';
import './widgets/transaction_list.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(const MoneyPlannerApp());
}

class MoneyPlannerApp extends StatelessWidget {
  const MoneyPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Planner',
      theme: ThemeData(
        primarySwatch: Colors.lime,
        // fontFamily: 'Quicksand',
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [];

  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _userTransactions
        .where((el) => el.date.isAfter(
              DateTime.now().subtract(
                const Duration(days: 7),
              ),
            ))
        .toList();
  }

  void _addUserTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTX = Transaction(
        title: txTitle,
        amount: txAmount,
        date: chosenDate,
        id: DateTime.now().toString());

    setState(() {
      _userTransactions.add(newTX);
    });
  }

  void _startAddTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            child: NewTransaction(_addUserTransaction),
            onTap: () {},
          );
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((element) => element.id == id);
    });
  }

  List<Widget> _buildLandscapeContent(
      MediaQueryData mediaQuery, Widget txList) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Show chart",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Switch.adaptive(
              activeColor: Colors.green,
              value: _showChart,
              onChanged: (val) {
                setState(() {
                  _showChart = val;
                });
              }),
        ],
      ),
      _showChart
          ? SizedBox(
              height: (mediaQuery.size.height - mediaQuery.padding.top) * 0.7,
              child: Chart(_recentTransactions),
            )
          : txList,
    ];
  }

  List<Widget> _buildPortraitContent(MediaQueryData mediaQuery, Widget txList) {
    return [
      SizedBox(
        height: (mediaQuery.size.height - mediaQuery.padding.top) * 0.3,
        child: Chart(_recentTransactions),
      ),
      txList
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            backgroundColor: Theme.of(context).primaryColor,
            middle: const Text(
              'Money Planner App',
              // style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => _startAddTransaction(context),
                  child: const Icon(CupertinoIcons.add),
                ),
              ],
            ),
          )
        : AppBar(
            title: const Text(
              'Money Planner App',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: <Widget>[
              IconButton(
                onPressed: () => _startAddTransaction(context),
                icon: const Icon(Icons.add),
              ),
            ],
          );
    final txList = SizedBox(
      height: (mediaQuery.size.height - mediaQuery.padding.top) * 0.6,
      child: Expanded(
        child: TransactionList(
          transactions: _userTransactions,
          deleteTx: _deleteTransaction,
        ),
      ),
    );
    final appBody = SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          if (isLandscape) ..._buildLandscapeContent(mediaQuery, txList),
          if (!isLandscape) ..._buildPortraitContent(mediaQuery, txList),
        ],
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: appBar as ObstructingPreferredSizeWidget,
            child: appBody,
          )
        : Scaffold(
            appBar: appBar as PreferredSizeWidget,
            body: appBody,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    onPressed: () => _startAddTransaction(context),
                    child: const Icon(Icons.add),
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
          );
  }
}
