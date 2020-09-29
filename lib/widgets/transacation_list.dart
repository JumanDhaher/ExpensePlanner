import 'package:flutter/material.dart';
import '../models/transaction.dart';
import './transaction_items.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> userTransactions;
  final Function deleteTx;

  TransactionList(this.userTransactions,this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return userTransactions.isEmpty ? 
        LayoutBuilder(builder: (ctx, constraints){
            return
            Column(children: <Widget>[
                Text(
                  'No Transaction added yet!',
                  style: Theme.of(context).textTheme.title,
                  ),
                SizedBox(
                  height: 20,
                  ),
                Container(
                  height: constraints.maxHeight *0.6,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,),
                ),
              ],);
        },)
              :  ListView(
                children: userTransactions.map((tx) => TransactionItem(
                    key: ValueKey(tx.id),
                    transactions: tx,
                     deleteTx: deleteTx)).toList()
              );
  }
}

/*children: userTransactions.map((tx) { 
                }).toList(),

return Card(
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                          decoration: BoxDecoration(
                              border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 2,
                          )),
                          padding: EdgeInsets.all(10),
                          child: Text(
                            '\$${userTransactions[index].amount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              userTransactions[index].titte,
                              style: Theme.of(context).textTheme.title,
                            ),
                            Text(
                              DateFormat.yMMMd().format(userTransactions[index].date),
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ); */                
