class Session {
  final String? id;
  final String name;
  final int locationRadius;
  final List<String> invitedUserIds;
  final DateTime createdAt;
  final String status; 

  Session({
    this.id,
    required this.name,
    required this.locationRadius,
    required this.invitedUserIds,
    required this.createdAt,
    this.status = 'draft', 
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id']?.toString(),
      name: json['name'],
      locationRadius: json['location_radius'],
      invitedUserIds: List<String>.from(json['invited_users_ids'] ?? []),
      createdAt: DateTime.parse(json['created_at']),
      status: json['status'] ?? 'draft', 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'location_radius': locationRadius,
      'invited_users_ids': invitedUserIds,
      'status': status,
    };
  }
}