import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/*Even though we are not calling setState()
we are making this class stateful. This is beacuase
a stateful widget is treated a little more different
than a stateless. And to make sure every thing we are changing
internally is reflected on screen smoothly.
 */
class NewTransaction extends StatefulWidget 
{
  //String titleinput,amountinput;
  final Function newTx;

  NewTransaction(this.newTx);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> 
{
  //These are controller variables simply to take care of I/P data
  //taken in through TextField widgets.
  final _titleContorller=TextEditingController();

  final _amountContorller=TextEditingController();

  DateTime _selectedDate;

  //This func is used to sumbit the new txn and exit modal sheet.
  void _submitData()
  {
    //If title is empty don't submit.
    if(_amountContorller.text.isEmpty)
      return ;

    final inputtitle=_titleContorller.text;
    final inputamount=double.parse(_amountContorller.text);

    //If title is empty don't submit.
    //If amount is negative don't submit.
    //If date is not selected don't submit.
    if(inputtitle.isEmpty||inputamount<=0||_selectedDate==null)
      return;

    //.widget is a special property provided by flutter
    //to use widget class features in a state class.(newTx in this)  
    widget.newTx
    (
      inputtitle,
      inputamount,
      _selectedDate,
    );

  //To Close the most recently visited
  //pages visually on top of the older pages(Modal Sheet) 
  //automatically when sumbit is done.
    Navigator.of(context).pop();
  }
  
  //For selecting date using inbuilt method(showDatePicker) of flutter.
  void _presentDatePicker()
  {
    /*Returns a Future Class object.
      which is the date selected by the
      user in future.If not then null is returned.
      This does not means that program haults 
      until user selects date,and execution goes on.      
    */
    showDatePicker
    (
      context: context, 
      initialDate: DateTime.now(), 
      firstDate: DateTime(2021), 
      lastDate: DateTime.now(), 
    ).then//This method is supposed to do further operations after Future obj is returned.
    (
      (pickedDate) 
      {
        //if selected date is null do nothing.
        if(pickedDate==null)
        {
            return;
        }
        //else update the screen
        setState
        (
          () 
          {
            _selectedDate=pickedDate;
          }
        );        
      }
    );
  }

  @override
  Widget build(BuildContext context) 
  {
    return SingleChildScrollView
    (
      child: Card
            (
              elevation: 5,
              child: Container
              (              
                margin: EdgeInsets.all(7),
                padding: EdgeInsets.only
                (
                  top: 10,
                  left: 10,
                  right: 10,
                  bottom: MediaQuery.of(context).viewInsets.bottom+10,
                ),
                decoration: BoxDecoration
                (
                  border: Border.all
                  (
                    width: 1.5,
                    color: Colors.black,
                  ),
    
                ),
    
                child: Column
                (
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: 
                  [                  
                    TextField
                    (                    
                      /*autocorrect: true,
                      autofocus: true,*/
                      decoration: InputDecoration
                      (
                        labelText: 'Title',                      
                      ),
                     // onChanged: (val) {titleinput=val;},
                     controller: _titleContorller,
                    ),
                    TextField
                    (
                      decoration: InputDecoration
                      (
                        labelText: 'Amount',
                      ),
                      controller: _amountContorller,
                      //onChanged: (val) => amountinput=val,
                      
                      //For making keyboard all numbers only.
                      keyboardType: TextInputType.number,
    
                      //Since onsubmitted requires a func that takes a string
                      //Hence putting an '_' means we will accept the necessary
                      //arguements required for a func but we'll not use it.
                      onSubmitted: (_)=>_submitData(),
                    ),
                    Container
                    (
                      height: 70,
                      child: Row
                      (
                        children: 
                        [
                          Expanded
                          (
                            child: Text
                            (
                              _selectedDate==null?
                              'No date chosen.':
                              'Picked Date : ${DateFormat.yMd().format(_selectedDate)}' ,
                            ),
                          ),
                          FlatButton
                          (
                            textColor: Theme.of(context).primaryColor,
                            child: Text('Choose Date',style: TextStyle(fontWeight: FontWeight.bold),),
                            onPressed: _presentDatePicker,                        
                          ),
                        ],
                      ),
                    ),
                    RaisedButton
                    (
                      child: Text('Add Transaction'),
                      onPressed:_submitData,
                      textColor: Theme.of(context).textTheme.button.color,
                      color: Theme.of(context).primaryColor,
                    )
                  ],
                ),
              ),
            ),
    );
  }
}