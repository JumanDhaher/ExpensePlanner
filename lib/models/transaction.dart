import 'package:flutter/foundation.dart';

class Transaction {
  final String id;
  final String titte;
  final double amount;
  final DateTime date;

  Transaction({@required this.id, @required this.titte,@required this.amount,@required this.date});
}
