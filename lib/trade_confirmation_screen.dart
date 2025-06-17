import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api_url.dart';
import '../utils/app_colors.dart';
import 'trade_success_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TradeConfirmationScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const TradeConfirmationScreen({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<TradeConfirmationScreen> createState() => _TradeConfirmationScreenState();
}

class _TradeConfirmationScreenState extends State<TradeConfirmationScreen> {
  int _userCoins = 0;

  @override
  void initState() {
    super.initState();
    _loadUserCoins();
  }


  Future<void> _loadUserCoins() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) return;

    final response = await http.get(
      Uri.parse("${ApiUrl.HomeUrl}"),// Sesuaikan URL-nya
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _userCoins = data['user']['coins'] ?? 0; // Sesuaikan dengan struktur JSON kamu
      });
    }
  }

  bool _isLoading = false;

  int get _totalCost => (widget.product['coin_cost'] as num?)?.toInt() ?? 0;
  bool get _canAfford => _userCoins >= _totalCost;
  int get _remainingCoins => _userCoins - _totalCost;

  Future<void> _confirmTrade() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Authentication token not found')),
      );
      setState(() => _isLoading = false);
      return;
    }

    final url = Uri.parse("${ApiUrl.RedeemUrl}");
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'id_exchangeitem': widget.product['id_exchangeitem'],
      }),
    );

    print('Response: ${response.statusCode} - ${response.body}'); // Debug log

    if (response.statusCode == 200) {
      try {
        final decodedResponse = jsonDecode(response.body);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TradeSuccessScreen(
              product: widget.product,
              totalCost: _totalCost,
              remainingCoins: _remainingCoins,
            ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid response format')),
        );
      }
    } else if (response.statusCode == 400) {
      try {
        final error = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error['message'] ?? 'Failed to redeem')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to redeem')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to redeem: ${response.body}')),
      );
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Confirm Trade',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey[100],
                            ),
                            child: Center(
                              child: Image.asset(
                                widget.product['image'],
                                width: 80,
                                height: 80,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.eco,
                                    size: 60,
                                    color: AppColors.primary.withOpacity(0.5),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.product['name'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  widget.product['description'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${widget.product['rating']} (${widget.product['reviews']} reviews)',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Features:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...widget.product['features'].map<Widget>((feature) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              feature,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      )).toList(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Cost Breakdown',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Your Current Coins:'),
                          Row(
                            children: [
                              const Icon(
                                Icons.monetization_on,
                                color: Colors.amber,
                                size: 18,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _userCoins.toString(),
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Cost:'),
                          Row(
                            children: [
                              const Icon(
                                Icons.monetization_on,
                                color: Colors.amber,
                                size: 18,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _totalCost.toString(),
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Remaining Coins:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.monetization_on,
                                color: Colors.amber,
                                size: 18,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _remainingCoins.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _canAfford ? Colors.green : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (!_canAfford) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.warning,
                                color: Colors.red,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Expanded(
                                child: Text(
                                  'Insufficient coins for this trade',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: _canAfford && !_isLoading ? _confirmTrade : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _canAfford && !_isLoading ? AppColors.primary : Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(color: Colors.white),
            )
                : Text(
              _canAfford ? 'Confirm Trade' : 'Insufficient Coins',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}