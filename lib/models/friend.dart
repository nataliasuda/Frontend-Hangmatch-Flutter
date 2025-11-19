class Friend {
  final String id;
  final String email;
  final String name; 
  final String? status;
  

  Friend({
    required this.id,
    required this.email,
    required this.name,
    required this.status,
  });

    factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      id: json['id'],
      email: json['email'],
      name: json['name'] ?? 'User',
      status: json['status'],
    );
  }
}