class UserModel {
  final String? username;
  final String? phoneNumber;
  final String? password;

  UserModel({
    this.username,
    required this.phoneNumber,
    this.password,
    // required this.password, ene talbar required gesen ug
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        username: json['username'],
        phoneNumber: json['phoneNumber'],
        password: json['password']);
  }
}
