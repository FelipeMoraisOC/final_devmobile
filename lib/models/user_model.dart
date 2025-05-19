class UserModel {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? password;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'phone': phone,
      'name': name,
      'password': password,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'].toString(),
      email: map['email'],
      phone: map['phone'],
      name: map['name'],
      password: map['password'],
    );
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? password,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
    );
  }
}
// ignore: constant_identifier_names