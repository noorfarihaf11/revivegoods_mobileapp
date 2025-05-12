import 'package:flutter/material.dart';
import 'order_summary_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:revivegoods/api_url.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';


class SetAddressScreen extends StatefulWidget {
  final List<Map<String, dynamic>> selectedItems;


  const SetAddressScreen({
    Key? key,
    required this.selectedItems,
  }) : super(key: key);

  @override
  State<SetAddressScreen> createState() => _SetAddressScreenState();
}

class MapView extends StatelessWidget {
  final LatLng center;
  final Function(LatLng) onTap;

  const MapView({super.key, required this.center, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: center,
        zoom: 13.0,
        onTap: (tapPosition, point) {
          onTap(point);
        },
      ),
      children: [
        TileLayer(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: const ['a', 'b', 'c'],
          userAgentPackageName: 'com.example.app',
        ),
        MarkerLayer(
          markers: [
            Marker(
              width: 40.0,
              height: 40.0,
              point: center,
              builder: (ctx) => const Icon(Icons.location_pin, color: Colors.red, size: 40),
            ),
          ],
        ),
      ],
    );
  }
}


class _SetAddressScreenState extends State<SetAddressScreen> {
  int _selectedDay = 2; // Default to Saturday (index 2)
  int _selectedHour = 10;
  bool _isAM = true;
  LatLng _selectedLatLng = LatLng(-6.2, 106.816666); // Jakarta sebagai default
  TimeOfDay _selectedTime = TimeOfDay(hour: 10, minute: 0);
  final TextEditingController _addressController = TextEditingController();

  late List<Map<String, dynamic>> _days;


  @override
  void initState() {
    super.initState();

    final today = DateTime.now();
    _days = List.generate(5, (index) {
      final date = today.add(Duration(days: index));
      return {
        'day': _getShortDayName(date.weekday),
        'date': date.day.toString(),
        'fullDate': date, // kita simpan ini untuk pemrosesan tanggal
      };
    });

    _addressController.text = 'Emerald Blue Cluster B-25, Joggers Park, Melbourne, 61116';
  }

  String _getShortDayName(int weekday) {
    const dayNames = {
      1: 'MON',
      2: 'TUE',
      3: 'WED',
      4: 'THU',
      5: 'FRI',
      6: 'SAT',
      7: 'SUN',
    };
    return dayNames[weekday] ?? '';
  }

  String _getMonthName(int month) {
    const months = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month];
  }



  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  String _getFormattedDate() {
    final selectedDate = _days[_selectedDay]['fullDate'] as DateTime;
    final dayName = _getShortDayName(selectedDate.weekday);
    final monthName = _getMonthName(selectedDate.month);
    return '$dayName, ${selectedDate.day}th $monthName ${selectedDate.year}';
  }


  String _getFormattedTime() {
    return _selectedTime.format(context); // output otomatis dalam format 10:00 AM
  }

  Future<void> _updateAddressFromLatLng(LatLng position) async {
    final url =
        'https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=${position.latitude}&lon=${position.longitude}';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'User-Agent': 'FlutterApp (noorfarihaf11@gmail.com)', // Ganti dengan emailmu
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final address = data['display_name'];
        if (address != null) {
          setState(() {
            _addressController.text = address;
          });
        } else {
          print('Geocoding failed: No address found');
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Geocoding error: $e');
    }
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
            child: MapView(
              center: _selectedLatLng,
              onTap: (LatLng position) {
                setState(() {
                  _selectedLatLng = position;
                });
                _updateAddressFromLatLng(position);
              },
            ),
          ),


          // Address and time selection
      Container(
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
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Prevent the column from expanding unnecessarily
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


                    const SizedBox(height: 16),
                    Text(
                      'Pickup Time',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedTime.format(context),
                          style: const TextStyle(fontSize: 16),
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.access_time),
                          label: const Text('Pick Time'),
                          onPressed: () async {
                            final pickedTime = await showTimePicker(
                              context: context,
                              initialTime: _selectedTime,
                            );
                            if (pickedTime != null) {
                              setState(() {
                                _selectedTime = pickedTime;
                              });
                            }
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Address input
                    TextField(
                      controller: _addressController,
                      readOnly: true,
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

