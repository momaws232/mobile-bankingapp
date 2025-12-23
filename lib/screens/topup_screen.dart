import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TopUpScreen extends StatefulWidget {
  const TopUpScreen({super.key});

  @override
  State<TopUpScreen> createState() => _TopUpScreenState();
}

class _TopUpScreenState extends State<TopUpScreen> {
  final _phoneController = TextEditingController();
  String _selectedOperator = 'Vodafone';
  double _selectedAmount = 50.0;

  final List<String> _operators = [
    'Vodafone',
    'Orange',
    'Etisalat (WE)',
    'Telecom Egypt',
  ];

  final List<double> _quickAmounts = [10, 20, 50, 100, 200, 500];

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Mobile Top-up'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Phone Number Section
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Phone Number',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: '+20 10XXXXXXXX',
                      prefixIcon: const Icon(Icons.phone),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.contacts, color: Color(0xFF00E676)),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Select Contact'),
                              content: SizedBox(
                                width: double.maxFinite,
                                child: ListView(
                                  shrinkWrap: true,
                                  children: [
                                    _buildContactTile('Mom', '+20 101 234 5678', Icons.person),
                                    _buildContactTile('Dad', '+20 100 987 6543', Icons.person),
                                    _buildContactTile('Ahmed', '+20 111 222 3333', Icons.person),
                                    _buildContactTile('Sara', '+20 122 333 4444', Icons.person),
                                    _buildContactTile('Office', '+20 155 666 7777', Icons.business),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(11),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Operator Selection
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Operator',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _operators.map((operator) {
                      final isSelected = _selectedOperator == operator;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedOperator = operator;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF00E676).withOpacity(0.1)
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF00E676)
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Text(
                            operator,
                            style: TextStyle(
                              color: isSelected
                                  ? const Color(0xFF00E676)
                                  : Colors.black,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Amount Selection
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Amount',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 2,
                    children: _quickAmounts.map((amount) {
                      final isSelected = _selectedAmount == amount;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedAmount = amount;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF00E676)
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              '\$${amount.toInt()}',
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Top-up Button
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Top-up of \$${_selectedAmount.toInt()} successful!'),
                        backgroundColor: const Color(0xFF00E676),
                      ),
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00E676),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Top-up \$${_selectedAmount.toInt()}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactTile(String name, String phone, IconData icon) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: const Color(0xFF00E676).withOpacity(0.1),
        child: Icon(icon, color: const Color(0xFF00E676)),
      ),
      title: Text(name),
      subtitle: Text(phone),
      onTap: () {
        setState(() {
          _phoneController.text = phone;
        });
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Selected $name'),
            backgroundColor: const Color(0xFF00E676),
          ),
        );
      },
    );
  }
}
