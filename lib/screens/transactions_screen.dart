import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_state.dart';
import '../models/transaction.dart';
import 'add_transaction_screen.dart';
import 'analytics_screen.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  String _filterType = 'all'; // all, income, expense
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(symbol: '\$');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            tooltip: 'View Analytics',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AnalyticsScreen(),
                ),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search transactions...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                ),
              ),
              // Filter Chips
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    FilterChip(
                      label: const Text('All'),
                      selected: _filterType == 'all',
                      onSelected: (selected) {
                        setState(() {
                          _filterType = 'all';
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Income'),
                      selected: _filterType == 'income',
                      onSelected: (selected) {
                        setState(() {
                          _filterType = 'income';
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Expense'),
                      selected: _filterType == 'expense',
                      onSelected: (selected) {
                        setState(() {
                          _filterType = 'expense';
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Consumer<AppState>(
        builder: (context, appState, _) {
          var transactions = appState.transactions;

          // Apply filters
          if (_filterType != 'all') {
            transactions = transactions.where((t) {
              return t.type.toString().split('.').last == _filterType;
            }).toList();
          }

          // Apply search
          if (_searchQuery.isNotEmpty) {
            transactions = transactions.where((t) {
              return t.title.toLowerCase().contains(_searchQuery) ||
                  t.category.toLowerCase().contains(_searchQuery) ||
                  (t.notes?.toLowerCase().contains(_searchQuery) ?? false);
            }).toList();
          }

          if (transactions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long,
                    size: 64,
                    color: theme.colorScheme.primary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _searchQuery.isNotEmpty
                        ? 'No transactions found'
                        : 'No transactions yet',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _searchQuery.isNotEmpty
                        ? 'Try a different search term'
                        : 'Add your first transaction to get started',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              final category = appState.getCategoryById(transaction.category);

              return Dismissible(
                key: Key(transaction.id),
                direction: DismissDirection.endToStart,
                confirmDismiss: (direction) async {
                  return await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Transaction'),
                      content: const Text(
                        'Are you sure you want to delete this transaction?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );
                },
                onDismissed: (direction) {
                  appState.deleteTransaction(transaction);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Transaction deleted'),
                    ),
                  );
                },
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  color: Colors.red,
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                child: Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: category?.color.withOpacity(0.2),
                      child: Icon(
                        category?.icon ?? Icons.help_outline,
                        color: category?.color,
                      ),
                    ),
                    title: Text(transaction.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(category?.name ?? transaction.category),
                        Text(
                          DateFormat('MMM dd, yyyy').format(transaction.date),
                          style: theme.textTheme.bodySmall,
                        ),
                        if (transaction.notes != null &&
                            transaction.notes!.isNotEmpty)
                          Text(
                            transaction.notes!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                    trailing: Text(
                      '${transaction.type == TransactionType.income ? '+' : '-'}${currencyFormat.format(transaction.amount)}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: transaction.type == TransactionType.income
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddTransactionScreen(
                            transaction: transaction,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
