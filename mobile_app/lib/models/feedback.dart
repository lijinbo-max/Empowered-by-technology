class Feedback {
  final int id;
  final int userId;
  final String type;
  final String content;
  final String createdAt;

  Feedback({
    required this.id,
    required this.userId,
    required this.type,
    required this.content,
    required this.createdAt,
  });

  factory Feedback.fromJson(Map<String, dynamic> json) {
    return Feedback(
      id: json['id'],
      userId: json['user_id'],
      type: json['type'],
      content: json['content'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'content': content,
      'created_at': createdAt,
    };
  }
}