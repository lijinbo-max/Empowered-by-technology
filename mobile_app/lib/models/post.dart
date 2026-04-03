class Post {
  final int id;
  final int userId;
  final String title;
  final String content;
  final String author;
  final String createdAt;
  final int likes;
  final int comments;

  Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.author,
    required this.createdAt,
    required this.likes,
    required this.comments,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      content: json['content'],
      author: json['author'],
      createdAt: json['created_at'],
      likes: json['likes'] ?? 0,
      comments: json['comments'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'content': content,
      'author': author,
      'created_at': createdAt,
      'likes': likes,
      'comments': comments,
    };
  }
}

class Comment {
  final int id;
  final int postId;
  final int userId;
  final String content;
  final String author;
  final String createdAt;

  Comment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.content,
    required this.author,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      postId: json['post_id'],
      userId: json['user_id'],
      content: json['content'],
      author: json['author'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'post_id': postId,
      'user_id': userId,
      'content': content,
      'author': author,
      'created_at': createdAt,
    };
  }
}