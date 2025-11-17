enum UserType {
  public,
  staff,
}

class UserModel {
  final String phone;
  final String name;
  final UserType userType;
  final DateTime createdAt;

  UserModel({
    required this.phone,
    required this.name,
    required this.userType,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'phone': phone,
    'name': name,
    'userType': userType.toString().split('.').last,
    'createdAt': createdAt.toIso8601String(),
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    phone: json['phone'] ?? '',
    name: json['name'] ?? '',
    userType: UserType.values.firstWhere(
      (e) => e.toString().split('.').last == json['userType'],
      orElse: () => UserType.public,
    ),
    createdAt: json['createdAt'] != null
        ? DateTime.parse(json['createdAt'])
        : DateTime.now(),
  );
}