import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './chart_bar.dart';
import '../models/transaction.dart';

class Chart extends StatelessWidget 
{   
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  //Getter for extracting the total amount spent and
  //initial char of the day's name for each last 7 days txn.
  List<Map<String,Object>> get groupedTransactionValues
  {
    return List.generate//Generating the list of maps for last days.
    (
      7,
       (index) //index starts from 0 to 6 and changes after each iteration.
       {
         //storing the current_day-current_index_day.
         final weekDay=DateTime.now().subtract(Duration(days: index),);

         //For cal total sum.
         double totalsum=0.0;

         //Adding the amount of only those days which match the weekday.
         for(var i=0;i<recentTransactions.length;i++)
         {
           if(recentTransactions[i].date.day==weekDay.day&&
           recentTransactions[i].date.month==weekDay.month&&
           recentTransactions[i].date.year==weekDay.year)           
           {
            totalsum+=recentTransactions[i].amount;
           } 
         }
         //print(DateFormat.E().format(weekDay));
         //print(totalsum);
         return//map of weekday's initial char and total amount spent on that day.
         {
           //substring is used to get only the initial char.
           'Day':DateFormat.E().format(weekDay).substring(0,1),
           'Amount':totalsum,
         };
       }//reversing the list so the current day txn appears on the leftmost bar.
    ).reversed.toList();
  }

  //Getter for extracting the total amount spent the whole week(last 7 days)
  double get totalSpending
  {
    //.fold is a special func to reduce a list into a single value
    // by cal and iterating through the list.
    //It takes a initial value and index and keeps updating the 
    //the value throuout the list and returns a single value.
    return groupedTransactionValues.fold
    (
      0.0, (sum, item) {return sum+item['Amount'];}
    );
  }

  @override
  Widget build(BuildContext context) 
  {
    //print(groupedTransactionValues);
    return Card
    (
      elevation: 6,
      margin:EdgeInsets.all(20),
      child: Container
      (
        padding: EdgeInsets.all(10),
        child: Row
        (
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children:groupedTransactionValues.map//mapping the list to the widgets.
          (
            (data) 
            {
              return Flexible//a widget to controll how a child flexes in a row/column. 
              (
                fit: FlexFit.tight,
                child: ChartBar
                (
                  //initial char for this day
                  data['Day'],

                  //amount spent for this day
                  data['Amount'],
                  
                  //total spending of this day as a percent of total spending of the week.,
                  totalSpending==0.0?0.0: (data['Amount'] as double)/totalSpending,
                ),
              );
            }
          ).toList(),                           
        ),
      ),
    );
  }
}