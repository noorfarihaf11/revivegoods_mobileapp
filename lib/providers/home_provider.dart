import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:revivegoods/api_url.dart';


import 'package:revivegoods/models/HomeDataModel.dart';
import 'package:revivegoods/models/ExchangeItemModel.dart';
import 'package:revivegoods/models/UserModel.dart';


class HomeDataProvider with ChangeNotifier {
  UserModel? _user;
  List<ExchangeItem> _exchangeItems = [];
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get user => _user;
  List<ExchangeItem> get exchangeItems => _exchangeItems;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchHomeData(String token) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse("${ApiUrl.HomeUrl}"),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('Home Data response status: ${response.statusCode}');
      print('Home Data response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final homeData = HomeData.fromJson(data);

        _user = homeData.user;
        _exchangeItems = homeData.exchangeItems;
      } else {
        _errorMessage = 'Failed to load home data: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearData() {
    _user = null;
    _exchangeItems = [];
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}
