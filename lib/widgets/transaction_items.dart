import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
class TransactionItem extends StatefulWidget {

  const TransactionItem({
    Key key,
    @required this.transactions,
    @required this.deleteTx,
  }) : super(key: key);

  final Transaction transactions;
  final Function deleteTx;

  @override
  _TransactionItemState createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  Color _bgColor;
  @override
  void initState() {
    const availabileColor = [Colors.red,Colors.black,Colors.blue,Colors.purple];
    _bgColor = availabileColor[Random().nextInt(4)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      elevation: 5,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _bgColor,
        radius: 30,
        child: Padding(
          padding: EdgeInsets.all(6),
          child: FittedBox(
            child: Text('\$${widget.transactions.amount}')
            ), ) ,),
                title: Text(widget.transactions.titte,
                style: Theme.of(context).textTheme.title,),
                subtitle: Text(DateFormat.yMMMd().format(widget.transactions.date)),
                trailing: MediaQuery.of(context).size.width > 460 ? 
                FlatButton.icon(
                 textColor: Theme.of(context).errorColor,
                 onPressed:() => widget.deleteTx(widget.transactions.id),
                 icon: const Icon(Icons.delete),
                 label: const Text('Delete'))
                :
                IconButton(
    icon: const Icon(
      Icons.delete),
      color: Theme.of(context).errorColor, 
    onPressed: () => widget.deleteTx(widget.transactions.id)
    ),
                ),
    );
  }
}