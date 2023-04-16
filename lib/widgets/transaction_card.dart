import 'package:flutter/material.dart';
import 'package:usman_e_ghani/models/user.dart';

class TransactionCard extends StatelessWidget {
  final Color iconColor;
  final String date, description;
  final User owner;
  final User? approver;
  final String amount;
  final IconData transactionIcon;
  final GestureTapCallback onTap;

  const TransactionCard({
    required this.iconColor,
    required this.date,
    required this.owner,
    this.approver,
    required this.amount,
    required this.description,
    required this.transactionIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  child: Icon(
                    transactionIcon,
                    size: 25,
                    color: Colors.white,
                  ),
                  backgroundColor: iconColor,
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(description),
                      Text(
                        'Creator: ${owner.name} ${approver != null ? ', Approver: ${approver!.name}' : ', Status: unapproved'}',
                        style: TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(
                      amount,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      date,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        // title: Text(
        //   description,
        //   style: TextStyle(fontSize: 14),
        // ),
        // subtitle: Text(
        //     'Creator: ${owner.name} ${approver != null ? 'Approver: ${approver!.name}' : ''}'),
        // trailing: Text("${amount}"),
        // leading: CircleAvatar(
        //   radius: 25,
        //   child: Icon(
        //     transactionIcon,
        //     size: 25,
        //   ),
        //   backgroundColor: iconColor,
        // ),
        // enabled: true,
        // onTap: onTap,
      ),
    );
  }
}
