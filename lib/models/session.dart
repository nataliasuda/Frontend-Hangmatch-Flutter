class Session {
  final String? id;
  final String name;
  final int locationRadius;
  final List<int> invitedUserIds;
  final DateTime createdAt;

  Session({
    this.id,
    required this.name,
    required this.locationRadius,
    required this.invitedUserIds,
    required this.createdAt,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id']?.toString(),
      name: json['name'],
      locationRadius: json['location_radius'],
      invitedUserIds: List<int>.from(json['invited_users_ids'] ?? []),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'location_radius': locationRadius,
      'invited_users_ids': invitedUserIds,
    };
  }
}
