class Budget {
  final String id;
  final String categoryId;
  final double limit;
  final DateTime startDate;
  final DateTime endDate;

  Budget({
    required this.id,
    required this.categoryId,
    required this.limit,
    required this.startDate,
    required this.endDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoryId': categoryId,
      'limit': limit,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }

  factory Budget.fromMap(Map<String, dynamic> map) {
    return Budget(
      id: map['id'] as String,
      categoryId: map['categoryId'] as String,
      limit: (map['limit'] as num).toDouble(),
      startDate: DateTime.parse(map['startDate'] as String),
      endDate: DateTime.parse(map['endDate'] as String),
    );
  }

  bool isActive() {
    final now = DateTime.now();
    return now.isAfter(startDate) && now.isBefore(endDate);
  }

  // Firestore serialization
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'categoryId': categoryId,
      'limit': limit,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }

  factory Budget.fromFirestore(dynamic doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Budget(
      id: doc.id,
      categoryId: data['categoryId'] as String,
      limit: (data['limit'] as num).toDouble(),
      startDate: DateTime.parse(data['startDate'] as String),
      endDate: DateTime.parse(data['endDate'] as String),
    );
  }
}
