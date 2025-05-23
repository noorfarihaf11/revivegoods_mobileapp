class UserModel {
  final int id_user;
  final String name;
  final String email;
  final int coins;

  UserModel({
    required this.id_user,
    required this.name,
    required this.email,
    required this.coins,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id_user: json['id_user'],
      name: json['name'],
      email: json['email'],
      coins: json['coins'],
    );
  }
}
