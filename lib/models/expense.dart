import 'package:usman_e_ghani/models/user.dart';

import '../helpers/common.dart';

class Expense {
  final int? id;
  final String transaction_date;
  final String? approved_at;
  final int? approved_by;
  final String description;
  final String amount;
  final User owner;
  final User? approver;

  Expense({
    this.id,
    required this.transaction_date,
    this.approved_at,
    this.approved_by,
    required this.description,
    required this.amount,
    required this.owner,
    this.approver,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    print(json);
    return Expense(
      id: json['id'],
      transaction_date: formatDate(dateString: json['transaction_date']),
      approved_at: json['approved_at'],
      approved_by: json['approved_by'],
      description: json['description'],
      amount: json['amount'],
      owner: User.fromJson(json['owner']),
      approver:
          json['approver'] != null ? User.fromJson(json['approver']) : null,
    );
  }
}
