import 'package:flutter/material.dart';

class User {
  final int id;
  final String fullname;
  final String studentId;
  final String email;
  final String phoneNumber;
  final String address;
  final String username;
  final DateTime? dateOfBirth;
  final bool isActive;
  final String? department;
  final String? clazz;

  User({
    required this.id,
    required this.fullname,
    required this.studentId,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.username,
    this.dateOfBirth,
    required this.isActive,
    this.department,
    this.clazz,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    try {
      return User(
        id: json['id'] ?? 0,
        fullname: json['fullname'] ?? '',
        studentId: json['studentId'] ?? '',
        email: json['email'] ?? '',
        phoneNumber: json['phoneNumber'] ?? '',
        address: json['address'] ?? '',
        username: json['username'] ?? '',
        dateOfBirth:
            json['dateOfBirth'] != null
                ? DateTime.tryParse(json['dateOfBirth'])
                : null,
        isActive: json['isActive'] ?? false,
        department: json['Department'] ?? json['department'],
        clazz: json['clazz'] ?? json['class'],
      );
    } catch (e) {
      debugPrint('❌ Error in User.fromJson: $e');
      debugPrint('❌ Raw JSON: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullname': fullname,
      'studentId': studentId,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'username': username,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'isActive': isActive,
      'department': department,
      'clazz': clazz,
    };
  }
}
