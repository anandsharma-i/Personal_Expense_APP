//import 'dart:html';
import 'package:flutter/material.dart';

import '../models/transaction.dart';
import './transaction_item.dart';

class TransactionList extends StatelessWidget 
{  
  final List<Transaction> userTransactions;
  final Function deleteTransaction;
  
  TransactionList(this.userTransactions,this.deleteTransaction);

  @override
  Widget build(BuildContext context)
  {
    return userTransactions.isEmpty?            
            LayoutBuilder
            (
              builder: 
              (ctx,constraints)
              {
               return Column
                (
                  children: 
                  [
                    Text
                    (
                      'No transactions added yet.',
                      style: Theme.of(context).textTheme.title,
                    ),
                    const SizedBox
                    (
                      height: 20,
                    ),
                    Container
                    (
                      height: constraints.maxHeight*0.7,
                      //To add image
                      child: Image.asset
                      (
                        'assets/images/waiting.png',
                        fit: BoxFit.cover,//To make sure img is completely inside parent widget.
                      ),
                    ),
                  ],
                );            
              }
            )            
             : ListView.builder//Inbuilt scrolabble column and build is called only for the children visible onscreen.
              (           
                itemBuilder: (ctx,index)
                {
                  /*return Card                  
                        (
                          child: Row
                          (
                            children: 
                            [
                              Container
                              (
                                margin: EdgeInsets.symmetric
                                (
                                  horizontal: 10,
                                  vertical: 15,
                                ),
                                
                                padding: EdgeInsets.all(10),                                                     
      
                                decoration: BoxDecoration
                                (
                                  border: Border.all
                                  (
                                    width: 1.5,
                                    color: Theme.of(context).primaryColor,                
                                  ), 
                                ),
      
                                child: Text
                                (
                                  //tx.amount.toString(),
                                  //Using string interpolation concept.
                                  '\$ ${userTransactions[index].amount.toStringAsFixed(2)}',
                                  style: TextStyle
                                  (
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold ,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
      
                              ),
                              Column
                              (
                                crossAxisAlignment: CrossAxisAlignment.start,
      
                                children: 
                                [
                                  Text
                                  (
                                    userTransactions[index].title,
                                    style: Theme.of(context).textTheme.title,
                                  ),
                                  Text
                                  (
                                    //tx.date.toString(),
                                    //intl package funtionalities
                                    DateFormat.yMMMMEEEEd().format(userTransactions[index].date),
                                    style: TextStyle
                                    (
                                      color: Colors.grey,                                  
                                    ),
                                  ),
                                ],                            
                              )
                            ],
                          ),
                        );*/
                  return TransactionItem(userTransaction: userTransactions[index], deleteTransaction: deleteTransaction);
                },
                //Max no. of child widgets to scroll.
                itemCount: userTransactions.length,                               
              );    
  }
}

