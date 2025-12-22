enum BillType {
  electricity,
  water,
  gas,
  internet,
  mobile,
  landline,
  government,
}

enum BillStatus {
  pending,
  paid,
  overdue,
  cancelled,
}

class BillPayment {
  final String id;
  final String userId;
  final String accountId;
  final BillType type;
  final String providerName;
  final String serviceNumber;
  final double amount;
  final DateTime dueDate;
  final DateTime? paidDate;
  final BillStatus status;
  final String? reference;
  final String? notes;

  BillPayment({
    required this.id,
    required this.userId,
    required this.accountId,
    required this.type,
    required this.providerName,
    required this.serviceNumber,
    required this.amount,
    required this.dueDate,
    this.paidDate,
    this.status = BillStatus.pending,
    this.reference,
    this.notes,
  });

  bool get isOverdue {
    return status == BillStatus.pending && DateTime.now().isAfter(dueDate);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'accountId': accountId,
      'type': type.toString().split('.').last,
      'providerName': providerName,
      'serviceNumber': serviceNumber,
      'amount': amount,
      'dueDate': dueDate.toIso8601String(),
      'paidDate': paidDate?.toIso8601String(),
      'status': status.toString().split('.').last,
      'reference': reference,
      'notes': notes,
    };
  }

  factory BillPayment.fromMap(Map<String, dynamic> map) {
    return BillPayment(
      id: map['id'] as String,
      userId: map['userId'] as String,
      accountId: map['accountId'] as String,
      type: BillType.values.firstWhere(
        (e) => e.toString().split('.').last == map['type'],
      ),
      providerName: map['providerName'] as String,
      serviceNumber: map['serviceNumber'] as String,
      amount: (map['amount'] as num).toDouble(),
      dueDate: DateTime.parse(map['dueDate'] as String),
      paidDate: map['paidDate'] != null
          ? DateTime.parse(map['paidDate'] as String)
          : null,
      status: BillStatus.values.firstWhere(
        (e) => e.toString().split('.').last == map['status'],
      ),
      reference: map['reference'] as String?,
      notes: map['notes'] as String?,
    );
  }
}

// Egyptian Service Providers
class EgyptianServiceProviders {
  static const Map<BillType, List<String>> providers = {
    BillType.electricity: [
      'Egyptian Electricity Holding Company',
      'Cairo Electricity Distribution',
      'Alexandria Electricity Distribution',
      'Canal Electricity Distribution',
      'Delta Electricity Distribution',
      'Upper Egypt Electricity Distribution',
    ],
    BillType.water: [
      'Cairo Water Company',
      'Alexandria Water Company',
      'Giza Water Company',
      'Canal Water Company',
    ],
    BillType.gas: [
      'Egyptian Natural Gas Company (GASCO)',
      'Town Gas Company',
    ],
    BillType.internet: [
      'Telecom Egypt (TE Data)',
      'Vodafone Egypt',
      'Orange Egypt',
      'Etisalat Misr (WE)',
      'Noor DSL',
    ],
    BillType.mobile: [
      'Vodafone Egypt',
      'Orange Egypt',
      'Etisalat Misr (WE)',
    ],
    BillType.landline: [
      'Telecom Egypt',
    ],
    BillType.government: [
      'Traffic Fines',
      'Tax Authority',
      'Social Insurance',
      'Real Estate Tax',
    ],
  };

  static List<String> getProviders(BillType type) {
    return providers[type] ?? [];
  }
}
