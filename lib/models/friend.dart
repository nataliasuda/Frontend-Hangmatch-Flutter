class Friend {
  final String email;
  final String status;

  Friend({required this.email, required this.status});

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(email: json['email'], status: json['status']);
  }
}
