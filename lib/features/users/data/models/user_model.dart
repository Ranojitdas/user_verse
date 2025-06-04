import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.username,
    required super.image,
    required super.age,
    required super.gender,
    required super.birthDate,
    required super.bloodGroup,
    required super.height,
    required super.weight,
    required super.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      username: json['username'],
      image: json['image'],
      age: json['age'] ?? 0,
      gender: json['gender'] ?? '',
      birthDate: json['birthDate'] ?? '',
      bloodGroup: json['bloodGroup'] ?? '',
      height: (json['height'] ?? 0.0).toDouble(),
      weight: (json['weight'] ?? 0.0).toDouble(),
      phone: json['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'username': username,
      'image': image,
      'age': age,
      'gender': gender,
      'birthDate': birthDate,
      'bloodGroup': bloodGroup,
      'height': height,
      'weight': weight,
      'phone': phone,
    };
  }
}
