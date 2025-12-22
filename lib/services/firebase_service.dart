/// Mock Firebase Service for Development
/// This simulates Firebase behavior without requiring actual Firebase setup
/// Easy to replace with real Firebase later

class MockFirebaseService {
  static final MockFirebaseService instance = MockFirebaseService._init();
  
  // In-memory storage (simulates Firestore)
  final Map<String, Map<String, dynamic>> _users = {};
  final Map<String, Map<String, dynamic>> _userProfiles = {};
  final Map<String, List<Map<String, dynamic>>> _userAccounts = {};
  final Map<String, List<Map<String, dynamic>>> _userCards = {};
  final Map<String, List<Map<String, dynamic>>> _userTransactions = {};
  final Map<String, List<Map<String, dynamic>>> _userBeneficiaries = {};
  final Map<String, List<Map<String, dynamic>>> _userBills = {};
  
  // Simulated OTP storage
  final Map<String, String> _otpCodes = {};
  
  MockFirebaseService._init() {
    _initializeTestData();
  }

  // Initialize with test data for quick testing
  void _initializeTestData() {
    // Test user credentials
    final testUserId = 'test_user_123';
    final testNationalId = '29912011234567';
    
    _users[testNationalId] = {
      'id': testUserId,
      'nationalId': testNationalId,
      'phoneNumber': '+201012345678',
      'pin': '123456',
      'createdAt': DateTime.now().toIso8601String(),
    };
    
    _userProfiles[testUserId] = {
      'id': testUserId,
      'nationalId': testNationalId,
      'fullNameArabic': 'محمد أحمد',
      'fullNameEnglish': 'Mohamed Ahmed',
      'phoneNumber': '+201012345678',
      'email': 'test@example.com',
      'dateOfBirth': DateTime(1999, 12, 1).toIso8601String(),
      'governorate': 'Cairo',
      'city': 'Nasr City',
      'street': '123 Test Street',
      'kycStatus': 'verified',
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  // Authentication
  Future<Map<String, dynamic>?> signInWithNationalId(
    String nationalId,
    String pin,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
    
    final user = _users[nationalId];
    if (user != null && user['pin'] == pin) {
      return {
        'userId': user['id'],
        'nationalId': nationalId,
      };
    }
    return null;
  }

  Future<Map<String, dynamic>> registerUser({
    required String nationalId,
    required String phoneNumber,
    required String pin,
    required Map<String, dynamic> profileData,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    if (_users.containsKey(nationalId)) {
      throw Exception('National ID already registered');
    }
    
    final userId = DateTime.now().millisecondsSinceEpoch.toString();
    
    _users[nationalId] = {
      'id': userId,
      'nationalId': nationalId,
      'phoneNumber': phoneNumber,
      'pin': pin,
      'createdAt': DateTime.now().toIso8601String(),
    };
    
    _userProfiles[userId] = {
      ...profileData,
      'id': userId,
      'nationalId': nationalId,
      'phoneNumber': phoneNumber,
    };
    
    return {
      'userId': userId,
      'nationalId': nationalId,
    };
  }

  // OTP Simulation
  Future<String> sendOTP(String phoneNumber) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Generate random 6-digit OTP
    final otp = (100000 + DateTime.now().millisecondsSinceEpoch % 900000).toString();
    _otpCodes[phoneNumber] = otp;
    
    // In real app, this would send SMS
    print('📱 OTP for $phoneNumber: $otp'); // For development
    
    return otp;
  }

  Future<bool> verifyOTP(String phoneNumber, String otp) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    final storedOtp = _otpCodes[phoneNumber];
    if (storedOtp == otp) {
      _otpCodes.remove(phoneNumber);
      return true;
    }
    return false;
  }

  // User Profile
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _userProfiles[userId];
  }

  Future<void> updateUserProfile(String userId, Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _userProfiles[userId] = {..._userProfiles[userId] ?? {}, ...data};
  }

  // Accounts
  Future<void> addAccount(String userId, Map<String, dynamic> account) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _userAccounts[userId] = [...(_userAccounts[userId] ?? []), account];
  }

  Future<List<Map<String, dynamic>>> getAccounts(String userId) async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _userAccounts[userId] ?? [];
  }

  // Cards
  Future<void> addCard(String userId, Map<String, dynamic> card) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _userCards[userId] = [...(_userCards[userId] ?? []), card];
  }

  Future<List<Map<String, dynamic>>> getCards(String userId) async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _userCards[userId] ?? [];
  }

  Future<void> updateCard(String userId, String cardId, Map<String, dynamic> updates) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final cards = _userCards[userId] ?? [];
    final index = cards.indexWhere((c) => c['id'] == cardId);
    if (index != -1) {
      cards[index] = {...cards[index], ...updates};
      _userCards[userId] = cards;
    }
  }

  // Transactions
  Future<void> addTransaction(String userId, Map<String, dynamic> transaction) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _userTransactions[userId] = [...(_userTransactions[userId] ?? []), transaction];
  }

  Future<List<Map<String, dynamic>>> getTransactions(String userId) async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _userTransactions[userId] ?? [];
  }

  // Beneficiaries
  Future<void> addBeneficiary(String userId, Map<String, dynamic> beneficiary) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _userBeneficiaries[userId] = [...(_userBeneficiaries[userId] ?? []), beneficiary];
  }

  Future<List<Map<String, dynamic>>> getBeneficiaries(String userId) async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _userBeneficiaries[userId] ?? [];
  }

  // Bills
  Future<void> addBill(String userId, Map<String, dynamic> bill) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _userBills[userId] = [...(_userBills[userId] ?? []), bill];
  }

  Future<List<Map<String, dynamic>>> getBills(String userId) async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _userBills[userId] ?? [];
  }

  // Validation Helpers
  static bool isValidEgyptianNationalId(String nationalId) {
    // Egyptian National ID is 14 digits
    if (nationalId.length != 14) return false;
    if (!RegExp(r'^\d+$').hasMatch(nationalId)) return false;
    
    // First digit: century (2 or 3)
    final century = int.parse(nationalId[0]);
    if (century != 2 && century != 3) return false;
    
    return true;
  }

  static bool isValidEgyptianPhone(String phone) {
    // Egyptian phone: +20 followed by 10/11/12/15 and 8 more digits
    final cleaned = phone.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cleaned.startsWith('20')) {
      final withoutCode = cleaned.substring(2);
      if (withoutCode.length != 10) return false;
      final prefix = withoutCode.substring(0, 2);
      return ['10', '11', '12', '15'].contains(prefix);
    }
    
    if (cleaned.length != 11) return false;
    final prefix = cleaned.substring(0, 3);
    return ['010', '011', '012', '015'].contains(prefix);
  }

  // Clear all data (for testing)
  void clearAll() {
    _users.clear();
    _userProfiles.clear();
    _userAccounts.clear();
    _userCards.clear();
    _userTransactions.clear();
    _userBeneficiaries.clear();
    _userBills.clear();
    _otpCodes.clear();
  }
}
