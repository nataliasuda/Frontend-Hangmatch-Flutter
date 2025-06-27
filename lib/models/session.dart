class Session {
  final String? id;
  final String name;
  final int locationRadius;
  final List<int> invitedUserIds;

  Session({
     this.id,
    required this.name,
    required this.locationRadius,
    required this.invitedUserIds,
  });

   factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id']?.toString(),
      name: json['name'],
      locationRadius: json['location_radius'],
      invitedUserIds: List<int>.from(json['invited_users_ids'] ?? []),
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