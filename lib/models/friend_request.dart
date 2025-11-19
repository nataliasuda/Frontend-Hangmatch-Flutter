class FriendRequest {
  final String id;
  final String senderEmail;
  final String senderName; 
  final String status;

  FriendRequest({
    required this.id,
    required this.senderEmail,
    required this.senderName,
    required this.status,
  });
  
  factory FriendRequest.fromJson(Map<String, dynamic> json){
    return FriendRequest(
      id: json['id'],
      senderEmail: json['sender_email'] ?? '',
      senderName: json['sender_name'] ?? 'User',
      status: json['status'] ?? 'pending',
    );
  }
}
