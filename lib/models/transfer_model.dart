enum TransferType {
  bankTransfer,
  instaPay,
  fawry,
  mobileWallet,
  international,
}

enum TransferStatus {
  pending,
  processing,
  completed,
  failed,
  cancelled,
}

class MoneyTransfer {
  final String id;
  final String fromAccountId;
  final String toAccountNumber;
  final String? toBankName;
  final String? beneficiaryName;
  final double amount;
  final TransferType type;
  final TransferStatus status;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? reference;
  final String? notes;
  final double? fees;

  MoneyTransfer({
    required this.id,
    required this.fromAccountId,
    required this.toAccountNumber,
    this.toBankName,
    this.beneficiaryName,
    required this.amount,
    required this.type,
    this.status = TransferStatus.pending,
    required this.createdAt,
    this.completedAt,
    this.reference,
    this.notes,
    this.fees,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fromAccountId': fromAccountId,
      'toAccountNumber': toAccountNumber,
      'toBankName': toBankName,
      'beneficiaryName': beneficiaryName,
      'amount': amount,
      'type': type.toString().split('.').last,
      'status': status.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'reference': reference,
      'notes': notes,
      'fees': fees,
    };
  }

  factory MoneyTransfer.fromMap(Map<String, dynamic> map) {
    return MoneyTransfer(
      id: map['id'] as String,
      fromAccountId: map['fromAccountId'] as String,
      toAccountNumber: map['toAccountNumber'] as String,
      toBankName: map['toBankName'] as String?,
      beneficiaryName: map['beneficiaryName'] as String?,
      amount: (map['amount'] as num).toDouble(),
      type: TransferType.values.firstWhere(
        (e) => e.toString().split('.').last == map['type'],
      ),
      status: TransferStatus.values.firstWhere(
        (e) => e.toString().split('.').last == map['status'],
      ),
      createdAt: DateTime.parse(map['createdAt'] as String),
      completedAt: map['completedAt'] != null
          ? DateTime.parse(map['completedAt'] as String)
          : null,
      reference: map['reference'] as String?,
      notes: map['notes'] as String?,
      fees: map['fees'] != null ? (map['fees'] as num).toDouble() : null,
    );
  }
}

class Beneficiary {
  final String id;
  final String userId;
  final String name;
  final String accountNumber;
  final String? phoneNumber;
  final String? bankName;
  final TransferType preferredMethod;
  final String? nickname;
  final DateTime addedAt;

  Beneficiary({
    required this.id,
    required this.userId,
    required this.name,
    required this.accountNumber,
    this.phoneNumber,
    this.bankName,
    required this.preferredMethod,
    this.nickname,
    required this.addedAt,
  });

  String get displayName => nickname ?? name;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'accountNumber': accountNumber,
      'phoneNumber': phoneNumber,
      'bankName': bankName,
      'preferredMethod': preferredMethod.toString().split('.').last,
      'nickname': nickname,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  factory Beneficiary.fromMap(Map<String, dynamic> map) {
    return Beneficiary(
      id: map['id'] as String,
      userId: map['userId'] as String,
      name: map['name'] as String,
      accountNumber: map['accountNumber'] as String,
      phoneNumber: map['phoneNumber'] as String?,
      bankName: map['bankName'] as String?,
      preferredMethod: TransferType.values.firstWhere(
        (e) => e.toString().split('.').last == map['preferredMethod'],
      ),
      nickname: map['nickname'] as String?,
      addedAt: DateTime.parse(map['addedAt'] as String),
    );
  }
}

// Egyptian Banks
class EgyptianBanks {
  static const List<String> all = [
    'National Bank of Egypt (NBE)',
    'Banque Misr',
    'Commercial International Bank (CIB)',
    'QNB Egypt',
    'HSBC Egypt',
    'Banque du Caire',
    'Arab African International Bank (AAIB)',
    'Credit Agricole Egypt',
    'Faisal Islamic Bank',
    'Abu Dhabi Islamic Bank (ADIB)',
    'Al Baraka Bank Egypt',
    'Egyptian Gulf Bank',
    'Export Development Bank of Egypt',
    'Housing and Development Bank',
    'Suez Canal Bank',
    'United Bank',
    'Bank of Alexandria',
    'Arab Investment Bank',
    'Attijariwafa Bank Egypt',
    'Emirates NBD Egypt',
  ];
}
