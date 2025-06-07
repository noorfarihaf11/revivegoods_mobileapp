import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:revivegoods/api_url.dart';
import 'package:revivegoods/models/UserModel.dart'; // Pastikan UserModel sudah benar

class User {
  final int id;
  final String name;
  final String email;
  final int coins;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.coins,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id_user'],
      name: json['name'],
      email: json['email'],
      coins: json['coins'],
    );
  }
}

class UserProvider with ChangeNotifier {
  User? _user;
  User? get user => _user;

  Future<void> fetchUserData(String token) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiUrl.baseUrl}/home'), // Adjust to your user endpoint
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('User fetch status: ${response.statusCode}');
      print('User fetch response: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is Map<String, dynamic> && data.containsKey('user')) {
          _user = User.fromJson(data['user']);
        } else {
          _user = User.fromJson(data); // Fallback if user data is directly in response
        }
        notifyListeners();
      } else if (response.statusCode == 401) {
        _user = null;
        throw Exception('Unauthenticated. Please log in again.');
      } else {
        _user = null;
        throw Exception('Failed to fetch user data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user data: $e');
      _user = null;
      notifyListeners();
      rethrow;
    }
  }
}