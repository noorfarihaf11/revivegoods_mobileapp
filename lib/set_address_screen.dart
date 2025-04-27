import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'order_summary_screen.dart';

class SetAddressScreen extends StatefulWidget {
  final List<Map<String, dynamic>> selectedItems;

  const SetAddressScreen({
    Key? key,
    required this.selectedItems,
  }) : super(key: key);

  @override
  State<SetAddressScreen> createState() => _SetAddressScreenState();
}

class _SetAddressScreenState extends State<SetAddressScreen> {
  int _selectedDay = 2; // Default to Saturday (index 2)
  int _selectedHour = 10;
  bool _isAM = true;
  final TextEditingController _addressController = TextEditingController();

  final List<Map<String, dynamic>> _days = [
    {'day': 'THU', 'date': '8'},
    {'day': 'FRI', 'date': '9'},
    {'day': 'SAT', 'date': '10'},
    {'day': 'SUN', 'date': '11'},
    {'day': 'MON', 'date': '12'},
  ];

  @override
  void initState() {
    super.initState();
    _addressController.text = 'Emerald Blue Cluster B-25, Joggers Park, Melbourne, 61116';
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  String _getFormattedDate() {
    final Map<String, String> months = {
      'THU': 'September',
      'FRI': 'September',
      'SAT': 'September',
      'SUN': 'September',
      'MON': 'September',
    };

    final day = _days[_selectedDay]['day'];
    final date = _days[_selectedDay]['date'];
    final month = months[day];

    return '$day, ${date}th $month 2025';
  }

  String _getFormattedTime() {
    return '$_selectedHour ${_isAM ? 'AM' : 'PM'}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Pickup Details'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Map view
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                // Placeholder for map - in a real app, use Google Maps or other map provider
                Container(
                  color: Colors.grey[300],
                  width: double.infinity,
                  child: Center(
                    child: Icon(
                      Icons.map,
                      size: 100,
                      color: Colors.grey[400],
                    ),
                  ),
                ),

                // Location pin
                Center(
                  child: Icon(
                    Icons.location_pin,
                    color: theme.colorScheme.primary,
                    size: 40,
                  ),
                ),
              ],
            ),
          ),

          // Address and time selection
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'When do you want us to pick up?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Day selector - fixed width container
                    Container(
                      height: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(_days.length, (index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedDay = index;
                              });
                            },
                            child: Container(
                              width: 60,
                              decoration: BoxDecoration(
                                color: _selectedDay == index
                                    ? theme.colorScheme.primary
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: _selectedDay == index
                                      ? theme.colorScheme.primary
                                      : Colors.grey.shade300,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _days[index]['day'],
                                    style: TextStyle(
                                      color: _selectedDay == index
                                          ? Colors.white
                                          : theme.colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _days[index]['date'],
                                    style: TextStyle(
                                      color: _selectedDay == index
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      'When do you want us to pick the order?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // AM/PM toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildTimeToggle('AM', _isAM),
                        const SizedBox(width: 16),
                        _buildTimeToggle('PM', !_isAM),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Hour selector
                    Container(
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(12, (index) {
                          final hour = index + 1;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedHour = hour;
                              });
                            },
                            child: Container(
                              width: 28,
                              decoration: BoxDecoration(
                                color: _selectedHour == hour
                                    ? theme.colorScheme.primary
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  hour.toString(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: _selectedHour == hour
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Address input
                    TextField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: 'Address',
                        hintText: 'Enter your pickup address',
                        prefixIcon: const Icon(Icons.location_on_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Next button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to order summary screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderSummaryScreen(
                                selectedDate: _getFormattedDate(),
                                selectedTime: _getFormattedTime(),
                                address: _addressController.text,
                                orderItems: widget.selectedItems,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          'Next',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeToggle(String label, bool isSelected) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        setState(() {
          _isAM = label == 'AM';
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

