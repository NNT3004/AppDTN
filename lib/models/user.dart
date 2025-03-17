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
    return User(
      id: json['id'],
      fullname: json['fullname'] ?? '',
      studentId: json['studentId'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      address: json['address'] ?? '',
      username: json['username'] ?? '',
      dateOfBirth:
          json['dateOfBirth'] != null
              ? DateTime.parse(json['dateOfBirth'])
              : null,
      isActive: json['isActive'] ?? false,
      department: json['Department'],
      clazz: json['clazz'],
    );
  }
}
