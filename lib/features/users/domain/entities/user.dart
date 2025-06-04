import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String username;
  final String image;
  final int age;
  final String gender;
  final String birthDate;
  final String bloodGroup;
  final double height;
  final double weight;
  final String phone;

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.username,
    required this.image,
    required this.age,
    required this.gender,
    required this.birthDate,
    required this.bloodGroup,
    required this.height,
    required this.weight,
    required this.phone,
  });

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    email,
    username,
    image,
    age,
    gender,
    birthDate,
    bloodGroup,
    height,
    weight,
    phone,
  ];
}
