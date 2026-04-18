import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/post.dart';

class PostModel extends Post {
  const PostModel({
    required super.id,
    required super.userId,
    required super.username,
    required super.content,
    super.avatarUrl,
    required super.likesCount,
    required super.commentsCount,
    required super.likedByMe,
    required super.createdAt,
  });

  factory PostModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
    String currentUserId,
  ) {
    final data = doc.data()!;
    final likedBy = (data['likedBy'] as List<dynamic>? ?? const <dynamic>[])
        .map((item) => item.toString())
        .toList();

    return PostModel(
      id: doc.id,
      userId: data['userId'] as String,
      username: data['username'] as String,
      content: data['content'] as String,
      avatarUrl: data['avatarUrl'] as String?,
      likesCount: (data['likesCount'] as num?)?.toInt() ?? 0,
      commentsCount: (data['commentsCount'] as num?)?.toInt() ?? 0,
      likedByMe: likedBy.contains(currentUserId),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'username': username,
      'content': content,
      'avatarUrl': avatarUrl,
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'likedBy': <String>[],
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      username: json['username'] as String,
      content: json['content'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      likesCount: (json['likesCount'] as num).toInt(),
      commentsCount: (json['commentsCount'] as num).toInt(),
      likedByMe: json['likedByMe'] == 1 || json['likedByMe'] == true,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'username': username,
      'content': content,
      'avatarUrl': avatarUrl,
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'likedByMe': likedByMe ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory PostModel.fromEntity(Post entity) {
    return PostModel(
      id: entity.id,
      userId: entity.userId,
      username: entity.username,
      content: entity.content,
      avatarUrl: entity.avatarUrl,
      likesCount: entity.likesCount,
      commentsCount: entity.commentsCount,
      likedByMe: entity.likedByMe,
      createdAt: entity.createdAt,
    );
  }

  Post toEntity() => Post(
        id: id,
        userId: userId,
        username: username,
        content: content,
        avatarUrl: avatarUrl,
        likesCount: likesCount,
        commentsCount: commentsCount,
        likedByMe: likedByMe,
        createdAt: createdAt,
      );
}
