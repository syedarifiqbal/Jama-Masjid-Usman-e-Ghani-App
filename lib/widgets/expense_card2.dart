import 'package:flutter/material.dart';
import 'package:usman_e_ghani/models/user.dart';

class ExpenseCard2 extends StatelessWidget {
  final String date;
  final String description;
  final String amount;
  final String? approved_at;
  final String? approved_by;
  final User owner;
  final VoidCallback? onApprovalButtonPressed;

  ExpenseCard2({
    required this.date,
    required this.description,
    required this.amount,
    this.approved_at,
    this.approved_by,
    this.onApprovalButtonPressed,
    required this.owner,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              date,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              "Amount: ${amount}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              "Creator: ${owner.name}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  approved_at != null ? "Approved" : "Not Approved",
                  style: TextStyle(
                    fontSize: 16,
                    color: approved_at != null ? Colors.green : Colors.red,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle approve button click
                  },
                  child: const Text("Approve"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
