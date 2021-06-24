import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionItem extends StatelessWidget 
{
  const TransactionItem
  ({
    Key key,
    @required this.userTransaction,
    @required this.deleteTransaction,
  }) : super(key: key);

  final Transaction userTransaction;
  final Function deleteTransaction;

  @override
  Widget build(BuildContext context)
  {
    return Card
    (
      margin: EdgeInsets.symmetric
      (
        horizontal:8,
        vertical: 6,
      ),

      elevation: 5,

      child: ListTile//For creating a list of tiles in a form of row.
      (
        //The leftmost tile.(Shape icon usually)
        leading: CircleAvatar
        (
          radius: 30,
          child: Container
          (
            padding: EdgeInsets.all(6),
            child: FittedBox//To make the inside contents of child widget fiited in a single line inside the parent widget.
            (
              child: Text
              (
                '\$ ${userTransaction.amount.toStringAsFixed(2)}',                              
              ),
            ),
          ),
        ),
        //The 2nd tile.(Title usually)
        title: Text
        (
          userTransaction.title,
          style: Theme.of(context).textTheme.title,
        ),
        //The 3rd tile.(Below Title usually)
        subtitle: Text
        (                                    
          DateFormat.yMMMMEEEEd().format(userTransaction.date),
          style: TextStyle
          (
            color: Colors.grey,                                  
          ),
        ),
        //The rightmost tile.(Shape icon usually)
        trailing: MediaQuery.of(context).size.width>460?
        FlatButton.icon
        (
          icon: Icon(Icons.delete),
          label: Text('Delete'),
          textColor: Theme.of(context).errorColor,
          onPressed: () => deleteTransaction(userTransaction.id), 
        )
        :IconButton
        (
          onPressed: () => deleteTransaction(userTransaction.id), 
          icon: Icon(Icons.delete),
          color: Theme.of(context).errorColor,
        ),
      ),
    );
  }
}