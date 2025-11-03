class FriendRequest {
  final int id;
  final String senderEmail;

  FriendRequest({required this.id, required this.senderEmail});
  
  factory FriendRequest.fromJson(Map<String,dynamic> json){
    return FriendRequest(id: json['id'], senderEmail: json['sender_email']);
  }

}
