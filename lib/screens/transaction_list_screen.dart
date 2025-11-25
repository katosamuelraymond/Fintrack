import 'package:flutter/material.dart';
import '../data/dummy_data.dart';

class TransactionListScreen extends StatelessWidget {
  const TransactionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'All Transactions',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF2196F3),
        elevation: 0,
      ),
      body: ListView(
        children: dummyTransactions.map((transaction) {
          return _buildTransactionItem(
            transaction.title,
            transaction.amount,
            transaction.date,
            transaction.category,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTransactionItem(
    String title,
    double amount,
    DateTime date,
    String category,
  ) {
    Color color = category == 'income' ? Colors.green : Colors.red;
    String formattedAmount = 'UGX ${amount.toStringAsFixed(0)}';
    String formattedDate = '${date.day}/${date.month}/${date.year}';

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            category == 'income' ? Icons.arrow_upward : Icons.arrow_downward,
            color: color,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          formattedDate,
          style: const TextStyle(color: Colors.black54),
        ),
        trailing: Text(
          formattedAmount,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
