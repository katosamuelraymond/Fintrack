import '../models/transaction.dart';

List<Transaction> dummyTransactions = [
  Transaction(
    id: '1',
    title: 'Salary',
    amount: 600000,
    date: DateTime(2024, 1, 15),
    category: 'income',
  ),
  Transaction(
    id: '2',
    title: 'Food',
    amount: 50000,
    date: DateTime(2024, 1, 14),
    category: 'expense',
  ),
  Transaction(
    id: '3',
    title: 'Transport',
    amount: 30000,
    date: DateTime(2024, 1, 14),
    category: 'expense',
  ),
  Transaction(
    id: '4',
    title: 'Freelance Work',
    amount: 200000,
    date: DateTime(2024, 1, 10),
    category: 'income',
  ),
  Transaction(
    id: '5',
    title: 'Shopping',
    amount: 80000,
    date: DateTime(2024, 1, 8),
    category: 'expense',
  ),
];
