import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction.dart';
import '../models/account.dart';
import '../models/category.dart' as models;
import '../models/budget.dart';
import '../services/database_helper.dart';

class AppState extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper.instance;
  
  // Authentication
  bool _isAuthenticated = false;
  String? _currentUserId;
  
  // Data
  List<Account> _accounts = [];
  List<Transaction> _transactions = [];
  List<models.Category> _categories = [];
  List<Budget> _budgets = [];
  
  // UI State
  bool _isLoading = false;
  String? _error;
  Account? _selectedAccount;
  
  // Getters
  bool get isAuthenticated => _isAuthenticated;
  String? get currentUserId => _currentUserId;
  List<Account> get accounts => _accounts;
  List<Transaction> get transactions => _transactions;
  List<models.Category> get categories => _categories;
  List<Budget> get budgets => _budgets;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Account? get selectedAccount => _selectedAccount;
  
  double get totalBalance {
    return _accounts.fold(0.0, (sum, account) => sum + account.balance);
  }
  
  List<Transaction> get recentTransactions {
    final sorted = List<Transaction>.from(_transactions);
    sorted.sort((a, b) => b.date.compareTo(a.date));
    return sorted.take(10).toList();
  }

  // Initialize app
  Future<void> initialize() async {
    _setLoading(true);
    try {
      // Add timeout to prevent hanging on slow emulators
      await _checkAuthentication().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          // If timeout, just mark as not authenticated
          _isAuthenticated = false;
          notifyListeners();
        },
      );
      if (_isAuthenticated) {
        await _loadData().timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            // If data loading times out, continue anyway
          },
        );
      }
    } catch (e) {
      _setError('Failed to initialize: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _checkAuthentication() async {
    final prefs = await SharedPreferences.getInstance();
    _isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
    _currentUserId = prefs.getString('userId');
    notifyListeners();
  }

  Future<void> _loadData() async {
    await Future.wait([
      _loadAccounts(),
      _loadCategories(),
      _loadTransactions(),
      _loadBudgets(),
    ]);
  }

  // Authentication
  Future<bool> login(String username, String password) async {
    _setLoading(true);
    try {
      // Simple local authentication - in production, use proper auth
      final prefs = await SharedPreferences.getInstance();
      final storedUsername = prefs.getString('username');
      final storedPassword = prefs.getString('password');
      
      if (storedUsername == null) {
        _setError('No account found. Please register first.');
        return false;
      }
      
      if (storedUsername == username && storedPassword == password) {
        _isAuthenticated = true;
        _currentUserId = username;
        await prefs.setBool('isAuthenticated', true);
        await prefs.setString('userId', username);
        await _loadData();
        notifyListeners();
        return true;
      } else {
        _setError('Invalid username or password');
        return false;
      }
    } catch (e) {
      _setError('Login failed: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> register(String username, String password) async {
    _setLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Check if user already exists
      final existingUser = prefs.getString('username');
      if (existingUser != null) {
        _setError('An account already exists. Please login.');
        return false;
      }
      
      // Validate inputs
      if (username.isEmpty || password.length < 4) {
        _setError('Username required and password must be at least 4 characters');
        return false;
      }
      
      // Save credentials
      await prefs.setString('username', username);
      await prefs.setString('password', password);
      await prefs.setBool('isAuthenticated', true);
      await prefs.setString('userId', username);
      
      _isAuthenticated = true;
      _currentUserId = username;
      
      // Create default account and categories
      await _createDefaultData();
      await _loadData();
      
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Registration failed: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthenticated', false);
    _isAuthenticated = false;
    _currentUserId = null;
    _accounts = [];
    _transactions = [];
    _categories = [];
    _budgets = [];
    _selectedAccount = null;
    notifyListeners();
  }

  Future<void> _createDefaultData() async {
    // Create default account
    final defaultAccount = Account(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'Main Account',
      balance: 0.0,
      type: AccountType.checking,
      createdAt: DateTime.now(),
    );
    await _db.createAccount(defaultAccount);
    
    // Create default categories
    for (var category in models.DefaultCategories.allCategories) {
      await _db.createCategory(category);
    }
  }

  // Account operations
  Future<void> _loadAccounts() async {
    _accounts = await _db.getAllAccounts();
    if (_accounts.isNotEmpty && _selectedAccount == null) {
      _selectedAccount = _accounts.first;
    }
    notifyListeners();
  }

  Future<void> addAccount(Account account) async {
    try {
      await _db.createAccount(account);
      await _loadAccounts();
    } catch (e) {
      _setError('Failed to add account: $e');
    }
  }

  Future<void> updateAccountBalance(String accountId, double newBalance) async {
    try {
      final account = _accounts.firstWhere((a) => a.id == accountId);
      final updated = account.copyWith(balance: newBalance);
      await _db.updateAccount(updated);
      await _loadAccounts();
    } catch (e) {
      _setError('Failed to update account: $e');
    }
  }

  Future<void> deleteAccount(String accountId) async {
    try {
      await _db.deleteAccount(accountId);
      await _loadAccounts();
    } catch (e) {
      _setError('Failed to delete account: $e');
    }
  }

  void selectAccount(Account account) {
    _selectedAccount = account;
    notifyListeners();
  }

  // Transaction operations
  Future<void> _loadTransactions() async {
    if (_selectedAccount != null) {
      _transactions = await _db.getAllTransactions(accountId: _selectedAccount!.id);
    } else {
      _transactions = await _db.getAllTransactions();
    }
    notifyListeners();
  }

  Future<void> addTransaction(Transaction transaction) async {
    try {
      // Validate amount
      if (transaction.amount <= 0) {
        _setError('Amount must be greater than 0');
        return;
      }
      
      await _db.createTransaction(transaction);
      
      // Update account balance
      final account = _accounts.firstWhere((a) => a.id == transaction.accountId);
      final newBalance = transaction.type == TransactionType.income
          ? account.balance + transaction.amount
          : account.balance - transaction.amount;
      
      // Check for negative balance on expense
      if (transaction.type == TransactionType.expense && newBalance < 0) {
        _setError('Insufficient balance');
        return;
      }
      
      await updateAccountBalance(account.id, newBalance);
      await _loadTransactions();
    } catch (e) {
      _setError('Failed to add transaction: $e');
    }
  }

  Future<void> updateTransaction(Transaction oldTransaction, Transaction newTransaction) async {
    try {
      // Reverse old transaction effect
      final account = _accounts.firstWhere((a) => a.id == oldTransaction.accountId);
      double balance = account.balance;
      
      if (oldTransaction.type == TransactionType.income) {
        balance -= oldTransaction.amount;
      } else {
        balance += oldTransaction.amount;
      }
      
      // Apply new transaction effect
      if (newTransaction.type == TransactionType.income) {
        balance += newTransaction.amount;
      } else {
        balance -= newTransaction.amount;
      }
      
      if (balance < 0) {
        _setError('Insufficient balance');
        return;
      }
      
      await _db.updateTransaction(newTransaction);
      await updateAccountBalance(account.id, balance);
      await _loadTransactions();
    } catch (e) {
      _setError('Failed to update transaction: $e');
    }
  }

  Future<void> deleteTransaction(Transaction transaction) async {
    try {
      await _db.deleteTransaction(transaction.id);
      
      // Reverse transaction effect on balance
      final account = _accounts.firstWhere((a) => a.id == transaction.accountId);
      final newBalance = transaction.type == TransactionType.income
          ? account.balance - transaction.amount
          : account.balance + transaction.amount;
      
      await updateAccountBalance(account.id, newBalance);
      await _loadTransactions();
    } catch (e) {
      _setError('Failed to delete transaction: $e');
    }
  }

  Future<List<Transaction>> getTransactionsByDateRange(DateTime start, DateTime end) async {
    try {
      return await _db.getTransactionsByDateRange(start: start, end: end);
    } catch (e) {
      _setError('Failed to load transactions: $e');
      return [];
    }
  }

  // Category operations
  Future<void> _loadCategories() async {
    _categories = await _db.getAllCategories();
    notifyListeners();
  }

  models.Category? getCategoryById(String id) {
    try {
      return _categories.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  // Budget operations
  Future<void> _loadBudgets() async {
    _budgets = await _db.getAllBudgets();
    notifyListeners();
  }

  Future<void> addBudget(Budget budget) async {
    try {
      await _db.createBudget(budget);
      await _loadBudgets();
    } catch (e) {
      _setError('Failed to add budget: $e');
    }
  }

  Future<void> updateBudget(Budget budget) async {
    try {
      await _db.updateBudget(budget);
      await _loadBudgets();
    } catch (e) {
      _setError('Failed to update budget: $e');
    }
  }

  Future<void> deleteBudget(String budgetId) async {
    try {
      await _db.deleteBudget(budgetId);
      await _loadBudgets();
    } catch (e) {
      _setError('Failed to delete budget: $e');
    }
  }

  // Analytics
  Future<Map<String, double>> getSpendingByCategory(DateTime start, DateTime end) async {
    try {
      return await _db.getSpendingByCategory(start: start, end: end);
    } catch (e) {
      _setError('Failed to load spending data: $e');
      return {};
    }
  }

  Future<double> getTotalIncome(DateTime start, DateTime end) async {
    try {
      return await _db.getTotalIncome(start: start, end: end);
    } catch (e) {
      _setError('Failed to load income data: $e');
      return 0.0;
    }
  }

  Future<double> getTotalExpenses(DateTime start, DateTime end) async {
    try {
      return await _db.getTotalExpenses(start: start, end: end);
    } catch (e) {
      _setError('Failed to load expense data: $e');
      return 0.0;
    }
  }

  double getSpentForCategory(String categoryId) {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);
    
    return _transactions
        .where((t) =>
            t.category == categoryId &&
            t.type == TransactionType.expense &&
            t.date.isAfter(startOfMonth) &&
            t.date.isBefore(endOfMonth))
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
