class ExchangeRequest {
  final int id;
  final String status;
  final String itemName;
  final String requestedAt;
  final String? address;

  ExchangeRequest({
    required this.id,
    required this.status,
    required this.itemName,
    required this.requestedAt,
    this.address,
  });

  factory ExchangeRequest.fromJson(Map<String, dynamic> json) {
    return ExchangeRequest(
      id: json['id'],
      status: json['status'],
      itemName: json['exchange_item']['name'], // pastikan backend mengirim field ini
      requestedAt: json['created_at'],
      address: json['address'],
    );
  }
}
