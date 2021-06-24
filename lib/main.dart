//import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';

import './widgets/transaction_list.dart';
import './widgets/new_transaction.dart';
import './models/transaction.dart';
import './widgets/chart.dart';

class MyApp extends StatelessWidget
 {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) 
  {
    return MaterialApp
    (
      title: 'Personal Expenses',      
      
      //The home page of the app.Stays in another stateful class.
      home: MyHomePage(),
      
      //The main theme of the app is set here.
      theme: ThemeData
      (
        //Primary color.
        primarySwatch: Colors.lightGreen,
        
        //Secondary color.When primary is not available.
        accentColor: Colors.amber,

        //Error Color.Can be used for warnings.
        errorColor: Colors.deepOrangeAccent,

        //Main font of app.
        fontFamily: 'Quicksand',

        //Copying the existing text theme with modified themes using .copyWith
        textTheme: ThemeData.light().textTheme.copyWith
        (
          //For title texts.
            title: TextStyle
            (
              fontFamily: 'OpenSans',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            //For button texts.
            button: TextStyle
            (
             color: Colors.white,
             fontWeight: FontWeight.bold, 
            ),
        ),
        ////Main theme of appbar.
        appBarTheme: AppBarTheme
        (
          //Copying the existing text theme with modified themes using .copyWith
          textTheme: ThemeData.light().textTheme.copyWith
          (
            title: TextStyle
            (
              fontFamily: 'OpenSans',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          )
        ),
      ),
      //For hiding the debug banner.
      debugShowCheckedModeBanner: false,
    );
  }
}

//Home page screen.(Stateful)
class MyHomePage extends StatefulWidget
{  
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> 
{

  //The txns list.
  final List<Transaction> _userTransactions=
  [
    /*Transaction
    (
      id: 't1',title: 'New Shoes',amount: 69.99,date: DateTime.now()
    ),
    Transaction
    (
      id: 't2',title: 'Weekly Groceries',amount: 16.99,date: DateTime.now()
    ),*/
  ];

  bool _showChart=false;

  //Getter for extracting txns for last 7 days from current day.
  List<Transaction> get _recentTransactions
  {
    //.where Creates an iterable of the elements (of the list on which it's called)
    // that satisfies the where condition.
    return _userTransactions.where    
    (
      (tx)
      {
        //returns true if current txn element's date is > Last 7th day value.
        return tx.date.isAfter
        (
          //Last 7th day value.
          DateTime.now().subtract(Duration(days: 7),),
        );
      }
    ).toList();//Converting the iterable into list.
  }

  //For adding new txn into the userTransaction list.
  void _addNewTransaction(String txTitle,double txAmount,DateTime choosenDate)
  {
    final newTx=Transaction
    (
      title: txTitle,
      amount: txAmount,
      date: choosenDate,
      id: DateTime.now().toString(),//Maintain id usint current time stamp as string.
    );

    setState//calling build on every new addition to list.
    (      
      () 
      {
        _userTransactions.add(newTx);
      }
    );
  }

  void _deleteTransaction(String id)
  {
    setState//calling build on every new deletion from list.
    (
      () 
      {
        //.removeWhere deletes the elements (of the list on which it's called)
        // that satisfies the where condition.
        _userTransactions.removeWhere((tx) => tx.id==id);
      }
    );
  }

  //To trigger modal sheet from bottom and initiate the new txn process.
  void _startAddNewTransaction(BuildContext ctx)
  {
    //To trigger modal sheet from bottom.
    showModalBottomSheet
    (
      context: ctx, 
      builder: (_)
      {
        return GestureDetector
        (
          //To make sure the new txn contents are displayed on the modal sheet.
          child: NewTransaction(_addNewTransaction),
          onTap: (){},//Do nothing on tapping the sheet.
          behavior: HitTestBehavior.opaque,          
        );
      }
    );      
  }

  List<Widget> _buildLandscape(MediaQueryData mediaQuery,AppBar appBar,Widget txList)
  {
  return 
  [  
    Row//Switch Key with labels
    (
      mainAxisAlignment: MainAxisAlignment.center,
      children: 
      [
        Text
        (
          'Show Chart',
          style: Theme.of(context).textTheme.title,
        ),
              
        //Adding a switch key
        //.adaptive is used to let flutter adapt to different OS
        //with same code structure.
        Switch.adaptive
        (
          value: _showChart, 
          onChanged: (value)
          {
            setState(() {
              _showChart=value;
            });
          }
        )
      ],
    ),
    _showChart?
    Container
    (
      height: 
      (
        mediaQuery.size.height - 
        appBar.preferredSize.height - mediaQuery.padding.top
      )*0.6,
      child: Chart(_recentTransactions)
    )            
    :txList,
  ];
  }

  List<Widget> _buildPortrait(MediaQueryData mediaQuery,AppBar appBar,Widget txList)
  {
  return
  [ 
    Container
    (
      height: 
      (
        mediaQuery.size.height - 
        appBar.preferredSize.height - mediaQuery.padding.top
      )*0.3,
      child: Chart(_recentTransactions)
    ),txList
  ];
}

  PreferredSizeWidget _buildAppBar()
  {
    return AppBar
      (        
        title: Text('Personal Expenses'),
        actions: 
        [
          IconButton
          (
            onPressed:() => _startAddNewTransaction(context), 
            icon: Icon(Icons.add),
          )
        ],
      );
  }

  @override
  Widget build(BuildContext context) 
  {   
    final mediaQuery=MediaQuery.of(context);

    //Variable To store device orientation.
    final isLandScape=mediaQuery.orientation==Orientation.landscape;

    //variable to store appbar. 
    final appBar=_buildAppBar();

      //variable to hold the container for transaction list.
    final txList=Container
      (
        height: 
        (
          mediaQuery.size.height - 
          appBar.preferredSize.height - mediaQuery.padding.top
        )*0.7,
        child: TransactionList(_userTransactions,_deleteTransaction)
      );
     
    return Scaffold
    (
      appBar: appBar,
      //Making the whole column as a single child scrollable.
      body: SingleChildScrollView
      (
        child: Column
        (
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: 
          [            
            //Display only in lanscape mode.
            if(isLandScape)//Special if inside list syntax don't require ({}).
            ..._buildLandscape(mediaQuery,appBar,txList),
            
            //Display only in portrait mode.
            if(!isLandScape)
            ..._buildPortrait(mediaQuery,appBar,txList),                                    
          ],
        ), 
      ),
      
      //Adding the floating action button's location.
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      
      //Adding the floating action button.(Only for android)
      //To use Platform which is a built in feature of dart use
      //package dart:io
      floatingActionButton: Platform.isIOS?
      Container()      
      :FloatingActionButton
      (
        child: Icon(Icons.add),
         onPressed:() => _startAddNewTransaction(context), 
      ),
    );
  }
}

void main() 
{
  runApp(MyApp());
}