class UserProfile {
  final String userId;
  final String firstName;
  final String lastName;
  final String username;
  final String email;

  const UserProfile({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
  });

  String get fullName =>
      '$firstName $lastName'.trim();

  UserProfile copyWith({
    String? userId,
    String? firstName,
    String? lastName,
    String? username,
    String? email,
  }) {
    return UserProfile(
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      username: username ?? this.username,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'email': email,
    };
  }

  factory UserProfile.fromJson(
    Map<String, dynamic> json,
  ) {
    return UserProfile(
      userId: json['userId'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
    );
  }
}