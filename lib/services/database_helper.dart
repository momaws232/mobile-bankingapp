import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/transaction.dart' as models;
import '../models/account.dart';
import '../models/category.dart';
import '../models/budget.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('banking_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const realType = 'REAL NOT NULL';
    const intType = 'INTEGER NOT NULL';

    // Accounts table
    await db.execute('''
      CREATE TABLE accounts (
        id $idType,
        name $textType,
        balance $realType,
        currency TEXT DEFAULT 'USD',
        type $textType,
        createdAt $textType
      )
    ''');

    // Transactions table
    await db.execute('''
      CREATE TABLE transactions (
        id $idType,
        title $textType,
        amount $realType,
        category $textType,
        date $textType,
        type $textType,
        notes TEXT,
        accountId $textType,
        FOREIGN KEY (accountId) REFERENCES accounts (id) ON DELETE CASCADE
      )
    ''');

    // Categories table
    await db.execute('''
      CREATE TABLE categories (
        id $idType,
        name $textType,
        icon $intType,
        color $intType,
        type $textType
      )
    ''');

    // Budgets table
    await db.execute('''
      CREATE TABLE budgets (
        id $idType,
        categoryId $textType,
        limit $realType,
        startDate $textType,
        endDate $textType,
        FOREIGN KEY (categoryId) REFERENCES categories (id) ON DELETE CASCADE
      )
    ''');
  }

  // Account CRUD operations
  Future<Account> createAccount(Account account) async {
    final db = await database;
    await db.insert('accounts', account.toMap());
    return account;
  }

  Future<List<Account>> getAllAccounts() async {
    final db = await database;
    final result = await db.query('accounts', orderBy: 'createdAt DESC');
    return result.map((map) => Account.fromMap(map)).toList();
  }

  Future<Account?> getAccount(String id) async {
    final db = await database;
    final maps = await db.query(
      'accounts',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return Account.fromMap(maps.first);
  }

  Future<int> updateAccount(Account account) async {
    final db = await database;
    return db.update(
      'accounts',
      account.toMap(),
      where: 'id = ?',
      whereArgs: [account.id],
    );
  }

  Future<int> deleteAccount(String id) async {
    final db = await database;
    return await db.delete(
      'accounts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Transaction CRUD operations
  Future<models.Transaction> createTransaction(models.Transaction transaction) async {
    final db = await database;
    await db.insert('transactions', transaction.toMap());
    return transaction;
  }

  Future<List<models.Transaction>> getAllTransactions({String? accountId}) async {
    final db = await database;
    List<Map<String, dynamic>> result;
    
    if (accountId != null) {
      result = await db.query(
        'transactions',
        where: 'accountId = ?',
        whereArgs: [accountId],
        orderBy: 'date DESC',
      );
    } else {
      result = await db.query('transactions', orderBy: 'date DESC');
    }
    
    return result.map((map) => models.Transaction.fromMap(map)).toList();
  }

  Future<List<models.Transaction>> getTransactionsByDateRange({
    required DateTime start,
    required DateTime end,
    String? accountId,
  }) async {
    final db = await database;
    String where = 'date >= ? AND date <= ?';
    List<dynamic> whereArgs = [start.toIso8601String(), end.toIso8601String()];
    
    if (accountId != null) {
      where += ' AND accountId = ?';
      whereArgs.add(accountId);
    }
    
    final result = await db.query(
      'transactions',
      where: where,
      whereArgs: whereArgs,
      orderBy: 'date DESC',
    );
    
    return result.map((map) => models.Transaction.fromMap(map)).toList();
  }

  Future<List<models.Transaction>> getTransactionsByCategory(String category) async {
    final db = await database;
    final result = await db.query(
      'transactions',
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'date DESC',
    );
    return result.map((map) => models.Transaction.fromMap(map)).toList();
  }

  Future<int> updateTransaction(models.Transaction transaction) async {
    final db = await database;
    return db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  Future<int> deleteTransaction(String id) async {
    final db = await database;
    return await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Category CRUD operations
  Future<Category> createCategory(Category category) async {
    final db = await database;
    await db.insert('categories', category.toMap());
    return category;
  }

  Future<List<Category>> getAllCategories() async {
    final db = await database;
    final result = await db.query('categories');
    return result.map((map) => Category.fromMap(map)).toList();
  }

  Future<int> deleteCategory(String id) async {
    final db = await database;
    return await db.delete(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Budget CRUD operations
  Future<Budget> createBudget(Budget budget) async {
    final db = await database;
    await db.insert('budgets', budget.toMap());
    return budget;
  }

  Future<List<Budget>> getAllBudgets() async {
    final db = await database;
    final result = await db.query('budgets');
    return result.map((map) => Budget.fromMap(map)).toList();
  }

  Future<Budget?> getBudgetForCategory(String categoryId) async {
    final db = await database;
    final maps = await db.query(
      'budgets',
      where: 'categoryId = ?',
      whereArgs: [categoryId],
    );
    if (maps.isEmpty) return null;
    return Budget.fromMap(maps.first);
  }

  Future<int> updateBudget(Budget budget) async {
    final db = await database;
    return db.update(
      'budgets',
      budget.toMap(),
      where: 'id = ?',
      whereArgs: [budget.id],
    );
  }

  Future<int> deleteBudget(String id) async {
    final db = await database;
    return await db.delete(
      'budgets',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Analytics queries
  Future<Map<String, double>> getSpendingByCategory({
    required DateTime start,
    required DateTime end,
  }) async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT category, SUM(amount) as total
      FROM transactions
      WHERE type = 'expense' AND date >= ? AND date <= ?
      GROUP BY category
    ''', [start.toIso8601String(), end.toIso8601String()]);
    
    Map<String, double> spending = {};
    for (var row in result) {
      spending[row['category'] as String] = (row['total'] as num).toDouble();
    }
    return spending;
  }

  Future<double> getTotalIncome({
    required DateTime start,
    required DateTime end,
  }) async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT SUM(amount) as total
      FROM transactions
      WHERE type = 'income' AND date >= ? AND date <= ?
    ''', [start.toIso8601String(), end.toIso8601String()]);
    
    if (result.isEmpty || result.first['total'] == null) return 0.0;
    return (result.first['total'] as num).toDouble();
  }

  Future<double> getTotalExpenses({
    required DateTime start,
    required DateTime end,
  }) async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT SUM(amount) as total
      FROM transactions
      WHERE type = 'expense' AND date >= ? AND date <= ?
    ''', [start.toIso8601String(), end.toIso8601String()]);
    
    if (result.isEmpty || result.first['total'] == null) return 0.0;
    return (result.first['total'] as num).toDouble();
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
