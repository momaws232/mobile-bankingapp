import 'package:flutter/material.dart';

enum CardType {
  debit,
  credit,
  prepaid,
}

enum CardNetwork {
  visa,
  mastercard,
  meeza, // Egyptian national payment network
}

enum CardStatus {
  active,
  frozen,
  blocked,
  expired,
}

class BankCard {
  final String id;
  final String accountId;
  final String cardNumber; // Last 4 digits only for security
  final String cardHolderName;
  final CardType type;
  final CardNetwork network;
  final DateTime expiryDate;
  final CardStatus status;
  final double dailyLimit;
  final double monthlyLimit;
  final double currentDailySpent;
  final double currentMonthlySpent;
  final bool isVirtual;
  final Color cardColor;

  BankCard({
    required this.id,
    required this.accountId,
    required this.cardNumber,
    required this.cardHolderName,
    required this.type,
    required this.network,
    required this.expiryDate,
    this.status = CardStatus.active,
    this.dailyLimit = 10000.0,
    this.monthlyLimit = 50000.0,
    this.currentDailySpent = 0.0,
    this.currentMonthlySpent = 0.0,
    this.isVirtual = false,
    this.cardColor = Colors.blue,
  });

  String get maskedCardNumber {
    return '**** **** **** $cardNumber';
  }

  String get expiryDateFormatted {
    return '${expiryDate.month.toString().padLeft(2, '0')}/${expiryDate.year.toString().substring(2)}';
  }

  bool get isExpired {
    return DateTime.now().isAfter(expiryDate);
  }

  double get dailyLimitRemaining {
    return dailyLimit - currentDailySpent;
  }

  double get monthlyLimitRemaining {
    return monthlyLimit - currentMonthlySpent;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'accountId': accountId,
      'cardNumber': cardNumber,
      'cardHolderName': cardHolderName,
      'type': type.toString().split('.').last,
      'network': network.toString().split('.').last,
      'expiryDate': expiryDate.toIso8601String(),
      'status': status.toString().split('.').last,
      'dailyLimit': dailyLimit,
      'monthlyLimit': monthlyLimit,
      'currentDailySpent': currentDailySpent,
      'currentMonthlySpent': currentMonthlySpent,
      'isVirtual': isVirtual,
      'cardColor': cardColor.value,
    };
  }

  factory BankCard.fromMap(Map<String, dynamic> map) {
    return BankCard(
      id: map['id'] as String,
      accountId: map['accountId'] as String,
      cardNumber: map['cardNumber'] as String,
      cardHolderName: map['cardHolderName'] as String,
      type: CardType.values.firstWhere(
        (e) => e.toString().split('.').last == map['type'],
      ),
      network: CardNetwork.values.firstWhere(
        (e) => e.toString().split('.').last == map['network'],
      ),
      expiryDate: DateTime.parse(map['expiryDate'] as String),
      status: CardStatus.values.firstWhere(
        (e) => e.toString().split('.').last == map['status'],
      ),
      dailyLimit: (map['dailyLimit'] as num).toDouble(),
      monthlyLimit: (map['monthlyLimit'] as num).toDouble(),
      currentDailySpent: (map['currentDailySpent'] as num).toDouble(),
      currentMonthlySpent: (map['currentMonthlySpent'] as num).toDouble(),
      isVirtual: map['isVirtual'] as bool,
      cardColor: Color(map['cardColor'] as int),
    );
  }

  BankCard copyWith({
    String? id,
    String? accountId,
    String? cardNumber,
    String? cardHolderName,
    CardType? type,
    CardNetwork? network,
    DateTime? expiryDate,
    CardStatus? status,
    double? dailyLimit,
    double? monthlyLimit,
    double? currentDailySpent,
    double? currentMonthlySpent,
    bool? isVirtual,
    Color? cardColor,
  }) {
    return BankCard(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      cardNumber: cardNumber ?? this.cardNumber,
      cardHolderName: cardHolderName ?? this.cardHolderName,
      type: type ?? this.type,
      network: network ?? this.network,
      expiryDate: expiryDate ?? this.expiryDate,
      status: status ?? this.status,
      dailyLimit: dailyLimit ?? this.dailyLimit,
      monthlyLimit: monthlyLimit ?? this.monthlyLimit,
      currentDailySpent: currentDailySpent ?? this.currentDailySpent,
      currentMonthlySpent: currentMonthlySpent ?? this.currentMonthlySpent,
      isVirtual: isVirtual ?? this.isVirtual,
      cardColor: cardColor ?? this.cardColor,
    );
  }
}
