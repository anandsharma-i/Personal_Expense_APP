import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget 
{
  final String label;
  final double spendingAmount;
  final double spendingPrcOfTotal;

  ChartBar(this.label,this.spendingAmount,this.spendingPrcOfTotal);

  @override
  Widget build(BuildContext context) 
  {
    return LayoutBuilder
    (
      builder: (ctx,constraints)
      {
        return Column
        (
          children: 
          [
            Container
            (
              height: constraints.maxHeight*0.15,
              child: FittedBox
              (
                child: Text('\$${spendingAmount.toStringAsFixed(0)}'),
              ),
            ),
            
            //Used for spacing purpose.
            SizedBox
            (
              height: constraints.maxHeight*0.05,
            ),

            Container
            (
              height: constraints.maxHeight*0.6,
              width: 10,
              child: Stack//for creating layers of widgets on top of eachother.
              (
                children: 
                [
                  //bottom most layer.(Grey)
                  Container
                  (
                  decoration: BoxDecoration
                  (                 
                    border: Border.all(width: 1.0,color: Colors.grey),
                    color: Color.fromRGBO(220, 220, 220, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),                
                  ),

                  //top layer.(Green)
                  FractionallySizedBox
                  (
                    //creates a sized box widget based on the 
                    //fraction of the parent widget height.
                    //heightFactor is the fraction value provided.
                    heightFactor:spendingPrcOfTotal,
                    child: Container
                    (
                      decoration: BoxDecoration
                      (
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ), 
            SizedBox
            (
              height: constraints.maxHeight*0.05,
            ),
            Container
            (
              height: constraints.maxHeight*0.15,
              child: FittedBox(child: Text(label))
            ),
          ],
        );
      },
    );
  }
}