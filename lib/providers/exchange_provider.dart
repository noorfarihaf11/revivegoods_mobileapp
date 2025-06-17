import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/ExchangeRequest.dart';
import 'package:revivegoods/api_url.dart';

class ExchangeProvider with ChangeNotifier {
  List<ExchangeRequest> _requests = [];
  bool isLoading = false;
  String? errorMessage;

  List<ExchangeRequest> get requests => _requests;

  Future<void> fetchExchangeRequests(String token) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse("${ApiUrl.ExchangeUrl}"),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body)['data'] as List;
        _requests = jsonData.map((e) => ExchangeRequest.fromJson(e)).toList();
      } else {
        errorMessage = 'Failed to load exchange requests';
      }
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}
