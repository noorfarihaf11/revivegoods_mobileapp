import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:revivegoods/api_url.dart';

class PickupData {
  final int idPickupReq;
  final String scheduledAt;
  final String address;
  final String status;
  final String totalCoins;

  PickupData({
    required this.idPickupReq,
    required this.scheduledAt,
    required this.address,
    required this.status,
    required this.totalCoins,
  });

  factory PickupData.fromJson(Map<String, dynamic> json) {
    return PickupData(
      idPickupReq: json['id_pickupreq'],
      scheduledAt: json['scheduled_at'],
      address: json['address'],
      status: json['status'],
      totalCoins: json['total_coins'].toString(),
    );
  }
}

class PickupProvider with ChangeNotifier {
  List<PickupData> _pickupData = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<PickupData> get pickupData => _pickupData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // ✅ Add totalCoins getter to calculate total coins from all pickups
  int get totalCoins {
    return totalCoins;
  }

  // ✅ Get coins for a specific pickup
  int getCoinsForPickup(int pickupId) {
    try {
      final pickup = _pickupData.firstWhere(
            (p) => p.idPickupReq == pickupId,
      );
      return int.tryParse(pickup.totalCoins) ?? 0;
    } catch (e) {
      return 0;
    }
  }

  // ✅ Get total coins by status
  int getCoinsByStatus(String status) {
    int total = 0;
    for (var pickup in _pickupData.where((p) => p.status == status)) {
      int coins = int.tryParse(pickup.totalCoins) ?? 0;
      total += coins;
    }
    return total;
  }

  Future<void> fetchPickupData(String token) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse("${ApiUrl.HistoryUrl}"),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _pickupData = (data['pickupData'] as List)
            .map((item) => PickupData.fromJson(item))
            .toList();
      } else {
        _errorMessage = 'Failed to load data: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearData() {
    _pickupData = [];
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}
