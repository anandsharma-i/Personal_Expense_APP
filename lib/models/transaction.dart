import 'package:flutter/foundation.dart';

//Used for keep a txn as a single unit.
class Transaction
{
  //Final is run time const
  // (After getting input ,values wont change during runtime)
  final String id,title;
  final double amount;
  final DateTime date;
  Transaction
  (
    {
      @required this.amount,
      @required this.title,
      @required this.date,
      @required this.id
    }
  );
}