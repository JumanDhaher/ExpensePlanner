import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './widgets/transacation_list.dart';
import './widgets/new_transaction.dart';
import './models/transaction.dart';
import './widgets/chart.dart';
void main(){
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown
  //   ],);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expense',
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        //errorColor: Colors.red,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
          title: 
          TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 18,
            fontWeight: FontWeight.bold
           ),
           button: TextStyle(color: Colors.white),
        ) ,
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
            title: 
            TextStyle(
              fontFamily:'OpenSans',
              fontSize: 20 ,
              fontWeight: FontWeight.bold)
              ),
          ),
        ),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver{
    final List<Transaction> _userTransactions = [
    // Transaction(
    //     id: 't1', 
    //     titte: 'new shose', 
    //     amount: 69.99, 
    //     date: DateTime.now()),
    // Transaction(
    //     id: 't2',
    //     titte: 'Weekly Groceries',
    //     amount: 16.53,
    //     date: DateTime.now()),
    
  ];

  bool _showChart = false;
  
@override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

 @override 
 void didChangeAppLifecycleState(AppLifecycleState state){
    print(state);
 }
  
  @override
  dispose(){
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  List<Transaction> get _recentTransaction{
    return _userTransactions.where((tx){
      return tx.date.isAfter(
        DateTime.now().subtract(
        Duration(days: 7),
      ),);
    }).toList();
    
  }
 void _addNewTransaction(String txtTitle, double txAmount, DateTime chosenDate){
      final newTx = Transaction(
        titte: txtTitle ,
        amount:txAmount, 
        date: chosenDate,
        id: DateTime.now().toString() );

        setState(() {
          _userTransactions.add(newTx);
        });
  }

  void _deleteTransaction(String id){
    setState(() {
      _userTransactions.removeWhere((tx)=> tx.id == id );
    });
  }
  void _startAddNewTransaction(BuildContext ctx){
    showModalBottomSheet(
      context: ctx, 
      builder: (_){
        return GestureDetector(
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
          onTap: (){},)
         ;
    });
  }

  List<Widget> _buildLandScapeContent(MediaQueryData mediaQuery,AppBar appBar, Widget txListWidgets ){
   return [ Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Show Chart' ,
               style: Theme.of(context).textTheme.title,),
              Switch.adaptive(value: _showChart,
                    activeColor: Theme.of(context).accentColor,
                     onChanged: (val){
                       setState(() {
                         _showChart = val;
                       });},),]),
              
              _showChart ? Container(
              height:
              (mediaQuery.size.height - 
              appBar.preferredSize.height -
              mediaQuery.padding.top) * 0.7,
              child: Chart(_recentTransaction))
             :   txListWidgets ];
  }

  List<Widget> _buildPortaitContent(MediaQueryData mediaQuery, AppBar appBar, Widget txListWidgets,){
    return[ Container(
              height:
              (mediaQuery.size.height - 
              appBar.preferredSize.height -
              mediaQuery.padding.top) * 0.3,
              child: Chart(_recentTransaction)
              ),
              txListWidgets];
  }
  
PreferredSizeWidget _buildAppBar(){
  return Platform.isIOS?
      CupertinoNavigationBar(
        middle: Text('Personal Expense',),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
          GestureDetector(
            child: Icon(CupertinoIcons.add),
            onTap:  () => _startAddNewTransaction(context),)
        ],),
      )
      : AppBar(
        title: Text('Personal Expense',),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context))
        ],
      );
}
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandScape = mediaQuery.orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = _buildAppBar();
    final txListWidgets =Container(
              height: (
                mediaQuery.size.height -
                 appBar.preferredSize.height -
                 mediaQuery.padding.top) * 0.7 ,
              child: TransactionList(_userTransactions, _deleteTransaction));
    
    final pageBody = SafeArea(child: SingleChildScrollView(
              child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if(isLandScape) 
            ...  _buildLandScapeContent(mediaQuery,appBar,txListWidgets),
            if(!isLandScape) 
            ... _buildPortaitContent(mediaQuery,appBar,txListWidgets),
            
          ]
        ),
      ));

  
    return Platform.isIOS? CupertinoPageScaffold(
      child: pageBody,
      navigationBar: appBar,)
    : Scaffold(
      appBar: appBar,
      body: pageBody,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Platform.isIOS ? Container() 
      : FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
        ),
    );
  }
}
